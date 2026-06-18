// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../features/lamodaConverter/data/data_sources/local_data_source.dart'
    as _i1016;
import '../features/lamodaConverter/domain/repository/lamoda_repository.dart'
    as _i107;
import '../features/lamodaConverter/domain/usecase/lamoda_usecase.dart'
    as _i595;
import 'module.dart' as _i946;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final module = _$Module();
    gh.lazySingleton<_i1016.LamodaLocalDataSource>(
      () => module.localDataSource(),
    );
    gh.lazySingleton<_i107.LamodaRepository>(
      () => module.lamodaRepository(gh<_i1016.LamodaLocalDataSource>()),
    );
    gh.lazySingleton<_i595.LamodaUsecase>(
      () => module.lamodaUsecase(gh<_i107.LamodaRepository>()),
    );
    return this;
  }
}

class _$Module extends _i946.Module {}
