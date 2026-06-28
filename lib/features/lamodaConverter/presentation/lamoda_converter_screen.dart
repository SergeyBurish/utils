import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import 'cubit/lamoda_cubit.dart';
import 'lamoda_converter_view.dart';

@RoutePage()
class LamodaConverterScreen extends StatelessWidget {
  const LamodaConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final files = context.watch<LamodaCubit>().state.files;
    return Scaffold(
      appBar: AppBar(
        title: Text('lamoda_converter'.tr()),
        backgroundColor: context.colorScheme.appBarBackground,
      ),
      body: LamodaConverterView(
        file: files.isEmpty ? 'no files' : files[0],
        onUpload: context.read<LamodaCubit>().onUpload,
      )
    );
  }
}
