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