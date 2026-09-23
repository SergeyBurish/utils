import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/employee_details.dart';
import '../../domain/entity/typedefs.dart';
import 'employee_details_dto.dart';

part 'handle_employees_output_dto.g.dart';

@JsonSerializable()
class HandleEmployeesOutputDto {
  final Map<String, EmployeeDetailsDto>? lamodaEmployees;
  final String error;
  final List<String> errorArgs;

  HandleEmployeesOutputDto({this.lamodaEmployees, required this.error, required this.errorArgs});
  HandleEmployeesOutputDto.fromLamodaEmployees({
    LamodaEmployees? lamodaEmployees, 
    required this.error,
    required this.errorArgs,
  }) : lamodaEmployees = lamodaEmployees?.map(
    (String key, EmployeeDetails value) => MapEntry<String, EmployeeDetailsDto>(key, value.toDto())
  );
  
  factory HandleEmployeesOutputDto.fromJson(Map<String, dynamic> json) => _$HandleEmployeesOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$HandleEmployeesOutputDtoToJson(this);
}
