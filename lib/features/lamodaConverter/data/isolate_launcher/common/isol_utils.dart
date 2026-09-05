import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/typedefs.dart';
import '../../dto/create_tariffs_strings.dart';
import '../../dto/file_output_dto.dart';
import '../../tablesData/consts.dart';

String outputJson({
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

Sheet getFirstNamedSheet(Excel excel, String name) {
  if (excel.tables.isNotEmpty) {
    final String sheetName = excel.tables.keys.first;
    excel.rename(sheetName, name);
  }
  return excel[name];
}

String stringIndex({required int colInd, required int rowInd,}) => 
  CellIndex.indexByColumnRow(columnIndex: colInd, rowIndex: rowInd).cellId;

String stringIndexFixed({required int colInd, required int rowInd,}) {
  final String ci = stringIndex(colInd: colInd, rowInd: rowInd);
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

void fillOutTariffsSheet({
  required Sheet sheet,
  required LamodaTariffs lamodaTariffs,
  required List<String> works,
  required CreateTariffsStrings strings,
}) {
  final CellStyle blueCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString(blue01),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
  );
  final CellStyle yellowCellStyle = CellStyle(
    backgroundColorHex: ExcelColor.fromHexString(yellow01),
    rightBorder: Border(borderStyle: BorderStyle.Thin),
  );

  // строки коэффициентов
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: trCoeffName,
      rowIndex: trCoeffWages), 
    TextCellValue(strings.coeffWages),
    cellStyle: blueCellStyle,
  );
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: trCoeffName,
      rowIndex: trCoeffWages2months), 
    TextCellValue(strings.coeffWages2months),
    cellStyle: yellowCellStyle,
  );
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: trCoeffVal,
      rowIndex: trCoeffWages), 
    const DoubleCellValue(0.6),
    cellStyle: blueCellStyle,
  );
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: trCoeffVal,
      rowIndex: trCoeffWages2months), 
    const DoubleCellValue(0.66),
    cellStyle: yellowCellStyle,
  );

  // строка дат
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: trWorks,
      rowIndex: trDateRow), 
    TextCellValue(strings.tariffStartDate),
    cellStyle: CellStyle(textWrapping: TextWrapping.WrapText)
  );

  // заголовок
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: trWorks,
      rowIndex: trHeaderRow), 
    TextCellValue(strings.processEng),
  );

  // столбец работ
  _fillOutWorks(works, sheet);

  final String coeffWagesIndex = stringIndexFixed(
    colInd: trCoeffVal, rowInd: trCoeffWages);

  final String coeffWages2mIndex = stringIndexFixed(
    colInd: trCoeffVal, rowInd: trCoeffWages2months);

  // столбцы дат с тарифами и формулами
  final List<DateTime> dates = lamodaTariffs.keys.toList();
  if (dates.isEmpty) {
    _fillOutDate(
      sheet: sheet,
      date: strings.shouldBeDateHere,
      cost1serviceCol: trStartColumn,
      works: works,
      coeffWagesIndex: coeffWagesIndex,
      coeffWages2mIndex: coeffWages2mIndex,
      strings: strings,
    );
  }

  dates.sort();

  for (int i = 0; i < dates.length; i++) {
    final DateTime date = dates[i];
    _fillOutDate(
      sheet: sheet,
      date: DateFormat(dateFormat2).format(date),
      cost1serviceCol: trStartColumn + i * 3,
      works: works,
      coeffWagesIndex: coeffWagesIndex,
      coeffWages2mIndex: coeffWages2mIndex,
      strings: strings,
      tariffs: lamodaTariffs[date],
    );
  }

  sheet.setColumnWidth(trWorks, 40);
  sheet.setRowHeight(trDateRow, 25);
  sheet.setRowHeight(trHeaderRow, 25);
}

void _fillOutWorks(List<String> works, Sheet sheet) {
  for (int i = 0; i < works.length; i++) {
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: trWorks,
        rowIndex: trStartRow + i), 
      TextCellValue(works[i]),
    );
  }
}

void _fillOutDate({
  required Sheet sheet,
  required String date,
  required int cost1serviceCol,
  required List<String> works,
  required String coeffWagesIndex,
  required String coeffWages2mIndex,
  required CreateTariffsStrings strings,
  Tariffs? tariffs,
}) {
  final int tariffWagesCol = cost1serviceCol + 1;
  final int tariffWages2mCol = cost1serviceCol + 2;

  // дата
  sheet.merge(
    CellIndex.indexByColumnRow(
      columnIndex: cost1serviceCol,
      rowIndex: trDateRow),
    CellIndex.indexByColumnRow(
      columnIndex: tariffWages2mCol,
      rowIndex: trDateRow),
    customValue: TextCellValue(date),
  );

  sheet.cell(CellIndex.indexByColumnRow(
    columnIndex: cost1serviceCol, 
    rowIndex: trDateRow,
  )).cellStyle = CellStyle(
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  // 3 подзаголовка под датой
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: cost1serviceCol,
      rowIndex: trHeaderRow), 
    TextCellValue(strings.cost1service),
    cellStyle: CellStyle(
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      textWrapping: TextWrapping.WrapText,
    ),
  );
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: tariffWagesCol,
      rowIndex: trHeaderRow), 
    TextCellValue(strings.tariffWages),
    cellStyle: CellStyle(
      backgroundColorHex: ExcelColor.fromHexString(yellow03),
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      textWrapping: TextWrapping.WrapText,
    ),
  );
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: tariffWages2mCol,
      rowIndex: trHeaderRow), 
    TextCellValue(strings.tariffWages2months),
    cellStyle: CellStyle(
      backgroundColorHex: ExcelColor.fromHexString(green01),
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      textWrapping: TextWrapping.WrapText,
    ),
  );

  // тарифы, формулы для всех работ
  for (int i = 0; i < works.length; i++) {
    // тариф
    if(tariffs != null) {
      final double? tariff = tariffs[works[i]];
      if (tariff != null) {
        sheet.updateCell(CellIndex.indexByColumnRow(
            columnIndex: cost1serviceCol,
            rowIndex: trStartRow + i),
          DoubleCellValue(tariff),
        );
      }
    }
    // формулы
    final String cost1serviceIndex = stringIndex(
      colInd: cost1serviceCol, rowInd: trStartRow + i);

    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: tariffWagesCol,
        rowIndex: trStartRow + i),
      FormulaCellValue('$cost1serviceIndex*$coeffWagesIndex'),
      cellStyle: CellStyle(
        backgroundColorHex: ExcelColor.fromHexString(orange),
        leftBorder: Border(borderStyle: BorderStyle.Thin),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
      ),
    );

    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: tariffWages2mCol,
        rowIndex: trStartRow + i),
      FormulaCellValue('$cost1serviceIndex*$coeffWages2mIndex'),
      cellStyle: CellStyle(
        backgroundColorHex: ExcelColor.fromHexString(green02),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
      ),
    );
  }

  sheet.setColumnWidth(cost1serviceCol, 15);
  sheet.setColumnWidth(tariffWagesCol, 20);
  sheet.setColumnWidth(tariffWages2mCol, 25);
}