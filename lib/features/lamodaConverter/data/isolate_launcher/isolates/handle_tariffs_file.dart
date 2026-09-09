import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/tariffs_entity.dart';
import '../../../domain/entity/typedefs.dart';
import '../../dto/handle_excel_dto.dart';
import '../../dto/handle_tariffs_output_dto.dart';
import '../../dto/tariffs_entity_dto.dart';
import '../../tablesData/consts.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolHandleTariffsFile(String handleExcelJson) {

  final HandleExcelDto handleExcelDto = HandleExcelDto.fromJson(jsonDecode(handleExcelJson));

  try {
    final Excel excel = Excel.decodeBytes(handleExcelDto.bytes);
    final String? firstSheetName = excel.tables.keys.firstOrNull;
    if (firstSheetName == null) {
      print('zzz firstSheetName == null');
      return _outputJson(error: 'no_data_found');
    }
    final Sheet sheet = excel[firstSheetName];
    final TariffsEntity tariffsEntity = TariffsEntity(
      lamodaTariffs: <DateTime, Tariffs>{},
      worksSet: <String>{},
    );
    for (int column = trStartColumn; ; column += 3) {
      final Data cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: trDateRow));
      final DateTime? dateTime = _tryParseDateTimeFromCell(cell.value);
      if (dateTime == null) {
        break;
      }

      tariffsEntity.lamodaTariffs[dateTime] = _getTariffs(sheet, column);
    }
    if (tariffsEntity.lamodaTariffs.isEmpty) {
      return _outputJson(error: 'no_data_found');
    }
    tariffsEntity.worksSet.addAll(_getWorksSet(sheet));
    return _outputJson(tariffsEntity: tariffsEntity);
  } on Exception catch (e) {
    return _outputJson(error: 'fail_open_excel_file', errorArgs: <String>['$e']);
  }
}

DateTime? _tryParseDateTimeFromCell(CellValue? value){
  if (value == null) {
    print('zzz _tryParseDateTimeFromCell value == null');
    return null;
  }

  print('zzz _tryParseDateTimeFromCell value ${value.toString()}');

  if (value is DateCellValue) {
    print('zzz _tryParseDateTimeFromCell value is DateCellValue');
    return value.asDateTimeLocal();
  }

  if (value is IntCellValue && value.value > 0) {
    print('zzz _tryParseDateTimeFromCell value is IntCellValue ${value.value}');
    return _intToDateTime(value.value);
  }

  if (value is DoubleCellValue && value.value >= 0.5) {
    print('zzz _tryParseDateTimeFromCell value is DoubleCellValue ${value.value}');
    return _intToDateTime(value.value.round());
  }

  final DateTime? date = DateTime.tryParse(value.toString());
  if (date != null) {
    print('zzz _tryParseDateTimeFromCell date != null; date.day ${date.day}');
    return date;
  }

  final List<String> dateParts = value.toString().split('.');
  print('zzz _tryParseDateTimeFromCell dateParts.length ${dateParts.length}');
  if (dateParts.length < 3) return null;

  final String formattedString = dateParts.reversed.join('-');

  print('zzz _tryParseDateTimeFromCell formattedString $formattedString');

  return DateTime.tryParse(formattedString);
}

// Excel's base epoch date (December 30, 1899)
DateTime? _intToDateTime(int days) => DateTime(1899, 12, 30).add(Duration(days: days));

Tariffs _getTariffs(Sheet sheet, int column, ){
  final Tariffs tariffs = <String, double>{};
  for (int row = trStartRow; ; row++) {
    final Data workCell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: trWorks, rowIndex: row));

    if (workCell.value == null || workCell.value.toString().isEmpty) {
      break;
    }

    final Data tariffCell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: column, rowIndex: row));

    if (tariffCell.value == null) {
      continue;
    }

    final double? tariff = double.tryParse(tariffCell.value.toString());
    if (tariff == null) {
      continue;
    }

    tariffs[workCell.value.toString()] = tariff;
  }
  
  return tariffs;
}

Set<String> _getWorksSet(Sheet sheet) {
  final Set<String> worksSet = <String>{};
  for (int row = trStartRow; ; row++) {
    final Data workCell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: trWorks, rowIndex: row));

    if (workCell.value == null || workCell.value.toString().isEmpty) {
      break;
    }

    worksSet.add(workCell.value.toString());
  }
  return worksSet;
}

String _outputJson({
  TariffsEntity? tariffsEntity,
  String error = '',
  List<String> errorArgs = const <String>[]
}) {
  final HandleTariffsOutputDto tariffsOutput = HandleTariffsOutputDto(
    tariffsEntityDto: tariffsEntity?.toDto(),
    error: error,
    errorArgs: errorArgs);
  return jsonEncode(tariffsOutput.toJson());
}