import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../dto/handle_excel_dto.dart';
import '../../dto/handle_penalties_output_dto.dart';
import '../../dto/penalty_entity_dto.dart';
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

    List<PenaltyEntityDto> penaltiesList = <PenaltyEntityDto>[];
    for (int row = penStartRow; ; row++) {
      final String? description = getTextCellValue(sheet, penDescription, row);
      if (description?.isEmpty ?? true) {
        break;
      }

      final double? price = getDoubleCellValue(sheet, penPrice, row);
      if (price == null) {
        break;
      }

      penaltiesList.add(PenaltyEntityDto(
          description: description!,
          price: price,
          amount: 1,
        )
      );
    }

    if (penaltiesList.isEmpty) {
      return _outputJson(error: 'no_data_found');
    }

    return _outputJson(penaltiesList: penaltiesList);
  } on Exception catch (e) {
    return _outputJson(error: 'fail_open_excel_file', errorArgs: <String>['$e']);
  }
}

String _outputJson({
  List<PenaltyEntityDto>? penaltiesList,
  String error = '',
  List<String> errorArgs = const <String>[]
}) {
  final HandlePenaltiesOutputDto tariffsOutput = HandlePenaltiesOutputDto(
    penaltiesList: penaltiesList,
    error: error,
    errorArgs: errorArgs);
  return jsonEncode(tariffsOutput.toJson());
}