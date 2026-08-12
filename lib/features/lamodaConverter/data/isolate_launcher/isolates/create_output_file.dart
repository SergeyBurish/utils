import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:intl/intl.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/lamoda_entity.dart';
import '../../../domain/entity/shift_time.dart';
import '../../../domain/entity/typedefs.dart';
import '../../dto/create_output_dto.dart';
import '../../dto/create_output_strings.dart';
import '../../dto/file_output_dto.dart';
import '../../dto/lamoda_entity_dto.dart';
import '../../dto/lm_column.dart';
import '../../tablesData/consts.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolCreateOutputFile(String createOutputJson) {

  final CreateOutputDto createOutputDto = CreateOutputDto.fromJson(jsonDecode(createOutputJson));

  final LamodaEntityDto lamodaEntityDto = createOutputDto.lamodaEntityDto;
  final Map<int, LmColumn> columns1 = createOutputDto.columns1;
  final Map<int, LmColumn> columns2 = createOutputDto.columns2;
  final CreateOutputStrings strings = createOutputDto.createOutputStrings;

  final LamodaEntity lamodaEntity = lamodaEntityDto.toLamodaEntity();

  final List<ShiftTime> dates = lamodaEntity.shifts.keys.toList();
  final List<String> workNames = lamodaEntity.worksSet.toList();
  if (dates.isEmpty || workNames.isEmpty) {
    return _outputJson(error: 'no_data');
  }

  dates.sort();
  workNames.sort();

  final String fromDate = strings.from + DateFormat('dd.MM.yy').format(dates[0].date);

  try {
    final Excel excel = Excel.createExcel(); // a new workbook with one default sheet Sheet1
    final Sheet sheetBT = _getFirstNamedSheet(excel, strings.basicTariffs);
    final Sheet sheetFD = excel[fromDate];

    _fillOutSheetBasicTariffs(sheetBT, workNames, strings);
    _fillOutSheetFromDate(sheetFD, lamodaEntity, workNames, dates, 
        strings, columns1, columns2);

    final List<int>? bytes = excel.encode();

    if (bytes != null) {
      return _outputJson(bytes: bytes, fromDate: fromDate);
    } else {
      return _outputJson(error: 'fail_create_excel_spreadsheet');
    }
  } on Exception catch (e) {
    return _outputJson(error: 'fail_download_excel_file', errorArgs: <String>['$e']);
  }
}

void _fillOutSheetBasicTariffs(
  Sheet sheet,
  List<String> workNames,
  CreateOutputStrings strings,
){
  // заголовок: Process. ENG
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: btProcessesColumn,
      rowIndex: btHeaderRow), 
    TextCellValue(strings.processEng),
    cellStyle: CellStyle(bold: true),
  );

  // заголовок: Тариф для расчета ЗП
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: btTtariffForWagesColumn,
      rowIndex: btHeaderRow), 
    TextCellValue(strings.tariffForWages),
    cellStyle: CellStyle(bold: true),
  );

  // столбец работ
  for (int i = 0; i < workNames.length; i++) {
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: btProcessesColumn,
        rowIndex: i + btStartRow), 
      TextCellValue(workNames[i]),
    );
  }

  sheet.setColumnAutoFit(btProcessesColumn);
  sheet.setColumnAutoFit(btTtariffForWagesColumn);
}

void _fillOutSheetFromDate(
  Sheet sheet,
  LamodaEntity lamodaEntity,
  List<String> workNames,
  List<ShiftTime> dates,
  CreateOutputStrings strings,
  Map<int, LmColumn> columns1,
  Map<int, LmColumn> columns2,
){
  sheet.setRowHeight(headerRow, 130.0); // примерно
  // заголовок: столбцы до работ
  for(final MapEntry<int, LmColumn> el in columns1.entries){
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: el.key,
        rowIndex: headerRow), 
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
        columnIndex: i + startWorksColumn,
        rowIndex: headerRow), 
      TextCellValue(workNames[i]),
      cellStyle: CellStyle(
        rotation: 90,
        textWrapping: TextWrapping.WrapText,
      ),
    );

    // подзаголовок: Ставка (числа)
    final String bidIndexOnBasicTariffs = _stringIndex(
      colInd: btTtariffForWagesColumn, 
      rowInd: i + btStartRow);
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: i + startWorksColumn,
        rowIndex: bidRow),
      FormulaCellValue('\'${strings.basicTariffs}\'!$bidIndexOnBasicTariffs'),
      cellStyle: CellStyle(
        backgroundColorHex: ExcelColor.fromHexString(blue02)
      ),
    );
  }
  // подзаголовок: Ставка (текст)
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: dateColumn,
      rowIndex: bidRow), 
    TextCellValue(strings.bid),
  );

  // голубой бг для строки ставки
  final CellStyle blueCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString(blue02)
  );
  for (int i = dateColumn; i < startWorksColumn; i++) {
    sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: i, 
      rowIndex: bidRow,
    )).cellStyle = blueCellStyle;
  }

  // заголовок: столбцы после работ
  for(final MapEntry<int, LmColumn> el in columns2.entries){
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: el.key + startWorksColumn + workNames.length,
        rowIndex: headerRow), 
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

  int row = outStartRow;

  // строки: дата, смена, логин, пики, формулы, итд
  for (final ShiftTime shiftTime in dates) {
    final WorkerShifts? workerShifts = lamodaEntity.shifts[shiftTime];

    if (workerShifts != null) {
      for (final MapEntry<String, Works> workerShift in workerShifts.entries) {
        _formRow(
          sheet, row++, shiftTime, workerShift.key, workerShift.value, workNames,
          strings.day, strings.night,
        );
      }
    }
  }

  sheet.setColumnAutoFit(outLoginColumn);
  sheet.freezePanes(rows: bidRow + 1, columns: increasedRateColumn + 1);
}

