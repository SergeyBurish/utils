import 'package:flutter/material.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles>{
  final TextStyle middleText;
    
  const AppTextStyles({
    required this.middleText,
  });

  @override
  AppTextStyles copyWith({
    TextStyle? middleText,
  }) {
    return AppTextStyles(
      middleText: middleText ?? this.middleText,
    );  
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      middleText: TextStyle.lerp(middleText, other.middleText, t)!,
    );
  }
}