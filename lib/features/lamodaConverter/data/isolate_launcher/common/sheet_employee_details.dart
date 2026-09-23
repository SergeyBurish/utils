import 'package:excel_plus/excel_plus.dart';

import '../../../domain/entity/employee_details.dart';
import '../../../domain/entity/typedefs.dart';
import '../../dto/lm_column.dart';
import '../../tablesData/consts.dart';
import 'isol_utils.dart';

void fillOutSheetEmployeeDetails(
  Sheet sheet,
  LamodaEmployees lamodaEmployees,
  Map<int, LmColumn> columns,
  String notFilledIn,
){
  final List<String> logins = lamodaEmployees.keys.toList();
  logins.sort();
  // заголовок
  for(final MapEntry<int, LmColumn> el in columns.entries){
    sheet.updateCell(CellIndex.indexByColumnRow(
        columnIndex: el.key,
        rowIndex: edHeaderRow), 
      TextCellValue(el.value.name),
      cellStyle: CellStyle(
        rotation: el.value.rotation,
        backgroundColorHex: el.value.bgColor != null 
          ? ExcelColor.fromHexString(el.value.bgColor!) 
          : ExcelColor.none,
        bold: true,
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        textWrapping: TextWrapping.WrapText,
      ),
    );

    for (int i = 0; i < logins.length; i++) {
      final int rowIndex = i + edStartRow;
      
      // логин
      final String login = logins[i];
      sheet.updateCell(CellIndex.indexByColumnRow(
          columnIndex: edLogin,
          rowIndex: rowIndex), 
        TextCellValue(login),
      );

      final EmployeeDetails? employeeDetails = lamodaEmployees[login];

      // Ф.И.О
      if (employeeDetails?.fullName.isNotEmpty ?? false) {
        final String fullName = employeeDetails!.fullName;
        sheet.updateCell(CellIndex.indexByColumnRow(
            columnIndex: edFullName,
            rowIndex: rowIndex), 
          TextCellValue(fullName),
        );
      }

      // статус
      if (employeeDetails?.status.isNotEmpty ?? false) {
        final String status = employeeDetails!.status;
        sheet.updateCell(CellIndex.indexByColumnRow(
            columnIndex: edStatus,
            rowIndex: rowIndex), 
          TextCellValue(status),
        );
      }

      // дата начала работы
      sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: edStartDateOfWork, 
        rowIndex: rowIndex,
      )).cellStyle = CellStyle(numberFormat: NumFormat.custom(formatCode: dateFormat));

      if (employeeDetails?.startDateOfWork != null) {
        final DateTime startDateOfWork = employeeDetails!.startDateOfWork!;
        sheet.updateCell(CellIndex.indexByColumnRow(
            columnIndex: edStartDateOfWork,
            rowIndex: rowIndex), 
          DateTimeCellValue.fromDateTime(startDateOfWork),
        );
      }

      // формула: Не заполнено.
      final String fullNameIndex = stringIndex(colInd: edFullName, rowInd: rowIndex);
      final String statusIndex = stringIndex(colInd: edStatus, rowInd: rowIndex);
      final String dateIndex = stringIndex(colInd: edStartDateOfWork, rowInd: rowIndex);
      sheet.updateCell(CellIndex.indexByColumnRow(
          columnIndex: edNotFilledIn,
          rowIndex: rowIndex),
        FormulaCellValue('IF(OR(ISBLANK($fullNameIndex),ISBLANK($statusIndex),ISBLANK($dateIndex)),"$notFilledIn","")'),
      );
    }
  }
  sheet.setColumnAutoFit(edLogin);
}