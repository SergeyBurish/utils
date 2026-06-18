import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/dm.dart';
import '../../../core/theme/app_theme.dart';

class LamodaConverterView extends StatelessWidget {
  final String file;
  final void Function()? onUpload;
  const LamodaConverterView({
    super.key,
    required this.file,
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: Dm.s10,
        children: [
          SizedBox(
            height: Dm.s30,
            child: Image.asset('assets/images/la.png'),
          ),
          Text(
            file,
            style: context.textStyles.middleText
          ),
          ElevatedButton(
            onPressed: onUpload,
            style: context.buttonStyles.uploadButton,
            child: Text('upload'.tr()),
          ),
        ],
      ),
    );
  }
}