import 'package:flutter/material.dart';

class AppButtonStyles extends ThemeExtension<AppButtonStyles>{
  final ButtonStyle uploadButton;
    
  const AppButtonStyles({
    required this.uploadButton,
  });

  @override
  AppButtonStyles copyWith({
    ButtonStyle? uploadButton,
  }) {
    return AppButtonStyles(
      uploadButton: uploadButton ?? this.uploadButton,
    );  
  }

  @override
  AppButtonStyles lerp(ThemeExtension<AppButtonStyles>? other, double t) {
    if (other is! AppButtonStyles) return this;
    return AppButtonStyles(
      uploadButton: ButtonStyle.lerp(uploadButton, other.uploadButton, t)!,
    );
  }
}