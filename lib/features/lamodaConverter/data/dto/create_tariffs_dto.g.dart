// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_tariffs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTariffsDto _$CreateTariffsDtoFromJson(Map<String, dynamic> json) =>
    CreateTariffsDto(
      lamodaTariffs: (json['lamodaTariffs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          DateTime.parse(k),
          (e as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
        ),
      ),
      worksSet: (json['worksSet'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      createTariffsStrings: CreateTariffsStrings.fromJson(
        json['createTariffsStrings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreateTariffsDtoToJson(CreateTariffsDto instance) =>
    <String, dynamic>{
      'lamodaTariffs': instance.lamodaTariffs.map(
        (k, e) => MapEntry(k.toIso8601String(), e),
      ),
      'worksSet': instance.worksSet.toList(),
      'createTariffsStrings': instance.createTariffsStrings,
    };
