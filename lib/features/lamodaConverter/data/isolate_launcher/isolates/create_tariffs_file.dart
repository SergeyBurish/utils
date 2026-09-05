import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/typedefs.dart';
import '../../dto/create_tariffs_dto.dart';
import '../../dto/create_tariffs_strings.dart';
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

    fillOutTariffsSheet(
      sheet: sheet,
      lamodaTariffs: lamodaTariffs,
      works: works,
      strings: strings,
    );

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
