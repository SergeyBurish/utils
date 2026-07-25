import 'package:json_annotation/json_annotation.dart';

import 'create_output_strings.dart';
import 'lamoda_entity_dto.dart';

part 'create_output_dto.g.dart';

@JsonSerializable()
class CreateOutputDto {
  final LamodaEntityDto lamodaEntityDto;
  final CreateOutputStrings createOutputStrings;

  CreateOutputDto({required this.lamodaEntityDto, required this.createOutputStrings});

  factory CreateOutputDto.fromJson(Map<String, dynamic> json) => _$CreateOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOutputDtoToJson(this);
}