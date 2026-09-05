import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/tariffs_entity.dart';

part 'tariffs_entity_dto.g.dart'; 

@JsonSerializable()
class TariffsEntityDto extends TariffsEntity {
  TariffsEntityDto({required super.lamodaTariffs, required super.worksSet});

  factory TariffsEntityDto.fromJson(Map<String, dynamic> json) => _$TariffsEntityDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TariffsEntityDtoToJson(this);
}

extension TariffsEntityMapper on TariffsEntity {
  TariffsEntityDto toDto() => TariffsEntityDto(lamodaTariffs: lamodaTariffs, worksSet: worksSet);
}