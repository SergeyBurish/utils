import 'package:json_annotation/json_annotation.dart';

import 'create_employees_strings.dart';
import 'employee_details_dto.dart';
import 'lm_column.dart';

part 'create_employees_dto.g.dart';

@JsonSerializable()
class CreateEmployeesDto {
  final Map<String, EmployeeDetailsDto> lamodaEmployees;
  final Map<int, LmColumn> columns;
  final CreateEmployeesStrings createEmployeesStrings;

  CreateEmployeesDto({
    required this.lamodaEmployees,
    required this.columns,
    required this.createEmployeesStrings,
  });

  factory CreateEmployeesDto.fromJson(Map<String, dynamic> json) => _$CreateEmployeesDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateEmployeesDtoToJson(this);
}