// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileOutputDto _$FileOutputDtoFromJson(Map<String, dynamic> json) =>
    FileOutputDto(
      bytes: (json['bytes'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      fromDate: json['fromDate'] as String,
      error: json['error'] as String,
      errorArgs: (json['errorArgs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FileOutputDtoToJson(FileOutputDto instance) =>
    <String, dynamic>{
      'bytes': instance.bytes,
      'fromDate': instance.fromDate,
      'error': instance.error,
      'errorArgs': instance.errorArgs,
    };
