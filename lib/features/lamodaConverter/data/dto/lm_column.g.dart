// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lm_column.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LmColumn _$LmColumnFromJson(Map<String, dynamic> json) => LmColumn(
  name: json['name'] as String,
  rotation: (json['rotation'] as num?)?.toInt() ?? 0,
  bgColor: json['bgColor'] as String?,
);

Map<String, dynamic> _$LmColumnToJson(LmColumn instance) => <String, dynamic>{
  'name': instance.name,
  'rotation': instance.rotation,
  'bgColor': instance.bgColor,
};
