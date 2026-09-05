// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tariffs_entity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TariffsEntityDto _$TariffsEntityDtoFromJson(Map<String, dynamic> json) =>
    TariffsEntityDto(
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
    );

Map<String, dynamic> _$TariffsEntityDtoToJson(TariffsEntityDto instance) =>
    <String, dynamic>{
      'lamodaTariffs': instance.lamodaTariffs.map(
        (k, e) => MapEntry(k.toIso8601String(), e),
      ),
      'worksSet': instance.worksSet.toList(),
    };
