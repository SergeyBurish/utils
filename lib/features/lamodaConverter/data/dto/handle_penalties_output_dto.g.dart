// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handle_penalties_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandlePenaltiesOutputDto _$HandlePenaltiesOutputDtoFromJson(
  Map<String, dynamic> json,
) => HandlePenaltiesOutputDto(
  penalties: (json['penalties'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, AmountPriceDto.fromJson(e as Map<String, dynamic>)),
  ),
  error: json['error'] as String,
  errorArgs: (json['errorArgs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$HandlePenaltiesOutputDtoToJson(
  HandlePenaltiesOutputDto instance,
) => <String, dynamic>{
  'penalties': instance.penalties,
  'error': instance.error,
  'errorArgs': instance.errorArgs,
};
