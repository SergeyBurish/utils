// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handle_excel_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandleExcelOutputDto _$HandleExcelOutputDtoFromJson(
  Map<String, dynamic> json,
) => HandleExcelOutputDto(
  lamodaEntityDto: json['lamodaEntityDto'] == null
      ? null
      : LamodaEntityDto.fromJson(
          json['lamodaEntityDto'] as Map<String, dynamic>,
        ),
  error: json['error'] as String,
  errorArgs: (json['errorArgs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$HandleExcelOutputDtoToJson(
  HandleExcelOutputDto instance,
) => <String, dynamic>{
  'lamodaEntityDto': instance.lamodaEntityDto,
  'error': instance.error,
  'errorArgs': instance.errorArgs,
};
