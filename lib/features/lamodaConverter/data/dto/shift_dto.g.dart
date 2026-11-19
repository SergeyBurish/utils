// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftDto _$ShiftDtoFromJson(Map<String, dynamic> json) => ShiftDto(
  works: Map<String, int>.from(json['works'] as Map),
  penalty: (json['penalty'] as num).toDouble(),
);

Map<String, dynamic> _$ShiftDtoToJson(ShiftDto instance) => <String, dynamic>{
  'works': instance.works,
  'penalty': instance.penalty,
};
