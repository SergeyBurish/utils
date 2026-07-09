import 'package:flutter/material.dart';

import 'button_styles.dart';
import 'color_scheme.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData createLightTheme(){
    return ThemeData(
      extensions: <ThemeExtension<dynamic>>[
        const AppColorScheme(
          appBarBackground: Color.fromARGB(107, 214, 231, 244),
        ),
        const AppTextStyles(
          middleText: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
          smallText: TextStyle(
            color: Colors.black26,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
        ),
        AppButtonStyles(
          uploadButton: ButtonStyle(
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 15),
            ),
          ),  
        ),
      ],
    );
  }
}

extension BuildContextExtention on BuildContext {
  AppColorScheme get colorScheme =>
      Theme.of(this).extension<AppColorScheme>()!;

  AppTextStyles get textStyles =>
      Theme.of(this).extension<AppTextStyles>()!;

  AppButtonStyles get buttonStyles =>
    Theme.of(this).extension<AppButtonStyles>()!;
}