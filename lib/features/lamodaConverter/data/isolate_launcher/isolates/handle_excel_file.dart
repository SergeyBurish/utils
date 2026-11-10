import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/amount_price.dart';
import '../../../domain/entity/employee_details.dart';
import '../../../domain/entity/lamoda_entity.dart';
import '../../../domain/entity/shift_time.dart';
import '../../../domain/entity/typedefs.dart';
import '../../dto/handle_excel_dto.dart';
import '../../dto/handle_excel_output_dto.dart';
import '../../dto/lamoda_entity_dto.dart';
import '../../tablesData/consts.dart';
import '../common/isol_utils.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolHandleExcelFile(String handleExcelJson) {
  final HandleExcelDto handleExcelDto = HandleExcelDto.fromJson(jsonDecode(handleExcelJson));

  try {
    final Excel excel = Excel.decodeBytes(handleExcelDto.bytes);

    if (excel.tables.keys.isNotEmpty) {
      final LamodaEntity lamodaEntity = _handleSalarySheet(excel);
      final LamodaEntity lamodaEntityNtt = _handleNttSheet(excel);
      lamodaEntity.nttShifts.addAll(lamodaEntityNtt.nttShifts);
      lamodaEntity.nttWorksSet.addAll(lamodaEntityNtt.nttWorksSet);
      lamodaEntity.lamodaEmployees.addAll(lamodaEntityNtt.lamodaEmployees);
      
      if (lamodaEntity.isEmpty) {
        return _outputJson(error: 'no_data_found');
      }

      lamodaEntity.lamodaPenalties.addAll(_handleMistakesSheet(excel));

      return _outputJson(lamodaEntityDto: lamodaEntity.toDto());
    } else {
      return _outputJson(error: 'no_data_found');
    }
  } on Exception catch (e) {
    return _outputJson(error: 'fail_open_excel_file', errorArgs: <String>['$e']);
  }
}

LamodaEntity _handleSalarySheet(Excel excel) {
  final LamodaShifts lamodaShifts = <ShiftTime, WorkerShifts>{};
  final LamodaEmployees lamodaEmployees = <String, EmployeeDetails>{};
  final Set<String> worksSet = <String>{};
  final LamodaEntity lamodaEntity = LamodaEntity(
    shifts: lamodaShifts,
    nttShifts: <ShiftTime, WorkerShifts>{},
    lamodaPenalties: <ShiftTime, WorkerPenalties>{},
    lamodaEmployees: lamodaEmployees,
    worksSet: worksSet,
    nttWorksSet: <String>{},
  );

  if (excel.tables.keys.contains(salarySheet)) {
    final Sheet sheet = excel[salarySheet];
    for (int column = saStartColumn; ; column++) {
      final Data cell = sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: column, rowIndex: saHeaderRow));
      if (cell.value is DateTimeCellValue) {
        final DateTimeCellValue dateTimeCellValue = cell.value as DateTimeCellValue;
        final DateTime dateTime = dateTimeCellValue.asDateTimeUtc();
        final ShiftTime shiftTime = ShiftTime(date: dateTime, day: dateTime.hour == 8);

        final WorkerShifts workerShifts = _handleDateColumn(sheet, column, worksSet, lamodaEmployees);
        lamodaShifts[shiftTime] = workerShifts;
      } else {
        break;
      }
    }
  }

  return lamodaEntity;
}

