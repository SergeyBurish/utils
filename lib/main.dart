import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'di/injector.dart';
import 'di/locator.dart';
import 'features/lamodaConverter/presentation/cubit/lamoda_cubit.dart';
import 'router/app_router.dart';

final AppRouter router = AppRouter();

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[Locale('ru', 'RU')],
      path: 'l10n',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LamodaCubit(lamodaUsecase: Locator.lamodaUsecase),
      child: MaterialApp.router(
        title: 'utils',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.createLightTheme(),
        routerConfig: router.config(),
      ),
    );
  }
}
