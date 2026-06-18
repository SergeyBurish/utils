import 'package:auto_route/auto_route.dart';

import '../features/lamodaConverter/presentation/lamoda_converter_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: LamodaConverterRoute.page,
    ),
  ];
}