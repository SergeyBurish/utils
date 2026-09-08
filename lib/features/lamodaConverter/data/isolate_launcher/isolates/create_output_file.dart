import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:intl/intl.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/lamoda_entity.dart';
import '../../../domain/entity/shift_time.dart';
import '../../../domain/entity/typedefs.dart';
import '../../dto/create_output_dto.dart';
import '../../dto/create_output_strings.dart';
import '../../dto/lamoda_entity_dto.dart';
import '../../dto/lm_column.dart';
import '../../tablesData/consts.dart';
import '../common/isol_utils.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolCreateOutputFile(String createOutputJson) {

  final CreateOutputDto createOutputDto = CreateOutputDto.fromJson(jsonDecode(createOutputJson));

  final LamodaEntityDto lamodaEntityDto = createOutputDto.lamodaEntityDto;
  final LamodaTariffs lamodaTariffs = createOutputDto.lamodaTariffs;
  final Map<int, LmColumn> columnsFD1 = createOutputDto.columnsFD1;
  final Map<int, LmColumn> columnsFD2 = createOutputDto.columnsFD2;
  final Map<int, LmColumn> columnsED = createOutputDto.columnsED;
  final CreateOutputStrings strings = createOutputDto.createOutputStrings;

  final LamodaEntity lamodaEntity = lamodaEntityDto.toLamodaEntity();

  final List<ShiftTime> dates = lamodaEntity.shifts.keys.toList();
  final List<String> workNames = lamodaEntity.worksSet.toList();
  final List<String> logins = lamodaEntity.loginsSet.toList();
  final List<DateTime> tariffsDates = lamodaTariffs.keys.toList();
  if (dates.isEmpty || workNames.isEmpty) {
    return outputJson(error: 'no_data');
  }

  dates.sort();
  workNames.sort();
  logins.sort();
  tariffsDates.sort();

  if (tariffsDates.isEmpty) {
    tariffsDates.add(DateTime(0));
  }

  final String fromDate = strings.from + DateFormat('dd.MM.yy').format(dates[0].date);

  try {
    final Excel excel = Excel.createExcel(); // a new workbook with one default sheet Sheet1
    final Sheet sheetBT = getFirstNamedSheet(excel, strings.basicTariffs);
    final Sheet sheetFD = excel[fromDate];
    final Sheet sheetED = excel[strings.employeeDetails];

    fillOutTariffsSheet(
      sheet: sheetBT,
      lamodaTariffs: lamodaTariffs,
      works: workNames,
      strings: strings,
    );
    _fillOutSheetFromDate(
      sheet: sheetFD,
      lamodaEntity: lamodaEntity,
      workNames: workNames,
      logins: logins,
      dates: dates,
      tariffsDates: tariffsDates,
      strings: strings,
      columns1: columnsFD1,
      columns2: columnsFD2,
    );

    _fillOutSheetEmployeeDetails(sheetED, logins, columnsED);

    final List<int>? bytes = excel.encode();

    if (bytes != null) {
      return outputJson(bytes: bytes, fromDate: fromDate);
    } else {
      return outputJson(error: 'fail_create_excel_spreadsheet');
    }
  } on Exception catch (e) {
    return outputJson(error: 'fail_download_excel_file', errorArgs: <String>['$e']);
  }
}

