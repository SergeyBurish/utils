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
  columnsFD1: (json['columnsFD1'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(int.parse(k), LmColumn.fromJson(e as Map<String, dynamic>)),
  ),
  columnsFD2: (json['columnsFD2'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(int.parse(k), LmColumn.fromJson(e as Map<String, dynamic>)),
  ),
  columnsED: (json['columnsED'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(int.parse(k), LmColumn.fromJson(e as Map<String, dynamic>)),
  ),
  createOutputStrings: CreateOutputStrings.fromJson(
    json['createOutputStrings'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateOutputDtoToJson(
  CreateOutputDto instance,
) => <String, dynamic>{
  'lamodaEntityDto': instance.lamodaEntityDto,
  'columnsFD1': instance.columnsFD1.map((k, e) => MapEntry(k.toString(), e)),
  'columnsFD2': instance.columnsFD2.map((k, e) => MapEntry(k.toString(), e)),
  'columnsED': instance.columnsED.map((k, e) => MapEntry(k.toString(), e)),
  'createOutputStrings': instance.createOutputStrings,
};
