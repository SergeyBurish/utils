import 'package:dart_either/dart_either.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entity/lamoda_entity.dart';
import '../../domain/repository/lamoda_repository.dart';
import '../consts.dart';
import '../data_sources/local_data_source.dart';
import '../dto/file_output_dto.dart';
import '../isolate_launcher/isolate_launcher.dart';

class LamodaRepositoryImp implements LamodaRepository {
  final LamodaLocalDataSource localDataSource;
  final IsolateLauncher isolateLauncher; 

  LamodaRepositoryImp({required this.localDataSource, required this.isolateLauncher});

  @override
  Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity) async {
    final Either<String, FileOutputDto> output = await isolateLauncher.createOutputFile(lamodaEntity);
    switch (output) {
      case Right<String, FileOutputDto>(value: FileOutputDto dto):
        final String nowFormatted = DateFormat('yyMMddHHmmss').format(DateTime.now()) ;
        final String fileName = '$fileNamePrefix (${dto.fromDate}) $nowFormatted.xlsx';
        return _downloadExcelFile(dto.bytes, fileName);
      case Left<String, FileOutputDto>(value: String error):
        return Left<String, String>(error);
    }
  }

  Future<Either<String, String>> _downloadExcelFile(List<int> bytes, String fileName) async {
    try {
      localDataSource.downloadFileWeb(bytes, fileName);
    } catch (e) {
      return Left<String, String>('fail_download_excel_file'.tr(args: <String>['$e']));
    }
    
    return Right<String, String>(fileName);
  }
}