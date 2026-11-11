import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../dto/amount_price_dto.dart';
import '../../dto/handle_excel_dto.dart';
import '../../dto/handle_penalties_output_dto.dart';
import '../../dto/typedefs_dto.dart';
import '../../tablesData/consts.dart';
import '../common/isol_utils.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolHandlePenaltiesFile(String handleExcelJson) {
  final HandleExcelDto handleExcelDto = HandleExcelDto.fromJson(jsonDecode(handleExcelJson));

  try {
    final Excel excel = Excel.decodeBytes(handleExcelDto.bytes);
    final String? firstSheetName = excel.tables.keys.firstOrNull;
    if (firstSheetName == null) {
      return _outputJson(error: 'no_data_found');
    }
    final Sheet sheet = excel[firstSheetName];

    final PenaltiesDto penalties = <String, AmountPriceDto>{};
    for (int row = penStartRow; ; row++) {
      final String? description = getTextCellValue(sheet, penDescription, row);
      if (description?.isEmpty ?? true) {
        break;
      }

      final double? price = getDoubleCellValue(sheet, penPrice, row);
      if (price == null) {
        break;
      }

      penalties[description!] = AmountPriceDto(price: price, amount: 1);
    }

    if (penalties.isEmpty) {
      return _outputJson(error: 'no_data_found');
    }

    return _outputJson(penalties: penalties);
  } on Exception catch (e) {
    return _outputJson(error: 'fail_open_excel_file', errorArgs: <String>['$e']);
  }
}

String _outputJson({
  PenaltiesDto? penalties,
  String error = '',
  List<String> errorArgs = const <String>[]
}) {
  final HandlePenaltiesOutputDto tariffsOutput = HandlePenaltiesOutputDto(
    penalties: penalties,
    error: error,
    errorArgs: errorArgs);
  return jsonEncode(tariffsOutput.toJson());
}