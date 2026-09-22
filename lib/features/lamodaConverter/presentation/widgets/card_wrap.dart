import 'package:flutter/material.dart';

import '../../../../core/dm.dart';
import '../../../../core/theme/app_theme.dart';

class CardWrap extends StatelessWidget {
  final List<Widget> children;
  const CardWrap({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(Dm.s10),
        child: Wrap(
          spacing: Dm.s10,
          runSpacing: Dm.s10,
          children: children
        ),
      )
    );
  }
}