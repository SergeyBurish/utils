// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handle_tariffs_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandleTariffsOutputDto _$HandleTariffsOutputDtoFromJson(
  Map<String, dynamic> json,
) => HandleTariffsOutputDto(
  tariffsEntityDto: json['tariffsEntityDto'] == null
      ? null
      : TariffsEntityDto.fromJson(
          json['tariffsEntityDto'] as Map<String, dynamic>,
        ),
  error: json['error'] as String,
  errorArgs: (json['errorArgs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$HandleTariffsOutputDtoToJson(
  HandleTariffsOutputDto instance,
) => <String, dynamic>{
  'tariffsEntityDto': instance.tariffsEntityDto,
  'error': instance.error,
  'errorArgs': instance.errorArgs,
};
