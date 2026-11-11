// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_and_penalties_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExcelAndPenaltiesDto _$ExcelAndPenaltiesDtoFromJson(
  Map<String, dynamic> json,
) => ExcelAndPenaltiesDto(
  bytes: const Uint8ListConverter().fromJson(json['bytes'] as String),
  penalties: (json['penalties'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, AmountPriceDto.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$ExcelAndPenaltiesDtoToJson(
  ExcelAndPenaltiesDto instance,
) => <String, dynamic>{
  'bytes': const Uint8ListConverter().toJson(instance.bytes),
  'penalties': instance.penalties,
};
