// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handle_employees_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandleEmployeesOutputDto _$HandleEmployeesOutputDtoFromJson(
  Map<String, dynamic> json,
) => HandleEmployeesOutputDto(
  lamodaEmployees: (json['lamodaEmployees'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, EmployeeDetailsDto.fromJson(e as Map<String, dynamic>)),
  ),
  error: json['error'] as String,
  errorArgs: (json['errorArgs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$HandleEmployeesOutputDtoToJson(
  HandleEmployeesOutputDto instance,
) => <String, dynamic>{
  'lamodaEmployees': instance.lamodaEmployees,
  'error': instance.error,
  'errorArgs': instance.errorArgs,
};
