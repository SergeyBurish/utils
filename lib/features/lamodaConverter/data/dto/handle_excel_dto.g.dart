// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handle_excel_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandleExcelDto _$HandleExcelDtoFromJson(Map<String, dynamic> json) =>
    HandleExcelDto(
      bytes: const Uint8ListConverter().fromJson(json['bytes'] as String),
    );

Map<String, dynamic> _$HandleExcelDtoToJson(HandleExcelDto instance) =>
    <String, dynamic>{
      'bytes': const Uint8ListConverter().toJson(instance.bytes),
    };
