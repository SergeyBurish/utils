import 'package:json_annotation/json_annotation.dart';

import 'amount_price_dto.dart';
import 'typedefs_dto.dart';

part 'handle_penalties_output_dto.g.dart';

@JsonSerializable()
class HandlePenaltiesOutputDto {
  final PenaltiesDto? penalties;
  final String error;
  final List<String> errorArgs;

  HandlePenaltiesOutputDto({this.penalties, required this.error, required this.errorArgs});

  factory HandlePenaltiesOutputDto.fromJson(Map<String, dynamic> json) => _$HandlePenaltiesOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$HandlePenaltiesOutputDtoToJson(this);
}