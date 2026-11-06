// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handle_penalties_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandlePenaltiesOutputDto _$HandlePenaltiesOutputDtoFromJson(
  Map<String, dynamic> json,
) => HandlePenaltiesOutputDto(
  penaltiesList: (json['penaltiesList'] as List<dynamic>?)
      ?.map((e) => PenaltyEntityDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  error: json['error'] as String,
  errorArgs: (json['errorArgs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$HandlePenaltiesOutputDtoToJson(
  HandlePenaltiesOutputDto instance,
) => <String, dynamic>{
  'penaltiesList': instance.penaltiesList,
  'error': instance.error,
  'errorArgs': instance.errorArgs,
};