void _fillOutSheetFromDate({
  required Sheet sheet,
  required LamodaEntity lamodaEntity,
  required List<String> workNames,
  required List<String> logins,
  required List<ShiftTime> dates,
  required List<DateTime> tariffsDates,
  required CreateOutputStrings strings,
  required Map<int, LmColumn> columns1,
  required Map<int, LmColumn> columns2,
}){
  sheet.setRowHeight(fHeaderRow, 130.0); // примерно
  // заголовок: столбцы до работ
  for(final MapEntry<int, LmColumn> el in columns1.entries){
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: el.key,
        rowIndex: fHeaderRow), 
      TextCellValue(el.value.name),
      cellStyle: CellStyle(
        rotation: el.value.rotation,
        backgroundColorHex: el.value.bgColor != null 
          ? ExcelColor.fromHexString(el.value.bgColor!) 
          : ExcelColor.none,
        bold: true,
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        textWrapping: TextWrapping.WrapText,
      ),
    );
  }
  for (int i = 0; i < workNames.length; i++) {
    // заголовок: столбцы работ
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: i + fStartWorks,
        rowIndex: fHeaderRow), 
      TextCellValue(workNames[i]),
      cellStyle: CellStyle(
        rotation: 90,
        textWrapping: TextWrapping.WrapText,
      ),
    );
  }

  // заголовок: столбцы после работ
  for(final MapEntry<int, LmColumn> el in columns2.entries){
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: el.key + fStartWorks + workNames.length,
        rowIndex: fHeaderRow), 
      TextCellValue(el.value.name),
      cellStyle: CellStyle(
        rotation: el.value.rotation,
        backgroundColorHex: el.value.bgColor != null 
          ? ExcelColor.fromHexString(el.value.bgColor!) 
          : ExcelColor.none,
        bold: true,
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        textWrapping: TextWrapping.WrapText,
      ),
    );
  }

  final CellStyle bidStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString(blue02),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
    topBorder: Border(borderStyle: BorderStyle.Thin),
  );

  // ставки
  for (int dateInd = 0; dateInd < tariffsDates.length; dateInd++) {
    final int row = fStartBidRow + dateInd;

    // "Ставка"
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: fDate,
        rowIndex: row), 
      TextCellValue(strings.bid),
      cellStyle: bidStyle,
    );

    // с "дата"
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: fShift,
        rowIndex: row), 
      TextCellValue(strings.from + DateFormat('dd.MM.yy').format(tariffsDates[dateInd])),
      cellStyle: bidStyle,
    );

    // ряд ставок - ссылки на лист "Базовые тарифы"
    for (int workInd = 0; workInd < workNames.length; workInd++) {

      final String bidIndexOnBasicTariffs = stringIndex(
        colInd: trStartColumn + dateInd * 3 + 1, // 1 - смещение "Тариф для расчета ЗП" от "Стоимость 1 услуги"
        rowInd: trStartRow + workInd);

      sheet.updateCell(CellIndex.indexByColumnRow(
          columnIndex: workInd + fStartWorks,
          rowIndex: row), 
        FormulaCellValue('\'${strings.basicTariffs}\'!$bidIndexOnBasicTariffs'),
        cellStyle: bidStyle,
      );
    }
  }

  final int startPeepsRow = fStartBidRow + tariffsDates.length;
  int row = startPeepsRow;

  // строки: дата, смена, логин, пики, формулы, итд
  for (final ShiftTime shiftTime in dates) {
    final WorkerShifts? workerShifts = lamodaEntity.shifts[shiftTime];

    if (workerShifts != null) {
      for (final MapEntry<String, Works> workerShift in workerShifts.entries) {
        final String login = workerShift.key;
        final int indexOflogin = logins.indexOf(login);
        _formRow(
          sheet: sheet,
          row: row++,
          shiftTime: shiftTime,
          login: login,
          works: workerShift.value,
          workNames: workNames,
          day: strings.day,
          night: strings.night,
          employeeDetails: strings.employeeDetails,
          indexOflogin: indexOflogin,
          tariffsDates: tariffsDates,
        );
      }
    }
  }

  sheet.setColumnAutoFit(fLogin);
  sheet.freezePanes(rows: startPeepsRow, columns: fIncreasedRate + 1);
}

void _fillOutSheetEmployeeDetails(
  Sheet sheet,
  List<String> logins,
  Map<int, LmColumn> columns,
){
  // заголовок
  for(final MapEntry<int, LmColumn> el in columns.entries){
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: el.key,
        rowIndex: edHeaderRow), 
      TextCellValue(el.value.name),
      cellStyle: CellStyle(
        rotation: el.value.rotation,
        backgroundColorHex: el.value.bgColor != null 
          ? ExcelColor.fromHexString(el.value.bgColor!) 
          : ExcelColor.none,
        bold: true,
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        textWrapping: TextWrapping.WrapText,
      ),
    );

    // колонка логинов
    for (int i = 0; i < logins.length; i++) {
      sheet.updateCell(CellIndex.indexByColumnRow(
          columnIndex: edLogin,
          rowIndex: i + edStartRow), 
        TextCellValue(logins[i]),
      );
    }
  }
  sheet.setColumnAutoFit(edLogin);
}

