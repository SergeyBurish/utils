// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeDetailsDto _$EmployeeDetailsDtoFromJson(Map<String, dynamic> json) =>
    EmployeeDetailsDto(
      fullName: json['fullName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      startDateOfWork: json['startDateOfWork'] == null
          ? null
          : DateTime.parse(json['startDateOfWork'] as String),
    );

Map<String, dynamic> _$EmployeeDetailsDtoToJson(EmployeeDetailsDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'status': instance.status,
      'startDateOfWork': instance.startDateOfWork?.toIso8601String(),
    };
