// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOutputDto _$CreateOutputDtoFromJson(
  Map<String, dynamic> json,
) => CreateOutputDto(
  lamodaEntityDto: LamodaEntityDto.fromJson(
    json['lamodaEntityDto'] as Map<String, dynamic>,
  ),
  columns1: (json['columns1'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(int.parse(k), LmColumn.fromJson(e as Map<String, dynamic>)),
  ),
  columns2: (json['columns2'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(int.parse(k), LmColumn.fromJson(e as Map<String, dynamic>)),
  ),
  createOutputStrings: CreateOutputStrings.fromJson(
    json['createOutputStrings'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateOutputDtoToJson(CreateOutputDto instance) =>
    <String, dynamic>{
      'lamodaEntityDto': instance.lamodaEntityDto,
      'columns1': instance.columns1.map((k, e) => MapEntry(k.toString(), e)),
      'columns2': instance.columns2.map((k, e) => MapEntry(k.toString(), e)),
      'createOutputStrings': instance.createOutputStrings,
    };
