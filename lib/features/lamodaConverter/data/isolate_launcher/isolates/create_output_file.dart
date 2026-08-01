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
  final Map<int, LmColumn> columns = createOutputDto.columns;
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
    _fillOutSheetFromDate(sheetFD, lamodaEntity, workNames, dates, strings, columns);

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
      columnIndex: outBtProcessesColumn,
      rowIndex: outBtHeaderRow), 
    TextCellValue(strings.processEng),
    cellStyle: CellStyle(bold: true),
  );

  // заголовок: Тариф для расчета ЗП
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: outBtTtariffForWagesColumn,
      rowIndex: outBtHeaderRow), 
    TextCellValue(strings.tariffForWages),
    cellStyle: CellStyle(bold: true),
  );

  // столбец работ
  for (int i = 0; i < workNames.length; i++) {
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: outBtProcessesColumn,
        rowIndex: i + outBtStartRow), 
      TextCellValue(workNames[i]),
    );
  }

  sheet.setColumnAutoFit(outBtProcessesColumn);
  sheet.setColumnAutoFit(outBtTtariffForWagesColumn);
}

void _fillOutSheetFromDate(
  Sheet sheet,
  LamodaEntity lamodaEntity,
  List<String> workNames,
  List<ShiftTime> dates,
  CreateOutputStrings strings,
  Map<int, LmColumn> columns,
){
  sheet.setRowHeight(outHeaderRow, 130.0); // примерно
  for (int i = 0; i < workNames.length; i++) {
    // заголовок: столбцы работ
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: i + outStartColumn,
        rowIndex: outHeaderRow), 
      TextCellValue(workNames[i]),
      cellStyle: CellStyle(rotation: 90),
    );

    // подзаголовок: Ставка (числа)
    final String bidIndexOnBasicTariffs = _stringIndex(
      colInd: outBtTtariffForWagesColumn, 
      rowInd: i + outBtStartRow);
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: i + outStartColumn,
        rowIndex: outBidRow),
      FormulaCellValue('\'${strings.basicTariffs}\'!$bidIndexOnBasicTariffs'),
      cellStyle: CellStyle(
        backgroundColorHex: ExcelColor.fromHexString(blue)
      ),
    );
  }
  // подзаголовок: Ставка (текст)
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: outDateColumn,
      rowIndex: outBidRow), 
    TextCellValue(strings.bid),
  );

  // голубой бг для строки ставки
  final CellStyle blueCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString(blue)
  );
  for (int i = outDateColumn; i < outStartColumn; i++) {
    sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: i, 
      rowIndex: outBidRow,
    )).cellStyle = blueCellStyle;
  }

  final int startFormulaColumn = outStartColumn + workNames.length;

  // заголовок: столбцы формул
  for(final MapEntry<int, LmColumn> el in columns.entries){
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: el.key + startFormulaColumn,
        rowIndex: outHeaderRow), 
      TextCellValue(el.value.name),
      cellStyle: CellStyle(
        rotation: 90,
        backgroundColorHex: el.value.bgColor != null 
          ? ExcelColor.fromHexString(el.value.bgColor!) 
          : ExcelColor.none,
        bold: true,
        textWrapping: TextWrapping.WrapText,
      ),
    );
  }

  int row = outStartRow;

  // строки: дата, смена, логин, пики
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

  for (int i = outStartRow; i < row; i++) {
    final String startIndex = _stringIndex(colInd: outStartColumn, rowInd: i);
    final String endIndex = _stringIndex(
      colInd: startFormulaColumn - 1,
      rowInd: i,
    );

    // формула: Всего количество пиков
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: totalNumberPeeps + startFormulaColumn,
        rowIndex: i),
      FormulaCellValue('SUM($startIndex:$endIndex)'),
    );

    // формула: Начислено за смену по количеству пиков
    final String formula = _accruedPerShiftFormula(sheet, i, startFormulaColumn);
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: accruedPerShiftBasedOnNumberOfPeeps + startFormulaColumn,
        rowIndex: i),
      FormulaCellValue(formula),
    );
  }
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

  final String dateFormatted = DateFormat('dd/MM/yy').format(shiftTime.date);
  // дата
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: outDateColumn,
      rowIndex: row), 
    TextCellValue(dateFormatted));
  // смена
  sheet.updateCell(
    CellIndex.indexByColumnRow(
      columnIndex: outDayNightColumn,
      rowIndex: row), 
    TextCellValue(shiftTime.day ? day : night),
  );
  // логин
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: outLoginColumn,
      rowIndex: row), 
    TextCellValue(login));

  // пики
  for (final MapEntry<String, int> work in works.entries) {
    final int workNameInd = workNames.indexOf(work.key);
    if (workNameInd > -1) {
      sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: workNameInd + outStartColumn,
        rowIndex: row), 
      IntCellValue(work.value));
    }
  }
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

  for (int col = outStartColumn; col < startFormulaColumn; col++) {
    final String work = _stringIndex(colInd: col, rowInd: row);
    final String bid = _stringIndexFixed(colInd: col, rowInd: outBidRow);
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