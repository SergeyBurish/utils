import 'package:json_annotation/json_annotation.dart';

import 'create_output_strings.dart';
import 'lamoda_entity_dto.dart';
import 'lm_column.dart';

part 'create_output_dto.g.dart';

@JsonSerializable()
class CreateOutputDto {
  final LamodaEntityDto lamodaEntityDto;
  final Map<int, LmColumn> columnsFD1;
  final Map<int, LmColumn> columnsFD2;
  final Map<int, LmColumn> columnsED;
  final CreateOutputStrings createOutputStrings;

  CreateOutputDto({
    required this.lamodaEntityDto,
    required this.columnsFD1,
    required this.columnsFD2,
    required this.columnsED,
    required this.createOutputStrings,
  });

  factory CreateOutputDto.fromJson(Map<String, dynamic> json) => _$CreateOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOutputDtoToJson(this);
}