LamodaEntity _handleNttSheet(Excel excel) {
  final LamodaShifts lamodaShifts = <ShiftTime, WorkerShifts>{};
  final LamodaEmployees lamodaEmployees = <String, EmployeeDetails>{};
  final LamodaEntity lamodaEntity = LamodaEntity(
    shifts: <ShiftTime, WorkerShifts>{},
    nttShifts: lamodaShifts,
    lamodaPenalties: <ShiftTime, WorkerPenalties>{},
    lamodaEmployees: lamodaEmployees,
    worksSet: <String>{},
    nttWorksSet: <String>{nttOperations},
  );

  if (excel.tables.keys.contains(nttSheet)) {
    final Sheet sheet = excel[nttSheet];
    for (int column = ntStartColumn; ; column++) {
      final Data cell = sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: column, rowIndex: ntHeaderRow));
      if (cell.value is DateTimeCellValue) {
        final DateTimeCellValue dateTimeCellValue = cell.value as DateTimeCellValue;
        final DateTime dateTime = dateTimeCellValue.asDateTimeUtc();
        final ShiftTime shiftTime = ShiftTime(date: dateTime, day: dateTime.hour == 8);

        final WorkerShifts workerShifts = _handleNttDateColumn(sheet, column, lamodaEmployees);
        lamodaShifts[shiftTime] = workerShifts;
      } else {
        break;
      }
    }
  }

  return lamodaEntity;
}

LamodaPenalties _handleMistakesSheet(Excel excel) {
  final LamodaPenalties lamodaPenalties = <ShiftTime, WorkerPenalties>{};

  if (excel.tables.keys.contains(mistakesSheet)) {
    final Sheet sheet = excel[mistakesSheet];

    for (int row = mistStartRow; ; row++) {
      final DateTime? date = getDateCellValue(sheet, mistData, row);
      if (date == null) {
        break;
      }

      final String? login = getTextCellValue(sheet, mistLogin, row);
      if (login == null) {
        break;
      }

      final String? description = getTextCellValue(sheet, mistDescr, row);
      if (description == null) {
        break;
      }

      final int? amount = getIntCellValue(sheet, mistAamount, row);
      if (amount == null || amount < 1) {
        break;
      }

      final bool day = getTextCellValue(sheet, mistDayNight, row) == mistDay;
      final ShiftTime shiftTime = ShiftTime(date: date, day: day);

      final WorkerPenalties workerPenalties = lamodaPenalties[shiftTime] ?? <String, Penalties>{};
      if (!lamodaPenalties.containsKey(shiftTime)) {
        lamodaPenalties[shiftTime] = workerPenalties;
      }

      final Penalties penalties = workerPenalties[login] ?? <String, AmountPrice>{};
      if (!workerPenalties.containsKey(login)) {
        workerPenalties[login] = penalties;
      }

      final int currentAmount = penalties[description]?.amount ?? 0;
      penalties[description] = AmountPrice(amount: currentAmount + amount);
    }
  }

  return lamodaPenalties;
}

WorkerShifts _handleDateColumn(Sheet sheet, int column, Set<String> worksSet, LamodaEmployees lamodaEmployees) {
  final WorkerShifts workerShifts = <String, Works>{};

  for (int row = saStartRow; ; row++) {
    final String? login = getTextCellValue(sheet, saLogin, row);
    if (login != null && login.isNotEmpty) {
      lamodaEmployees.putIfAbsent(login, ()=>EmployeeDetails());

      final int? workValue = getIntCellValue(sheet, column, row);
      if (workValue != null) {
        final String? workName = getTextCellValue(sheet, saProcess, row);
        if (workName != null && workName.isNotEmpty) {
          final String trimmedWorkName = _trimFcPrefix(workName);

          if (!workerShifts.keys.contains(login)) {
            workerShifts[login] = <String, int>{};
          }
          final Works? works = workerShifts[login];

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

WorkerShifts _handleNttDateColumn(Sheet sheet, int column, LamodaEmployees lamodaEmployees) {
  final WorkerShifts workerShifts = <String, Works>{};

  for (int row = ntStartRow; ; row++) {
    final String? login = getTextCellValue(sheet, ntLogin, row);
    if (login != null && login.isNotEmpty) {
      lamodaEmployees.putIfAbsent(login, ()=>EmployeeDetails());
      
      final int? workValue = getIntCellValue(sheet, column, row);
      if (workValue != null) {
        if (!workerShifts.keys.contains(login)) {
          workerShifts[login] = <String, int>{};
        }
        final Works? works = workerShifts[login];

        works?[nttOperations] = workValue;
      }
    } else {
      break;
    }
  }

  return workerShifts;
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
