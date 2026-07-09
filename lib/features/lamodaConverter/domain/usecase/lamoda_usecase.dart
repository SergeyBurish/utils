import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel_plus/excel_plus.dart';

import '../entity/lamoda_entity.dart';
import '../entity/shift_time.dart';
import '../entity/typedefs.dart';
import '../repository/lamoda_repository.dart';

const String _salarySheet = 'Salary';
const int _processColumn = 0;
const int _loginColumn = 1;
const int _startColumn = 3;
const int _startRow = 1;
const String _fc2Prefix = 'FC2_';

const int _outDateColumn = 0;
const int _outDayNightColumn = 1;
const int _outLoginColumn = 3;
const int _outStartColumn = 7;
const int _outStartRow = 1;
const int _outHeaderRow = 0;

const String _fileNamePrefix = 'picksLamoda';

abstract interface class LamodaUsecase{
    Future<Either<String, LamodaEntity>> handleExcelFile(Uint8List bytes);
    Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity);
}
class LamodaUsecaseImp implements LamodaUsecase{
  final LamodaRepository repository;

  LamodaUsecaseImp({required this.repository});
  
  @override
  Future<Either<String, LamodaEntity>> handleExcelFile(Uint8List bytes) async {
      try {
        final Excel excel = Excel.decodeBytes(bytes);

        if (excel.tables.keys.isNotEmpty) {
          final LamodaEntity lamodaShifts = _handleSalarySheet(excel);
          return Right<String, LamodaEntity>(lamodaShifts);
        } else {
          return Left<String, LamodaEntity>('blank_excel_file'.tr());
        }
      } on Exception catch (e) {
        return Left<String, LamodaEntity>('fail_open_excel_file'.tr(args: <String>['$e']),);
      }
  }

  LamodaEntity _handleSalarySheet(Excel excel) {
    final LamodaShifts lamodaShifts = <ShiftTime, WorkerShifts>{};
    final Set<String> worksSet = <String>{};
    final LamodaEntity lamodaEntity = LamodaEntity(shifts: lamodaShifts, worksSet: worksSet);

    if (excel.tables.keys.contains(_salarySheet)) {
      for (int column = _startColumn; ; column++) {
        final Sheet sheet = excel[_salarySheet];
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

    for (int row = _startRow; ; row++) {
      final String? login = _getTextCellValue(sheet, _loginColumn, row);
      if (login != null && login.isNotEmpty) {
        if (!workerShifts.keys.contains(login)) {
          workerShifts[login] = <String, int>{};
        }
        final Works? works = workerShifts[login];

        final int? workValue = _getIntCellValue(sheet, column, row);
        if (workValue != null) {
          final String? workName = _getTextCellValue(sheet, _processColumn, row);
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
    text.startsWith(_fc2Prefix) ? text.replaceFirst(_fc2Prefix, '') : text;

  @override
  Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity) async {
    final List<ShiftTime> dates = lamodaEntity.shifts.keys.toList();
    final List<String> workNames = lamodaEntity.worksSet.toList();
    if (dates.isEmpty || workNames.isEmpty) {
      return Left<String, String>('no_data'.tr());
    }

    dates.sort();
    workNames.sort();

    final String fromDate = 'from_date'.tr(args: <String>[DateFormat('dd.MM.yy').format(dates[0].date)]);

    try {
      final Excel excel = Excel.createExcel(); // a new workbook with one default sheet Sheet1
      excel.rename('Sheet1', fromDate);
      final Sheet sheet = excel[fromDate];

      for (int i = 0; i < workNames.length; i++) {
        sheet.updateCell(CellIndex.indexByColumnRow(
            columnIndex: i + _outStartColumn,
            rowIndex: _outHeaderRow), 
          TextCellValue(workNames[i]),
          cellStyle: CellStyle(rotation: 90));
      }

      int row = _outStartRow;

      for (ShiftTime shiftTime in dates) {
        final WorkerShifts? workerShifts = lamodaEntity.shifts[shiftTime];

        if (workerShifts != null) {
          for (final MapEntry<String, Works> workerShift in workerShifts.entries) {
            _formRow(sheet, row++, shiftTime, workerShift.key, workerShift.value, workNames);
          }
        }
      }

      final String nowFormatted = DateFormat('yyMMddHHmmss').format(DateTime.now()) ;
      final String fileName = '$_fileNamePrefix ($fromDate) $nowFormatted.xlsx';
      excel.save(fileName: fileName);

      return Right<String, String>(fileName);
    } on Exception catch (e) {
      return Left<String, String>('fail_download_excel_file'.tr(args: <String>['$e']));
    }
  }

  void _formRow (Sheet sheet, int row, ShiftTime shiftTime, String login, Works works, List<String> workNames) {

    final String dateFormatted = DateFormat('dd/MM/yy').format(shiftTime.date);
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: _outDateColumn,
        rowIndex: row), 
      TextCellValue(dateFormatted));

    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: _outDayNightColumn,
        rowIndex: row), 
      TextCellValue(shiftTime.day ? 'day'.tr() : 'night'.tr()));

    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: _outLoginColumn,
        rowIndex: row), 
      TextCellValue(login));

    for (MapEntry<String, int> work in works.entries) {
      final int workNameInd = workNames.indexOf(work.key);
      if (workNameInd > -1) {
        sheet.updateCell(CellIndex.indexByColumnRow(
          columnIndex: workNameInd + _outStartColumn,
          rowIndex: row), 
        IntCellValue(work.value));
      }
    }
  }
}