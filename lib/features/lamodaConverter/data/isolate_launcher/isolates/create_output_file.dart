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
  final Map<int, LmColumn> columnsFD1 = createOutputDto.columnsFD1;
  final Map<int, LmColumn> columnsFD2 = createOutputDto.columnsFD2;
  final Map<int, LmColumn> columnsED = createOutputDto.columnsED;
  final CreateOutputStrings strings = createOutputDto.createOutputStrings;

  final LamodaEntity lamodaEntity = lamodaEntityDto.toLamodaEntity();

  final List<ShiftTime> dates = lamodaEntity.shifts.keys.toList();
  final List<String> workNames = lamodaEntity.worksSet.toList();
  final List<String> logins = lamodaEntity.loginsSet.toList();
  if (dates.isEmpty || workNames.isEmpty) {
    return outputJson(error: 'no_data');
  }

  dates.sort();
  workNames.sort();
  logins.sort();

  final String fromDate = strings.from + DateFormat('dd.MM.yy').format(dates[0].date);

  try {
    final Excel excel = Excel.createExcel(); // a new workbook with one default sheet Sheet1
    final Sheet sheetBT = getFirstNamedSheet(excel, strings.basicTariffs);
    final Sheet sheetFD = excel[fromDate];
    final Sheet sheetED = excel[strings.employeeDetails];

    _fillOutSheetBasicTariffs(sheetBT, workNames, strings);
    _fillOutSheetFromDate(sheetFD, lamodaEntity, workNames, logins, dates, 
        strings, columnsFD1, columnsFD2);

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

void _fillOutSheetBasicTariffs(
  Sheet sheet,
  List<String> workNames,
  CreateOutputStrings strings,
){
  // заголовок: Process. ENG
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: btProcesses,
      rowIndex: btHeaderRow), 
    TextCellValue(strings.processEng),
    cellStyle: CellStyle(bold: true),
  );

  // заголовок: Тариф для расчета ЗП
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: btTtariffForWages,
      rowIndex: btHeaderRow), 
    TextCellValue(strings.tariffForWages),
    cellStyle: CellStyle(bold: true),
  );

  // столбец работ
  for (int i = 0; i < workNames.length; i++) {
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: btProcesses,
        rowIndex: i + btStartRow), 
      TextCellValue(workNames[i]),
    );
  }

  sheet.setColumnAutoFit(btProcesses);
  sheet.setColumnAutoFit(btTtariffForWages);
}

void _fillOutSheetFromDate(
  Sheet sheet,
  LamodaEntity lamodaEntity,
  List<String> workNames,
  List<String> logins,
  List<ShiftTime> dates,
  CreateOutputStrings strings,
  Map<int, LmColumn> columns1,
  Map<int, LmColumn> columns2,
){
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

    final String bidIndexOnBasicTariffs = stringIndex(
      colInd: btTtariffForWages, 
      rowInd: i + btStartRow);
    // подзаголовок: Ставка (формула)
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: i + fStartWorks,
        rowIndex: fBidRow),
      FormulaCellValue('\'${strings.basicTariffs}\'!$bidIndexOnBasicTariffs'),
      cellStyle: CellStyle(
        backgroundColorHex: ExcelColor.fromHexString(blue02)
      ),
    );
  }
  // подзаголовок: Ставка (текст)
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fDate,
      rowIndex: fBidRow), 
    TextCellValue(strings.bid),
  );

  // голубой бг для строки ставки
  final CellStyle blueCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString(blue02)
  );
  for (int i = fDate; i < fStartWorks; i++) {
    sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: i, 
      rowIndex: fBidRow,
    )).cellStyle = blueCellStyle;
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

  int row = fStartRow;

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
        );
      }
    }
  }

  sheet.setColumnAutoFit(fLogin);
  sheet.freezePanes(rows: fBidRow + 1, columns: fIncreasedRate + 1);
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
  final String formula = _accruedPerShiftFormula(sheet, row, startFormulaColumn);
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

String _accruedPerShiftFormula(
  Sheet sheet,
  int row,
  int startFormulaColumn,
){
  final List<String> list = <String>[];

  for (int col = fStartWorks; col < startFormulaColumn; col++) {
    final String work = stringIndex(colInd: col, rowInd: row);
    final String bid = stringIndexFixed(colInd: col, rowInd: fBidRow);
    list.add('$bid*$work');
  }
  return list.join('+');
}
