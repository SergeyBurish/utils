import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/employee_details.dart';

part 'employee_details_dto.g.dart';

@JsonSerializable()
class EmployeeDetailsDto extends EmployeeDetails {
  EmployeeDetailsDto({super.fullName, super.status, super.startDateOfWork});

  factory EmployeeDetailsDto.fromJson(Map<String, dynamic> json) => _$EmployeeDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeDetailsDtoToJson(this);
}

extension EmployeeDetailsMapper on EmployeeDetails {
  EmployeeDetailsDto toDto() => EmployeeDetailsDto(fullName: fullName, status: status, startDateOfWork: startDateOfWork);
}