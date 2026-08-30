import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:intl/intl.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/typedefs.dart';
import '../../dto/create_tariffs_dto.dart';
import '../../dto/create_tariffs_strings.dart';
import '../../tablesData/consts.dart';
import '../common/isol_utils.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolCreateTariffsFile(String createTariffsJson) {
  final CreateTariffsDto createTariffsDto = CreateTariffsDto.fromJson(jsonDecode(createTariffsJson));
  final LamodaTariffs lamodaTariffs = createTariffsDto.lamodaTariffs;
  final List<String> works = createTariffsDto.worksSet.toList();
  final CreateTariffsStrings strings = createTariffsDto.createTariffsStrings;

  works.sort();

  try {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = getFirstNamedSheet(excel, strings.tariffs);

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

    _fillOutWorks(works, sheet);

    final String coeffWagesIndex = stringIndexFixed(
      colInd: trCoeffVal, rowInd: trCoeffWages);

    final String coeffWages2mIndex = stringIndexFixed(
      colInd: trCoeffVal, rowInd: trCoeffWages2months);


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
        date: DateFormat(dateFormat).format(date),
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

    final List<int>? bytes = excel.encode();

    if (bytes != null) {
      return outputJson(bytes: bytes);
    } else {
      return outputJson(error: 'fail_create_excel_spreadsheet');
    }
  } on Exception catch (e) {
    return outputJson(error: 'fail_download_excel_file', errorArgs: <String>['$e']);
  }
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
    );

    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: tariffWages2mCol,
        rowIndex: trStartRow + i),
      FormulaCellValue('$cost1serviceIndex*$coeffWages2mIndex'),
    );
  }

  sheet.setColumnWidth(cost1serviceCol, 15);
  sheet.setColumnWidth(tariffWagesCol, 20);
  sheet.setColumnWidth(tariffWages2mCol, 25);
}