import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/employee_details.dart';
import '../../../domain/entity/typedefs.dart';
import '../../dto/handle_employees_output_dto.dart';
import '../../dto/handle_excel_dto.dart';
import '../../tablesData/consts.dart';
import '../common/isol_utils.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolHandleEmployeesFile(String handleExcelJson) {

  final HandleExcelDto handleExcelDto = HandleExcelDto.fromJson(jsonDecode(handleExcelJson));

  try {
    final Excel excel = Excel.decodeBytes(handleExcelDto.bytes);
    final String? firstSheetName = excel.tables.keys.firstOrNull;
    if (firstSheetName == null) {
      return _outputJson(error: 'no_data_found');
    }
    final Sheet sheet = excel[firstSheetName];
    final LamodaEmployees lamodaEmployees = <String, EmployeeDetails>{};

    for (int row = edStartRow; ; row++) {
      final String? login = getTextCellValue(sheet, edLogin, row);
      if (login?.isEmpty ?? true) {
        break;
      }

      final String? fullName = getTextCellValue(sheet, edFullName, row);
      final String? status = getTextCellValue(sheet, edStatus, row);

      final Data cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: edStartDateOfWork, rowIndex: row));
      final DateTime? dateTime = tryParseDateTimeFromCell(cell.value);

      lamodaEmployees[login!] = EmployeeDetails(
        fullName: fullName ?? '', 
        status: status ?? '', 
        startDateOfWork: dateTime
      );
    }

    if (lamodaEmployees.isEmpty) {
      return _outputJson(error: 'no_data_found');
    }

    return _outputJson(lamodaEmployees: lamodaEmployees);
  } on Exception catch (e) {
    return _outputJson(error: 'fail_open_excel_file', errorArgs: <String>['$e']);
  }
}

String _outputJson({
  LamodaEmployees? lamodaEmployees,
  String error = '',
  List<String> errorArgs = const <String>[]
}) {
  final HandleEmployeesOutputDto tariffsOutput = HandleEmployeesOutputDto.fromLamodaEmployees(
    lamodaEmployees: lamodaEmployees,
    error: error,
    errorArgs: errorArgs);
  return jsonEncode(tariffsOutput.toJson());
}