void _formRow(
  Sheet sheet,
  int row,
  ShiftTime shiftTime,
  String login,
  Works works,
  List<String> workNames,
  String day,
  String night,
){
  // дата
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: dateColumn,
      rowIndex: row), 
    DateCellValue.fromDateTime(shiftTime.date),
    cellStyle: CellStyle(numberFormat: NumFormat.custom(formatCode: dateFormat)),
  );
  // смена
  sheet.updateCell(
    CellIndex.indexByColumnRow(
      columnIndex: shiftColumn,
      rowIndex: row), 
    TextCellValue(shiftTime.day ? day : night),
  );
  // логин
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: outLoginColumn,
      rowIndex: row), 
    TextCellValue(login)
  );

  final String statusDataIndex = _stringIndex(colInd: statusStartDateColumn, rowInd: row);

  // фикс 4000 до
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: fixed4000UntilColumn,
      rowIndex: row), 
    FormulaCellValue('$statusDataIndex+5'),
    cellStyle: CellStyle(numberFormat: NumFormat.custom(formatCode: dateFormat)),
  );

  // пики
  for (final MapEntry<String, int> work in works.entries) {
    final int workNameInd = workNames.indexOf(work.key);
    if (workNameInd > -1) {
      sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: workNameInd + startWorksColumn,
        rowIndex: row), 
      IntCellValue(work.value));
    }
  }

  final int startFormulaColumn = startWorksColumn + workNames.length;

  // формула: Всего количество пиков
  final String startIndex = _stringIndex(colInd: startWorksColumn, rowInd: row);
  final String endIndex = _stringIndex(
    colInd: startFormulaColumn - 1,
    rowInd: row
  );
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: totalNumberPeeps + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('SUM($startIndex:$endIndex)'),
  );
  // формула: Начислено за обучение
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: accruedForTraining + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('IF($statusDataIndex="ученик",4000,0)'),
  );
  // формула: Начислено за смену по количеству пиков
  final String formula = _accruedPerShiftFormula(sheet, row, startFormulaColumn);
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: accruedPerShiftBasedOnNumberOfPeeps + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue(formula),
  );
  // формула: Начислено БРИГАДИРСКИЕ
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: accruedForeman + startFormulaColumn,
      rowIndex: row),
    FormulaCellValue('IF($statusDataIndex="бригадир",5000,0)'),
  );
}

Sheet _getFirstNamedSheet(Excel excel, String name) {
  if (excel.tables.isNotEmpty) {
    final String sheetName = excel.tables.keys.first;
    excel.rename(sheetName, name);
  }
  return excel[name];
}

String _accruedPerShiftFormula(
  Sheet sheet,
  int row,
  int startFormulaColumn,
){
  final List<String> list = <String>[];

  for (int col = startWorksColumn; col < startFormulaColumn; col++) {
    final String work = _stringIndex(colInd: col, rowInd: row);
    final String bid = _stringIndexFixed(colInd: col, rowInd: bidRow);
    list.add('$bid*$work');
  }
  return list.join('+');
}

String _stringIndex({required int colInd, required int rowInd,}) => 
  CellIndex.indexByColumnRow(columnIndex: colInd, rowIndex: rowInd).cellId;

String _stringIndexFixed({required int colInd, required int rowInd,}) {
  final String ci = _stringIndex(colInd: colInd, rowInd: rowInd);
  int index = ci.length-1;
  for (; index > 0; index--) {
    final String lt = ci[index];
    if (!RegExp(r'^\d$').hasMatch(lt)) { // RegExp of one digit
      break;
    }
  }

  index++; // коррекция: на последней итерации уже не цифра
  
  return '\$${ci.substring(0, index)}\$${ci.substring(index)}';
}

String _outputJson({
  List<int> bytes = const <int>[],
  String fromDate = '',
  String error = '',
  List<String> errorArgs = const <String>[]
}) {
  final FileOutputDto fileOutput = FileOutputDto(
    bytes: bytes,
    fromDate: fromDate,
    error: error,
    errorArgs: errorArgs);
  return jsonEncode(fileOutput.toJson());
}