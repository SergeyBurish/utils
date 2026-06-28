import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';
import 'package:excel_plus/excel_plus.dart';
import 'package:file_selector/file_selector.dart';

import '../entity/lamoda_entity.dart';
import '../repository/lamoda_repository.dart';

abstract interface class LamodaUsecase{
    Future<Either<void, int>> handleFiles();
    Future<Either<Exception, LamodaEntity>> getUploadPath();
}
class LamodaUsecaseImp implements LamodaUsecase{
  final LamodaRepository repository;

  LamodaUsecaseImp({required this.repository});
  
  @override
  Future<Either<void, int>> handleFiles() async {

    const XTypeGroup excelTypeGroup = XTypeGroup(
      label: 'Excel',
      extensions: <String>['xls', 'xlsx'],
      uniformTypeIdentifiers: <String>['public.xlsx'],
    );

    final List<XFile> files = await openFiles(
      acceptedTypeGroups: <XTypeGroup>[excelTypeGroup],
    );

    if (files.isNotEmpty) {
      final Uint8List bytes = await files[0].readAsBytes();
      try {
        final Excel excel = Excel.decodeBytes(bytes);

        // for (final String sheetName in excel.tables.keys) {
        //   for (final List<Data?> row in excel[sheetName].rows) {
        //     print(row.map((Data? cell) => cell?.value).toList());
        //   }
        // }

        if (excel.tables.keys.isNotEmpty) {
          final String sheetName = excel.tables.keys.first;
          final Data cell = excel[sheetName].cell(CellIndex.indexByString('B2'));
          // print(cell.value); // a typed CellValue: TextCellValue, IntCellValue, ... 


          final Excel excelOutput = Excel.createExcel(); // a new workbook with one default sheet
          final Sheet sheet = excelOutput['Sheet1'];

          sheet.updateCell(CellIndex.indexByString('A1'), TextCellValue(cell.value.toString()));

          // final List<int>? bytes = 
          excelOutput.save(fileName: 'Test01.xlsx');
        }
      } on Exception catch (e) {
        print('Excel Exception $e');
      }
    }

    return const Right(123);

    // final output = await repository.setPath(LamodaEntity(uploadPath: 'testPath'));
    // if (output.isRight) {
    //   return Right(123);
    // }
    // return const Left(null);
  }

  @override
  Future<Either<Exception, LamodaEntity>> getUploadPath() => repository.getPath();
}