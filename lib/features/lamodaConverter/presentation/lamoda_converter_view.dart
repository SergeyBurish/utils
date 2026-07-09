import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/dm.dart';
import '../../../core/theme/app_theme.dart';

class LamodaConverterView extends StatelessWidget {
  final String message;
  final String errorMessage;
  final String downloadButton;
  final String version;
  final bool loading;
  final void Function()? onUpload;
  final void Function()? onDownload;
  const LamodaConverterView({
    super.key,
    required this.message,
    required this.errorMessage,
    required this.downloadButton,
    required this.version,
    required this.loading,
    this.onUpload,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dm.s10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Dm.s10,
        children: <Widget>[
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Expanded(child: const LinearProgressIndicator()),
          //   ],
          // ),
          Wrap(
            spacing: Dm.s10,
            runSpacing: Dm.s10,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dm.s10,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: onUpload,
                    child: Text('upload_source_files'.tr()),
                  ),
                  ElevatedButton(
                    onPressed: onDownload,
                    child: Text(downloadButton),
                  ),
                  Text(
                    version,
                    style: context.textStyles.smallText,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message,
                    style: context.textStyles.middleText,
                  ),
                  Text(
                    errorMessage,
                    style: context.textStyles.middleText,
                    maxLines: 50,
                  ),
                ],
              ),
            ],
          ),
          if(loading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}