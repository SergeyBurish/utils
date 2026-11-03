import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/tariffs_entity.dart';
import '../../../domain/entity/typedefs.dart';
import '../../dto/handle_excel_dto.dart';
import '../../dto/handle_tariffs_output_dto.dart';
import '../../dto/tariffs_entity_dto.dart';
import '../../tablesData/consts.dart';
import '../common/isol_utils.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolHandleTariffsFile(String handleExcelJson) {

  final HandleExcelDto handleExcelDto = HandleExcelDto.fromJson(jsonDecode(handleExcelJson));

  try {
    final Excel excel = Excel.decodeBytes(handleExcelDto.bytes);
    final String? firstSheetName = excel.tables.keys.firstOrNull;
    if (firstSheetName == null) {
      return _outputJson(error: 'no_data_found');
    }
    final Sheet sheet = excel[firstSheetName];
    final TariffsEntity tariffsEntity = TariffsEntity(
      lamodaTariffs: <DateTime, Tariffs>{},
      worksSet: <String>{},
      nttWorksSet: <String>{},
    );
    for (int column = trStartColumn; ; column += 3) {
      final Data cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: trDateRow));
      final DateTime? dateTime = tryParseDateTimeFromCell(cell.value);
      if (dateTime == null) {
        break;
      }

      tariffsEntity.lamodaTariffs[dateTime] = _getTariffs(sheet, column);
    }
    if (tariffsEntity.lamodaTariffs.isEmpty) {
      return _outputJson(error: 'no_data_found');
    }

    final Set<String> worksSet = <String>{};
    final Set<String> nttWorksSet = <String>{};
    _getWorksSet(sheet, worksSet, nttWorksSet);
    tariffsEntity.worksSet.addAll(worksSet);
    tariffsEntity.nttWorksSet.addAll(nttWorksSet);

    return _outputJson(tariffsEntity: tariffsEntity);
  } on Exception catch (e) {
    return _outputJson(error: 'fail_open_excel_file', errorArgs: <String>['$e']);
  }
}

Tariffs _getTariffs(Sheet sheet, int column){
  final Tariffs tariffs = <String, double>{};

  int row = trStartRow;
  while (row > 0) {
    row = _getTariffsFromRow(row, sheet, column, tariffs);
    ({bool nttHeader, int row}) nextRow = _findNextTariffRow(row, sheet);
    if (nextRow.nttHeader) { // пропускаем nttHeader
      nextRow = _findNextTariffRow(nextRow.row + 1, sheet);
    }

    row = nextRow.row;
  }
  
  return tariffs;
}

int _getTariffsFromRow(int row, Sheet sheet, int column, Tariffs tariffs) {
  for ( ; ; row++) {
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

  return row;
}

void _getWorksSet(Sheet sheet, Set<String> worksSet, Set<String> nttWorksSet) {
  int row = trStartRow;
  while (row > 0) {
    row = _getWorksSetFromRow(row, sheet, worksSet);
    final ({bool nttHeader, int row}) nextRow = _findNextTariffRow(row, sheet);
    row = nextRow.row;
    if (nextRow.nttHeader) {
      row++;
      break;
    }
  }

  while (row > 0) {
    row = _getWorksSetFromRow(row, sheet, nttWorksSet);
    final ({bool nttHeader, int row}) nextRow = _findNextTariffRow(row, sheet);
    row = nextRow.row;
  }
}

int _getWorksSetFromRow(int row, Sheet sheet, Set<String> worksSet) {
  for (; ; row++) {
    final Data workCell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: trWorks, rowIndex: row));

    if (workCell.value == null || workCell.value.toString().isEmpty) {
      break;
    }

    worksSet.add(workCell.value.toString());
  }

  return row;
}

({int row, bool nttHeader}) _findNextTariffRow(int row, Sheet sheet) {
  for (int i = 0; i < 10; i++) { // поиск первой непустой в следующей десятке строк
    final Data workCell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: trWorks, rowIndex: row + i));
    if (workCell.value != null && workCell.value.toString().isNotEmpty) {
      return (row: row + i, nttHeader: workCell.value.toString() == nttHeader);
    }
  }
  
  return (row: -1, nttHeader: false);
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