void _formRow({
  required Sheet sheet,
  required int row,
  required ShiftTime shiftTime,
  required String login,
  required Works works,
  required List<String> workNames,
  required String day,
  required String night,
  required String employeeDetails,
  required int indexOflogin,
  required List<DateTime> tariffsDates,
}){
  // дата
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fDate,
      rowIndex: row), 
    DateCellValue.fromDateTime(shiftTime.date),
    cellStyle: CellStyle(numberFormat: NumFormat.custom(formatCode: dateFormat)),
  );
  // смена
  sheet.updateCell(
    CellIndex.indexByColumnRow(
      columnIndex: fShift,
      rowIndex: row), 
    TextCellValue(shiftTime.day ? day : night),
  );
  // логин
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fLogin,
      rowIndex: row),
    TextCellValue(login),
  );
  if (indexOflogin > -1) {
    final String fullNameIndexOnEmployeeDetails = stringIndex(
      colInd: edFullName, 
      rowInd: indexOflogin + edStartRow);

    final String statusIndexOnEmployeeDetails = stringIndex(
      colInd: edStatus, 
      rowInd: indexOflogin + edStartRow);

    final String startDateOfWorkIndexOnEmployeeDetails = stringIndex(
      colInd: edStartDateOfWork, 
      rowInd: indexOflogin + edStartRow);

    // формула: Ф.И.О.
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: fFullName,
        rowIndex: row),
        FormulaCellValue('\'$employeeDetails\'!$fullNameIndexOnEmployeeDetails'),
    );
    // формула: статус.
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: fStatus,
        rowIndex: row),
        FormulaCellValue('\'$employeeDetails\'!$statusIndexOnEmployeeDetails'),
    );
    // формула: дата начала работы.
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: fStartDateColumn,
        rowIndex: row),
        FormulaCellValue('\'$employeeDetails\'!$startDateOfWorkIndexOnEmployeeDetails'),
        cellStyle: CellStyle(numberFormat: NumFormat.custom(formatCode: dateFormat)),
    );
  }  

  final String startDateIndex = stringIndex(colInd: fStartDateColumn, rowInd: row);

  // формула: фикс 4000 до
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fFixed4000Until,
      rowIndex: row), 
    FormulaCellValue('$startDateIndex+5'),
    cellStyle: CellStyle(numberFormat: NumFormat.custom(formatCode: dateFormat)),
  );

  // пики
  for (final MapEntry<String, int> work in works.entries) {
    final int workNameInd = workNames.indexOf(work.key);
    if (workNameInd > -1) {
      sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: workNameInd + fStartWorks,
        rowIndex: row), 
      IntCellValue(work.value));
    }
  }

  final int startFormulaColumn = fStartWorks + workNames.length;

  final String startIndex = stringIndex(colInd: fStartWorks, rowInd: row);
  final String endIndex = stringIndex(
    colInd: startFormulaColumn - 1,
    rowInd: row,
  );
  final String dataIndex = stringIndex(colInd: fDate, rowInd: row);
  final String fixed4000UntilIndex = stringIndex(colInd: fFixed4000Until, rowInd: row);
  final String fixed4000For5DaysIndex = stringIndex(
    colInd: fFixed4000For5Days + startFormulaColumn, 
    rowInd: row,
  );
  final String basedOnPeepsIndex = stringIndex(
    colInd: fAccruedPerShiftBasedOnNumberOfPeeps + startFormulaColumn, 
    rowInd: row,
  );
  final String forTrainingIndex = stringIndex(
    colInd: fAccruedForTraining + startFormulaColumn, 
    rowInd: row,
  );
  final String foremanIndex = stringIndex(
    colInd: fAccruedForeman + startFormulaColumn, 
    rowInd: row,
  );

  // формула: Всего количество пиков
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fTotalNumberPeeps + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('SUM($startIndex:$endIndex)'),
  );

  final String statusIndex = stringIndex(colInd: fStatus, rowInd: row);

  // формула: Начислено за обучение
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fAccruedForTraining + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('IF($statusIndex="ученик",4000,0)'),
  );
  // формула: Начислено за смену по количеству пиков
  final String formula = _accruedPerShiftFormula(
    sheet: sheet, 
    row: row, 
    startFormulaColumn: startFormulaColumn, 
    shiftDate: shiftTime.date,
    tariffsDates: tariffsDates,
  );
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fAccruedPerShiftBasedOnNumberOfPeeps + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue(formula),
  );
  // формула: Начислено БРИГАДИРСКИЕ
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fAccruedForeman + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('IF($statusIndex="бригадир",5000,0)'),
  );
  // формула: фикс 4000 - 5 дней
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fFixed4000For5Days + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('IF($dataIndex<=$fixed4000UntilIndex,4000,0)'),
  );
  // формула: Начислено всего 
  // ("фикс 4000 - 5 дней" или "за смену по количеству пиков") + "за обучение" + "БРИГАДИРСКИЕ"
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fTotalAccrued + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('IF($fixed4000For5DaysIndex>$basedOnPeepsIndex,$fixed4000For5DaysIndex,$basedOnPeepsIndex)+$forTrainingIndex+$foremanIndex'),
  );
}

String _accruedPerShiftFormula({
  required Sheet sheet,
  required int row,
  required int startFormulaColumn,
  required DateTime shiftDate,
  required List<DateTime> tariffsDates,
}){
  final List<String> list = <String>[];

  for (int col = fStartWorks; col < startFormulaColumn; col++) {
    int bidInd = tariffsDates.length -1;
    for (int i = bidInd; i >= 0; i--) {
      final DateTime tariffsDate = tariffsDates[i];
      if (shiftDate.isAfter(tariffsDate) || _isSameDay(shiftDate, tariffsDate)) {
        break;
      }
      bidInd--;
    }
    final int bidRow = fStartBidRow + bidInd;
    final String work = stringIndex(colInd: col, rowInd: row);
    final String bid = stringIndexFixed(colInd: col, rowInd: bidRow);
    list.add('$bid*$work');
  }
  return list.join('+');
}

bool _isSameDay(DateTime a, DateTime b) => 
  a.year == b.year && a.month == b.month && a.day == b.day;
