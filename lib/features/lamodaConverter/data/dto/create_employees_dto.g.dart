// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_employees_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateEmployeesDto _$CreateEmployeesDtoFromJson(Map<String, dynamic> json) =>
    CreateEmployeesDto(
      lamodaEmployees: (json['lamodaEmployees'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, EmployeeDetailsDto.fromJson(e as Map<String, dynamic>)),
      ),
      columns: (json['columns'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          int.parse(k),
          LmColumn.fromJson(e as Map<String, dynamic>),
        ),
      ),
      createEmployeesStrings: CreateEmployeesStrings.fromJson(
        json['createEmployeesStrings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreateEmployeesDtoToJson(CreateEmployeesDto instance) =>
    <String, dynamic>{
      'lamodaEmployees': instance.lamodaEmployees,
      'columns': instance.columns.map((k, e) => MapEntry(k.toString(), e)),
      'createEmployeesStrings': instance.createEmployeesStrings,
    };
