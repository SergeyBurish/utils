import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';

import '../entity/lamoda_entity.dart';
import '../entity/typedefs.dart';
import '../repository/lamoda_repository.dart';

abstract interface class LamodaUsecase{
    Future<Either<String, LamodaEntity>> handleExcelFile(Uint8List bytes);
    Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity);
    Future<Either<String, LamodaTariffs>> handleTariffsFile(Uint8List bytes);
    Future<Either<String, String>> downloadTariffsExcelFile(LamodaTariffs lamodaTariffs, Set<String> worksSet);
}
class LamodaUsecaseImp implements LamodaUsecase{
  final LamodaRepository repository;

  LamodaUsecaseImp({required this.repository});
  
  @override
  Future<Either<String, LamodaEntity>> handleExcelFile(Uint8List bytes) async {
    return await repository.handleExcelFile(bytes);
  }

  @override
  Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity) async {
    return await repository.downloadExcelFile(lamodaEntity);
  }

  @override
  Future<Either<String, LamodaTariffs>> handleTariffsFile(Uint8List bytes) async {
    return await repository.handleTariffsFile(bytes);
  }

  @override
  Future<Either<String, String>> downloadTariffsExcelFile(LamodaTariffs lamodaTariffs, Set<String> worksSet) async {
    return await repository.downloadTariffsExcelFile(lamodaTariffs, worksSet);
  }
}