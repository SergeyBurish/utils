import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/dm.dart';
import '../../../core/theme/app_theme.dart';
import 'widgets/card_wrap.dart';

class LamodaConverterView extends StatelessWidget {
  final String message;
  final String tariffsMessage;
  final String employeesMessage;
  final String errorMessage;
  final String downloadButton;
  final String version;
  final bool loading;
  final void Function()? onUpload;
  final void Function()? onUploadTariffs;
  final void Function()? onDownloadTariffs;
  final void Function()? onUploadEmployees;
  final void Function()? onDownloadEmployees;
  final void Function()? onDownload;
  const LamodaConverterView({
    super.key,
    required this.message,
    required this.tariffsMessage,
    required this.employeesMessage,
    required this.errorMessage,
    required this.downloadButton,
    required this.version,
    required this.loading,
    this.onUpload,
    this.onUploadTariffs,
    this.onDownloadTariffs,
    this.onUploadEmployees,
    this.onDownloadEmployees,
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
          CardWrap(
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
                ],
              ),
              Text(
                message,
                style: context.textStyles.middleText,
              ),
            ],
          ),
          CardWrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dm.s10,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: onUploadTariffs,
                    child: Text('upload_tariffs'.tr()),
                  ),
                  ElevatedButton(
                    onPressed: onDownloadTariffs,
                    child: Text('download_tariffs'.tr()),
                  ),
                ],
              ),
              Text(
                tariffsMessage,
                style: context.textStyles.middleText,
              ),
            ],
          ),
          CardWrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dm.s10,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: onUploadEmployees,
                    child: Text('upload_employees'.tr()),
                  ),
                  ElevatedButton(
                    onPressed: onDownloadEmployees,
                    child: Text('download_employees'.tr()),
                  ),
                ],
              ),
              Text(
                employeesMessage,
                style: context.textStyles.middleText,
              ),
            ],
          ),
          Text(
            errorMessage,
            style: context.textStyles.middleText,
            maxLines: 50,
          ),
          if(loading) const LinearProgressIndicator(),
          Text(
            version,
            style: context.textStyles.smallText,
          ),
        ],
      ),
    );
  }
}