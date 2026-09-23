import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/typedefs.dart';
import '../../dto/create_employees_dto.dart';
import '../../dto/create_employees_strings.dart';
import '../../dto/lm_column.dart';
import '../common/isol_utils.dart';
import '../common/sheet_employee_details.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolCreateEmployeesFile(String createEmployeesJson) {

  final CreateEmployeesDto createEmployeesDto = CreateEmployeesDto.fromJson(jsonDecode(createEmployeesJson));

  final LamodaEmployees lamodaEmployees = createEmployeesDto.lamodaEmployees;
  final Map<int, LmColumn> columns = createEmployeesDto.columns;
  final CreateEmployeesStrings strings = createEmployeesDto.createEmployeesStrings;

  try {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = getFirstNamedSheet(excel, strings.employeeDetails);

    fillOutSheetEmployeeDetails(
      sheet,
      lamodaEmployees,
      columns,
      strings.notFilledIn,
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