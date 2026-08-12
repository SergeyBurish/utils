import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entity/lamoda_entity.dart';
import '../../domain/repository/lamoda_repository.dart';
import '../data_sources/local_data_source.dart';
import '../dto/create_output_dto.dart';
import '../dto/create_output_strings.dart';
import '../dto/file_output_dto.dart';
import '../dto/handle_excel_dto.dart';
import '../dto/lamoda_entity_dto.dart';
import '../isolate_launcher/isolate_launcher.dart';
import '../tablesData/consts.dart';
import '../tablesData/tabbles_data.dart';

class LamodaRepositoryImp implements LamodaRepository {
  final LamodaLocalDataSource localDataSource;
  final IsolateLauncher isolateLauncher; 

  LamodaRepositoryImp({required this.localDataSource, required this.isolateLauncher});

  @override
  Future<Either<String, LamodaEntity>> handleExcelFile(Uint8List bytes) async {
    final HandleExcelDto dto = HandleExcelDto(bytes: bytes);

    final Either<String, LamodaEntityDto> output = await isolateLauncher.handleExcelFile(dto);
    switch (output) {
      case Right<String, LamodaEntityDto>(value: final LamodaEntityDto dto):
        return Right<String, LamodaEntity>(dto.toLamodaEntity());
      case Left<String, LamodaEntityDto>(value: final String error):
        return Left<String, LamodaEntity>(error);
    }
  }

  @override
  Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity) async {
    final CreateOutputDto dto = CreateOutputDto(
      lamodaEntityDto: lamodaEntity.toDto(),
      columns1: outColumns1,
      columns2: outColumns2,
      createOutputStrings: CreateOutputStrings(
        from: 'from'.tr(),
        bid: 'bid'.tr(),
        day: 'day'.tr(),
        night: 'night'.tr(),
        basicTariffs: 'basic_tariffs'.tr(),
        processEng: 'process_eng'.tr(),
        tariffForWages: 'tariff_for_wages'.tr(),
      ),
    );

    final Either<String, FileOutputDto> output = await isolateLauncher.createOutputFile(dto);
    switch (output) {
      case Right<String, FileOutputDto>(value: final FileOutputDto dto):
        final String nowFormatted = DateFormat('yyMMddHHmmss').format(DateTime.now()) ;
        final String fileName = '$fileNamePrefix (${dto.fromDate}) $nowFormatted.xlsx';
        return _downloadExcelFile(dto.bytes, fileName);
      case Left<String, FileOutputDto>(value: final String error):
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