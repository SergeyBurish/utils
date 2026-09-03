import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/typedefs.dart';

part 'handle_tariffs_output_dto.g.dart';

@JsonSerializable()
class HandleTariffsOutputDto {
  final LamodaTariffs? lamodaTariffs;
  final String error;
  final List<String> errorArgs;

  HandleTariffsOutputDto({
    required this.lamodaTariffs,
    required this.error,
    required this.errorArgs,
  });

  factory HandleTariffsOutputDto.fromJson(Map<String, dynamic> json) => _$HandleTariffsOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$HandleTariffsOutputDtoToJson(this);
}