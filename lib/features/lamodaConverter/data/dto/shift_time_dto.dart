import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/shift_time.dart';

part 'shift_time_dto.g.dart'; 

@JsonSerializable()
class ShiftTimeDto extends ShiftTime {
  ShiftTimeDto({required super.date, required super.day});

  factory ShiftTimeDto.fromJson(Map<String, dynamic> json) => _$ShiftTimeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftTimeDtoToJson(this);
}

extension ShiftTimeMapper on ShiftTime {
  ShiftTimeDto toDto() => ShiftTimeDto(date: date, day: day);
}