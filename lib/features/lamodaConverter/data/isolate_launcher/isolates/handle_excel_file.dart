import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/lamoda_entity.dart';
import '../../../domain/entity/shift_time.dart';
import '../../../domain/entity/typedefs.dart';
import '../../consts.dart';
import '../../dto/handle_excel_dto.dart';
import '../../dto/handle_excel_output_dto.dart';
import '../../dto/lamoda_entity_dto.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolHandleExcelFile(String createOutputJson) {
  final HandleExcelDto handleExcelDto = HandleExcelDto.fromJson(jsonDecode(createOutputJson));

  try {
    final Excel excel = Excel.decodeBytes(handleExcelDto.bytes);

    if (excel.tables.keys.isNotEmpty) {
      final LamodaEntity lamodaEntity = _handleSalarySheet(excel);
      return _outputJson(lamodaEntityDto: lamodaEntity.toDto());
    } else {
      return _outputJson(error: 'blank_excel_file');
    }
  } on Exception catch (e) {
    return _outputJson(error: 'fail_open_excel_file', errorArgs: <String>['$e']);
  }
}

LamodaEntity _handleSalarySheet(Excel excel) {
  final LamodaShifts lamodaShifts = <ShiftTime, WorkerShifts>{};
  final Set<String> worksSet = <String>{};
  final LamodaEntity lamodaEntity = LamodaEntity(shifts: lamodaShifts, worksSet: worksSet);

  if (excel.tables.keys.contains(salarySheet)) {
    for (int column = startColumn; ; column++) {
      final Sheet sheet = excel[salarySheet];
      final Data cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: 0));
      if (cell.value is DateTimeCellValue) {
        final DateTimeCellValue dateTimeCellValue = cell.value as DateTimeCellValue;
        final DateTime dateTime = dateTimeCellValue.asDateTimeUtc();
        final ShiftTime shiftTime = ShiftTime(date: dateTime, day: dateTime.hour == 8);

        final WorkerShifts workerShifts = _handleDateColumn(sheet, column, worksSet);
        lamodaShifts[shiftTime] = workerShifts;
      } else {
        break;
      }
    }
  }

  return lamodaEntity;
}

WorkerShifts _handleDateColumn(Sheet sheet, int column, Set<String> worksSet,) {
  final WorkerShifts workerShifts = <String, Works>{};

  for (int row = startRow; ; row++) {
    final String? login = _getTextCellValue(sheet, loginColumn, row);
    if (login != null && login.isNotEmpty) {
      if (!workerShifts.keys.contains(login)) {
        workerShifts[login] = <String, int>{};
      }
      final Works? works = workerShifts[login];

      final int? workValue = _getIntCellValue(sheet, column, row);
      if (workValue != null) {
        final String? workName = _getTextCellValue(sheet, processColumn, row);
        if (workName != null && workName.isNotEmpty) {
          final String trimmedWorkName = _trimFcPrefix(workName);
          works?[trimmedWorkName] = workValue;
          worksSet.add(trimmedWorkName);
        }
      }
    } else {
      break;
    }
  }

  return workerShifts;
}

String? _getTextCellValue(Sheet sheet, int columnIndex, int rowIndex) {
  final Data textCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex));
  if (textCell.value is TextCellValue) {
    return (textCell.value as TextCellValue).value.text;
  }
  return null;
}

int? _getIntCellValue(Sheet sheet, int columnIndex, int rowIndex) {
  final Data textCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex));
  if (textCell.value is IntCellValue) {
    return (textCell.value as IntCellValue).value;
  }
  return null;
}

String _trimFcPrefix(String text) => 
  text.startsWith(fc2Prefix) ? text.replaceFirst(fc2Prefix, '') : text;

String _outputJson({
  LamodaEntityDto? lamodaEntityDto,
  String error = '',
  List<String> errorArgs = const <String>[]
}) {
  final HandleExcelOutputDto fileOutput = HandleExcelOutputDto(
    lamodaEntityDto: lamodaEntityDto,
    error: error,
    errorArgs: errorArgs);
  return jsonEncode(fileOutput.toJson());
}
