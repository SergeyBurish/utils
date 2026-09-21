import 'package:json_annotation/json_annotation.dart';

part 'create_employees_strings.g.dart';

@JsonSerializable()
class CreateEmployeesStrings {
  final String employeeDetails;

  CreateEmployeesStrings({required this.employeeDetails});

  factory CreateEmployeesStrings.fromJson(Map<String, dynamic> json) => _$CreateEmployeesStringsFromJson(json);
  Map<String, dynamic> toJson() => _$CreateEmployeesStringsToJson(this);
}