// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lamoda_entity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LamodaEntityDto _$LamodaEntityDtoFromJson(Map<String, dynamic> json) =>
    LamodaEntityDto(
      shifts: (json['shifts'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
          ),
        ),
      ),
      nttShifts: (json['nttShifts'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
          ),
        ),
      ),
      lamodaEmployees: (json['lamodaEmployees'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, EmployeeDetailsDto.fromJson(e as Map<String, dynamic>)),
      ),
      worksSet: (json['worksSet'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      nttWorksSet: (json['nttWorksSet'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$LamodaEntityDtoToJson(LamodaEntityDto instance) =>
    <String, dynamic>{
      'shifts': instance.shifts,
      'nttShifts': instance.nttShifts,
      'lamodaEmployees': instance.lamodaEmployees,
      'worksSet': instance.worksSet.toList(),
      'nttWorksSet': instance.nttWorksSet.toList(),
    };
