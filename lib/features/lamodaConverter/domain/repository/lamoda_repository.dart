import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';

import '../entity/lamoda_entity.dart';

abstract interface class LamodaRepository {
  Future<Either<String, LamodaEntity>> handleExcelFile(Uint8List bytes);
  Future<Either<String, String>> downloadExcelFile(LamodaEntity lamodaEntity);
}