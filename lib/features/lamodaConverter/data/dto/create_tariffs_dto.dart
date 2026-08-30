import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/typedefs.dart';
import 'create_tariffs_strings.dart';

part 'create_tariffs_dto.g.dart';

@JsonSerializable()
class CreateTariffsDto {
  final LamodaTariffs lamodaTariffs;
  final Set<String> worksSet;
  final CreateTariffsStrings createTariffsStrings;

  CreateTariffsDto({
    required this.lamodaTariffs,
    required this.worksSet,
    required this.createTariffsStrings,
  });

  factory CreateTariffsDto.fromJson(Map<String, dynamic> json) => _$CreateTariffsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTariffsDtoToJson(this);
}