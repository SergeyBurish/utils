import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/employee_details.dart';
import '../../domain/entity/lamoda_entity.dart';
import '../../domain/entity/shift_time.dart';
import '../../domain/entity/typedefs.dart';
import 'employee_details_dto.dart';
import 'shift_time_dto.dart';

part 'lamoda_entity_dto.g.dart';

@JsonSerializable()
class LamodaEntityDto {
  final Map<String, WorkerShifts> shifts;
  final Map<String, WorkerShifts> nttShifts;
  final Map<String, EmployeeDetailsDto> lamodaEmployees;
  final Set<String> worksSet;
  final Set<String> nttWorksSet;
  LamodaEntityDto({
    required this.shifts,
    required this.nttShifts,
    required this.lamodaEmployees,
    required this.worksSet,
    required this.nttWorksSet,
  });

  factory LamodaEntityDto.fromJson(Map<String, dynamic> json) => _$LamodaEntityDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LamodaEntityDtoToJson(this);
}

extension LamodaEntityDtoMapper on LamodaEntityDto {
  LamodaEntity toLamodaEntity() => LamodaEntity(
    shifts: shifts.map((String shiftTimeJson, WorkerShifts workerShifts) {
      return MapEntry<ShiftTime, WorkerShifts>(
        ShiftTimeDto.fromJson(jsonDecode(shiftTimeJson)),
        workerShifts,
      );
    }),
    nttShifts: nttShifts.map((String shiftTimeJson, WorkerShifts workerShifts) {
      return MapEntry<ShiftTime, WorkerShifts>(
        ShiftTimeDto.fromJson(jsonDecode(shiftTimeJson)),
        workerShifts,
      );
    }),
    worksSet: worksSet,
    nttWorksSet: nttWorksSet,
    lamodaEmployees: lamodaEmployees,
  );
}

extension LamodaEntityMapper on LamodaEntity {
  LamodaEntityDto toDto() => LamodaEntityDto(
    shifts: shifts.map((ShiftTime shiftTime, WorkerShifts shifts) => 
      MapEntry<String, WorkerShifts>(
        jsonEncode(shiftTime.toDto().toJson()), shifts)),
    nttShifts: nttShifts.map((ShiftTime shiftTime, WorkerShifts shifts) => 
      MapEntry<String, WorkerShifts>(
        jsonEncode(shiftTime.toDto().toJson()), shifts)),
    worksSet: worksSet,
    nttWorksSet: nttWorksSet,
    lamodaEmployees: lamodaEmployees.map((String key, EmployeeDetails value) => 
      MapEntry<String, EmployeeDetailsDto>(key, value.toDto())),
    );
}