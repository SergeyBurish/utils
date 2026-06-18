import 'package:injectable/injectable.dart';

import '../features/lamodaConverter/data/data_sources/local_data_source.dart';
import '../features/lamodaConverter/data/repository/lamoda_repository.dart';
import '../features/lamodaConverter/domain/repository/lamoda_repository.dart';
import '../features/lamodaConverter/domain/usecase/lamoda_usecase.dart';

@module
abstract class Module {
  @lazySingleton
  LamodaLocalDataSource localDataSource() => LamodaLocalDataSourceImp();

  @lazySingleton
  LamodaRepository lamodaRepository(LamodaLocalDataSource localDataSource) =>
      LamodaRepositoryImp(localDataSource: localDataSource);

  @lazySingleton
  LamodaUsecase lamodaUsecase(LamodaRepository repository) =>
      LamodaUsecaseImp(repository: repository);
}