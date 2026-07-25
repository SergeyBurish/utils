import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:web/web.dart' as web;

import '../../domain/entity/lamoda_entity.dart';
import '../dto/create_output_dto.dart';
import '../dto/create_output_strings.dart';
import '../dto/file_output_dto.dart';
import '../dto/lamoda_entity_dto.dart';
import 'isolates/create_output_file.dart';

abstract interface class IsolateLauncher {
  Future<Either<String, FileOutputDto>> createOutputFile(LamodaEntity lamodaEntity);
}

class IsolateLauncherImp implements IsolateLauncher{
  @override
  Future<Either<String, FileOutputDto>> createOutputFile(LamodaEntity lamodaEntity) async {
    final IsolateManager<String, String> isolate = 
      IsolateManager<String, String>.create(
        isolCreateOutputFile,
        workerName: 'isolCreateOutputFile',
      );

    CreateOutputDto dto = CreateOutputDto(
      lamodaEntityDto: lamodaEntity.toDto(), 
      createOutputStrings: CreateOutputStrings(
        from: 'from'.tr(),
        day: 'day'.tr(),
        night: 'night'.tr(),
      ),
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

