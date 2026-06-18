import 'package:dart_either/dart_either.dart';

import '../entity/lamoda_entity.dart';

abstract interface class LamodaRepository {
  Future<Either<Exception, void>> setPath(LamodaEntity lamodaEntity);
  Future<Either<Exception, LamodaEntity>> getPath();
}