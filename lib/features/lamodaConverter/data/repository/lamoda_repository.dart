import 'package:dart_either/dart_either.dart';

import '../../domain/entity/lamoda_entity.dart';
import '../../domain/repository/lamoda_repository.dart';
import '../data_sources/local_data_source.dart';
import '../dto/lamoda_dto.dart';

class LamodaRepositoryImp implements LamodaRepository {
  final LamodaLocalDataSource localDataSource;

  LamodaRepositoryImp({required this.localDataSource});

  @override
  Future<Either<Exception, void>> setPath(LamodaEntity lamodaEntity) async {
    try {
      await localDataSource.setPath(lamodaEntity.toDto());
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, LamodaEntity>> getPath() async {
    try {
      final LamodaDto? lamodaDto = await localDataSource.getPath();
      return Right(lamodaDto ?? LamodaEntity(uploadPath: 'test03.xlsx'));
    } on Exception catch (e) {
      return Left(e);
    }
  }
}