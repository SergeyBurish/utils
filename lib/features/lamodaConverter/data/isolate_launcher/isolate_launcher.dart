import 'dart:convert';

import 'package:dart_either/dart_either.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isolate_manager/isolate_manager.dart';

import '../../domain/entity/tariffs_entity.dart';
import '../dto/create_output_dto.dart';
import '../dto/create_tariffs_dto.dart';
import '../dto/file_output_dto.dart';
import '../dto/handle_excel_dto.dart';
import '../dto/handle_excel_output_dto.dart';
import '../dto/handle_tariffs_output_dto.dart';
import '../dto/lamoda_entity_dto.dart';
import 'isolates/create_output_file.dart';
import 'isolates/create_tariffs_file.dart';
import 'isolates/handle_excel_file.dart';
import 'isolates/handle_tariffs_file.dart';

abstract interface class IsolateLauncher {
  Future<Either<String, LamodaEntityDto>> handleExcelFile(HandleExcelDto dto);
  Future<Either<String, FileOutputDto>> createOutputFile(CreateOutputDto dto);
  Future<Either<String, TariffsEntity>> handleTariffsFile(HandleExcelDto dto);
  Future<Either<String, FileOutputDto>> createTariffsFile(CreateTariffsDto dto);
}

class IsolateLauncherImp implements IsolateLauncher{
  @override
  Future<Either<String, LamodaEntityDto>> handleExcelFile(HandleExcelDto dto) async {
    final IsolateManager<String, String> isolate = 
      IsolateManager<String, String>.create(
        isolHandleExcelFile,
        workerName: 'isolHandleExcelFile',
      );

    final String isolResult = await isolate.compute(jsonEncode(dto.toJson()));
    final HandleExcelOutputDto fileOutput = HandleExcelOutputDto.fromJson(jsonDecode(isolResult));

    if (fileOutput.lamodaEntityDto != null) {
      return Right<String, LamodaEntityDto>(fileOutput.lamodaEntityDto!);
    } else {
      return Left<String, LamodaEntityDto>(fileOutput.error.tr(args: fileOutput.errorArgs));
    }
  }

  @override
  Future<Either<String, FileOutputDto>> createOutputFile(CreateOutputDto dto) async {
    final IsolateManager<String, String> isolate = 
      IsolateManager<String, String>.create(
        isolCreateOutputFile,
        workerName: 'isolCreateOutputFile',
      );

    final String isolResult = await isolate.compute(jsonEncode(dto.toJson()));
    final FileOutputDto fileOutput = FileOutputDto.fromJson(jsonDecode(isolResult));

    if (fileOutput.bytes.isNotEmpty) {
      return Right<String, FileOutputDto>(fileOutput);
    } else {
      return Left<String, FileOutputDto>(fileOutput.error.tr(args: fileOutput.errorArgs));
    }
  }

  @override
  Future<Either<String, TariffsEntity>> handleTariffsFile(HandleExcelDto dto) async {
    final IsolateManager<String, String> isolate = 
      IsolateManager<String, String>.create(
        isolHandleTariffsFile,
        workerName: 'isolHandleTariffsFile',
      );

    final String isolResult = await isolate.compute(jsonEncode(dto.toJson()));
    final HandleTariffsOutputDto tariffsOutput = HandleTariffsOutputDto.fromJson(jsonDecode(isolResult));
    if (tariffsOutput.tariffsEntityDto != null) {
      return Right<String, TariffsEntity>(tariffsOutput.tariffsEntityDto!);
    } else {
      return Left<String, TariffsEntity>(tariffsOutput.error.tr(args: tariffsOutput.errorArgs));
    }
  }

  @override
  Future<Either<String, FileOutputDto>> createTariffsFile(CreateTariffsDto dto) async {
    final IsolateManager<String, String> isolate = 
      IsolateManager<String, String>.create(
        isolCreateTariffsFile,
        workerName: 'isolCreateTariffsFile',
      );

    final String isolResult = await isolate.compute(jsonEncode(dto.toJson()));
    final FileOutputDto fileOutput = FileOutputDto.fromJson(jsonDecode(isolResult));

    if (fileOutput.bytes.isNotEmpty) {
      return Right<String, FileOutputDto>(fileOutput);
    } else {
      return Left<String, FileOutputDto>(fileOutput.error.tr(args: fileOutput.errorArgs));
    }
  }
}
