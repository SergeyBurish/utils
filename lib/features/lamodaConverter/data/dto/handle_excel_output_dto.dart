import 'package:json_annotation/json_annotation.dart';

import 'lamoda_entity_dto.dart';

part 'handle_excel_output_dto.g.dart';

@JsonSerializable()
class HandleExcelOutputDto {
  final LamodaEntityDto? lamodaEntityDto;
  final String error;
  final List<String> errorArgs;

  HandleExcelOutputDto({
    this.lamodaEntityDto,
    required this.error,
    required this.errorArgs,
  });

  factory HandleExcelOutputDto.fromJson(Map<String, dynamic> json) => _$HandleExcelOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$HandleExcelOutputDtoToJson(this);
}