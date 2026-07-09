import 'package:flutter/material.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles>{
  final TextStyle middleText;
  final TextStyle smallText;
    
  const AppTextStyles({
    required this.middleText,
    required this.smallText,
  });

  @override
  AppTextStyles copyWith({
    TextStyle? middleText,
    TextStyle? smallText,
  }) {
    return AppTextStyles(
      middleText: middleText ?? this.middleText,
      smallText: smallText ?? this.smallText,
    );  
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      middleText: TextStyle.lerp(middleText, other.middleText, t)!,
      smallText: TextStyle.lerp(smallText, other.smallText, t)!,
    );
  }
}