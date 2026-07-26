import 'dart:convert';

import 'package:excel_plus/excel_plus.dart';
import 'package:intl/intl.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../../domain/entity/lamoda_entity.dart';
import '../../../domain/entity/shift_time.dart';
import '../../../domain/entity/typedefs.dart';
import '../../consts.dart';
import '../../dto/create_output_dto.dart';
import '../../dto/create_output_strings.dart';
import '../../dto/file_output_dto.dart';
import '../../dto/lamoda_entity_dto.dart';

@pragma('vm:entry-point')
@isolateManagerWorker
String isolCreateOutputFile(String createOutputJson) {

  final CreateOutputDto createOutputDto = CreateOutputDto.fromJson(jsonDecode(createOutputJson));

  final LamodaEntityDto lamodaEntityDto = createOutputDto.lamodaEntityDto;
  final CreateOutputStrings strings = createOutputDto.createOutputStrings;
  final LamodaEntity lamodaEntity = lamodaEntityDto.toLamodaEntity();

  final List<ShiftTime> dates = lamodaEntity.shifts.keys.toList();
  final List<String> workNames = lamodaEntity.worksSet.toList();
  if (dates.isEmpty || workNames.isEmpty) {
    return _outputJson(error: 'no_data');
  }

  dates.sort();
  workNames.sort();

  final String fromDate = strings.from + DateFormat('dd.MM.yy').format(dates[0].date);

  try {
    final Excel excel = Excel.createExcel(); // a new workbook with one default sheet Sheet1
    final Sheet sheet = _getFromDateSheet(excel, fromDate);


    for (int i = 0; i < workNames.length; i++) {
      sheet.updateCell(CellIndex.indexByColumnRow(
          columnIndex: i + outStartColumn,
          rowIndex: outHeaderRow), 
        TextCellValue(workNames[i]),
        cellStyle: CellStyle(rotation: 90),
      );
    }

    int row = outStartRow;

    for (ShiftTime shiftTime in dates) {
      final WorkerShifts? workerShifts = lamodaEntity.shifts[shiftTime];

      if (workerShifts != null) {
        for (final MapEntry<String, Works> workerShift in workerShifts.entries) {
          _formRow(
            sheet, row++, shiftTime, workerShift.key, workerShift.value, workNames,
            strings.day, strings.night,
          );
        }
      }
    }

    final List<int>? bytes = excel.encode();

    if (bytes != null) {
      return _outputJson(bytes: bytes, fromDate: fromDate);
    } else {
      return _outputJson(error: 'fail_create_excel_spreadsheet');
    }
  } on Exception catch (e) {
    return _outputJson(error: 'fail_download_excel_file', errorArgs: <String>['$e']);
  }
}

void _formRow(
  Sheet sheet,
  int row,
  ShiftTime shiftTime,
  String login,
  Works works,
  List<String> workNames,
  String day,
  String night,
){

  final String dateFormatted = DateFormat('dd/MM/yy').format(shiftTime.date);
  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: outDateColumn,
      rowIndex: row), 
    TextCellValue(dateFormatted));

  sheet.updateCell(
    CellIndex.indexByColumnRow(
      columnIndex: outDayNightColumn,
      rowIndex: row), 
    TextCellValue(shiftTime.day ? day : night),
  );

  sheet.updateCell(CellIndex.indexByColumnRow(
      columnIndex: outLoginColumn,
      rowIndex: row), 
    TextCellValue(login));

  for (MapEntry<String, int> work in works.entries) {
    final int workNameInd = workNames.indexOf(work.key);
    if (workNameInd > -1) {
      sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: workNameInd + outStartColumn,
        rowIndex: row), 
      IntCellValue(work.value));
    }
  }
}

Sheet _getFromDateSheet(Excel excel, String fromDate) {
  if (excel.tables.isNotEmpty) {
    final String sheetName = excel.tables.keys.first;
    excel.rename(sheetName, fromDate);
  }
  return excel[fromDate];
}

String _outputJson({
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