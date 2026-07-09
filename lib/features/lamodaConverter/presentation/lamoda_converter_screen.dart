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
    // final List<String> files = context.watch<LamodaCubit>().state.files;
    return Scaffold(
      appBar: AppBar(
        title: Text('lamoda_converter'.tr()),
        backgroundColor: context.colorScheme.appBarBackground,
      ),
      body: BlocBuilder<LamodaCubit, LamodaState>(
        builder: (BuildContext context, LamodaState state) {
          final LamodaCubit cubit = context.read<LamodaCubit>();
          return LamodaConverterView(
            message: state.message,
            errorMessage: state.errorMessage,
            downloadButton: state.fileDownloaded ? 'download_result_again'.tr() : 'download_result'.tr(),
            version: 'version'.tr(args: <String>['1.0.0']),
            loading: state.inProgress,
            onUpload: state.inProgress ? null : cubit.onUpload,
            onDownload: state.resultIsReady ? cubit.onDownload : null,
          );
        },
      ),
    );
  }
}
