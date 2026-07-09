import '../../domain/repository/lamoda_repository.dart';
import '../data_sources/local_data_source.dart';

class LamodaRepositoryImp implements LamodaRepository {
  final LamodaLocalDataSource localDataSource;

  LamodaRepositoryImp({required this.localDataSource});
}