import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entity/lamoda_entity.dart';
import '../../domain/entity/tariffs_entity.dart';
import '../../domain/entity/typedefs.dart';
import '../../domain/repository/lamoda_repository.dart';
import '../data_sources/local_data_source.dart';
import '../dto/create_output_dto.dart';
import '../dto/create_output_strings.dart';
import '../dto/create_tariffs_dto.dart';
import '../dto/create_tariffs_strings.dart';
import '../dto/file_output_dto.dart';
import '../dto/handle_excel_dto.dart';
import '../dto/lamoda_entity_dto.dart';
import '../isolate_launcher/isolate_launcher.dart';
import '../tablesData/consts.dart';
import '../tablesData/tables_data.dart';

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
  Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity, LamodaTariffs lamodaTariffs) async {
    final CreateOutputDto dto = CreateOutputDto(
      lamodaEntityDto: lamodaEntity.toDto(),
      lamodaTariffs: lamodaTariffs,
      columnsFD1: columnsFD1,
      columnsFD2: columnsFD2,
      columnsED: columnsED,
      createOutputStrings: CreateOutputStrings(
        from: 'from'.tr(),
        bid: 'bid'.tr(),
        day: 'day'.tr(),
        night: 'night'.tr(),
        basicTariffs: 'basic_tariffs'.tr(),
        employeeDetails: 'employee_details'.tr(),
        tariffs: 'tariffs'.tr(),
        coeffWages: 'coeff_wages'.tr(),
        coeffWages2months: 'coeff_wages_2_months'.tr(),
        tariffStartDate: 'tariff_start_date'.tr(),
        processEng: 'process_eng'.tr(),
        cost1service: 'cost_of_1_service'.tr(),
        tariffWages: 'tariff_for_wages'.tr(),
        tariffWages2months: 'tariff_for_wages_2_months'.tr(),
        shouldBeDateHere: 'should_be_date_here'.tr(),
      ),
    );

    final Either<String, FileOutputDto> output = await isolateLauncher.createOutputFile(dto);
    switch (output) {
      case Right<String, FileOutputDto>(value: final FileOutputDto dto):
        final String nowFormatted = DateFormat('yyMMddHHmmss').format(DateTime.now()) ;
        final String fileName = '$picksFilePrefix (${dto.fromDate}) $nowFormatted.xlsx';
        return _downloadExcelFile(dto.bytes, fileName);
      case Left<String, FileOutputDto>(value: final String error):
        return Left<String, String>(error);
    }
  }

  @override
  Future<Either<String, TariffsEntity>> handleTariffsFile(Uint8List bytes) async {
    final HandleExcelDto dto = HandleExcelDto(bytes: bytes);
    return  await isolateLauncher.handleTariffsFile(dto);
  }

  @override
  Future<Either<String, String>> downloadTariffsExcelFile(LamodaTariffs lamodaTariffs, Set<String> worksSet) async {
    final CreateTariffsDto dto = CreateTariffsDto(
      lamodaTariffs: lamodaTariffs,
      worksSet: worksSet,
      createTariffsStrings: CreateTariffsStrings(
        tariffs: 'tariffs'.tr(),
        coeffWages: 'coeff_wages'.tr(),
        coeffWages2months: 'coeff_wages_2_months'.tr(),
        tariffStartDate: 'tariff_start_date'.tr(),
        processEng: 'process_eng'.tr(),
        cost1service: 'cost_of_1_service'.tr(),
        tariffWages: 'tariff_for_wages'.tr(),
        tariffWages2months: 'tariff_for_wages_2_months'.tr(),
        shouldBeDateHere: 'should_be_date_here'.tr(),
      ),
    );

    final Either<String, FileOutputDto> output = await isolateLauncher.createTariffsFile(dto);
    switch (output) {
      case Right<String, FileOutputDto>(value: final FileOutputDto dto):
        final String nowFormatted = DateFormat('yyMMddHHmmss').format(DateTime.now()) ;
        final String fileName = '$tariffsFilePrefix$nowFormatted.xlsx';
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