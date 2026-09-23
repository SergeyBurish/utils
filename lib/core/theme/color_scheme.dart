import 'package:flutter/material.dart';

class AppColorScheme extends ThemeExtension<AppColorScheme>{
  final Color appBarBackground;
  final Color cardBackground;
    
  const AppColorScheme({
    required this.appBarBackground,
    required this.cardBackground,
  });

  @override
  AppColorScheme copyWith({
    Color? appBarBackground,
    Color? cardBackground,
  }) {
    return AppColorScheme(
      appBarBackground: appBarBackground ?? this.appBarBackground,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      appBarBackground: Color.lerp(appBarBackground, other.appBarBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
    );  
  }
}