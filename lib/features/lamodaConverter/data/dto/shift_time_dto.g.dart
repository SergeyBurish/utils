// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_time_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftTimeDto _$ShiftTimeDtoFromJson(Map<String, dynamic> json) => ShiftTimeDto(
  date: DateTime.parse(json['date'] as String),
  day: json['day'] as bool,
);

Map<String, dynamic> _$ShiftTimeDtoToJson(ShiftTimeDto instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'day': instance.day,
    };
