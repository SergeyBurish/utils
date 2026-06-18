import '../features/lamodaConverter/domain/usecase/lamoda_usecase.dart';
import 'injector.dart';

class Locator {
  static LamodaUsecase get lamodaUsecase => getIt<LamodaUsecase>();
}