import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/shift.dart';

part 'shift_dto.g.dart';

@JsonSerializable()
class ShiftDto extends Shift {
  ShiftDto({required super.works, super.penalty});

  factory ShiftDto.fromJson(Map<String, dynamic> json) => _$ShiftDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftDtoToJson(this);
}

extension ShiftMapper on Shift {
  ShiftDto toDto() => ShiftDto(works: works, penalty: penalty);
}