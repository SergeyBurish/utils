// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handle_tariffs_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandleTariffsOutputDto _$HandleTariffsOutputDtoFromJson(
  Map<String, dynamic> json,
) => HandleTariffsOutputDto(
  lamodaTariffs: (json['lamodaTariffs'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      DateTime.parse(k),
      (e as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    ),
  ),
  error: json['error'] as String,
  errorArgs: (json['errorArgs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$HandleTariffsOutputDtoToJson(
  HandleTariffsOutputDto instance,
) => <String, dynamic>{
  'lamodaTariffs': instance.lamodaTariffs?.map(
    (k, e) => MapEntry(k.toIso8601String(), e),
  ),
  'error': instance.error,
  'errorArgs': instance.errorArgs,
};
