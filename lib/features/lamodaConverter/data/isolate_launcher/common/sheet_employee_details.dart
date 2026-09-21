import 'package:excel_plus/excel_plus.dart';

import '../../../domain/entity/typedefs.dart';
import '../../dto/lm_column.dart';
import '../../tablesData/consts.dart';

void fillOutSheetEmployeeDetails(
  Sheet sheet,
  LamodaEmployees lamodaEmployees,
  Map<int, LmColumn> columns,
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

    // колонка логинов
    for (int i = 0; i < logins.length; i++) {
      sheet.updateCell(CellIndex.indexByColumnRow(
          columnIndex: edLogin,
          rowIndex: i + edStartRow), 
        TextCellValue(logins[i]),
      );
    }
  }
  sheet.setColumnAutoFit(edLogin);
}