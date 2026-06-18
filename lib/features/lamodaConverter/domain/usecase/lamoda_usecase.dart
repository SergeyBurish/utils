import 'package:dart_either/dart_either.dart';

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
    final output = await repository.setPath(LamodaEntity(uploadPath: 'testPath'));
    if (output.isRight) {
      return Right(123);
    }
    return const Left(null);
  }

  @override
  Future<Either<Exception, LamodaEntity>> getUploadPath() => repository.getPath();
}