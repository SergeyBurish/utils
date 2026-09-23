import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';

import '../../dto/file_output_dto.dart';

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

String? getTextCellValue(Sheet sheet, int columnIndex, int rowIndex) {
  final Data textCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex));
  if (textCell.value is TextCellValue) {
    return (textCell.value as TextCellValue).value.text;
  }
  return null;
}

DateTime? tryParseDateTimeFromCell(CellValue? value){
  if (value == null) {
    return null;
  }

  if (value is DateCellValue) {
    return value.asDateTimeLocal();
  }

  if (value is IntCellValue && value.value > 0) {
    return _intToDateTime(value.value);
  }

  if (value is DoubleCellValue && value.value >= 0.5) {
    return _intToDateTime(value.value.round());
  }

  final DateTime? date = DateTime.tryParse(value.toString());
  if (date != null) {
    return date;
  }

  final List<String> dateParts = value.toString().split('.');
  if (dateParts.length < 3) return null;

  final String formattedString = dateParts.reversed.join('-');
  return DateTime.tryParse(formattedString);
}

// Excel's base epoch date (December 30, 1899)
DateTime? _intToDateTime(int days) => DateTime(1899, 12, 30).add(Duration(days: days));

