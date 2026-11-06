import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/penalty_entity.dart';

part 'penalty_entity_dto.g.dart';

@JsonSerializable()
class PenaltyEntityDto extends PenaltyEntity {
  PenaltyEntityDto({required super.description, required super.amount, super.price});

  factory PenaltyEntityDto.fromJson(Map<String, dynamic> json) => _$PenaltyEntityDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PenaltyEntityDtoToJson(this);
}

extension PenaltyEntityMapper on PenaltyEntity {
  PenaltyEntityDto toDto() => PenaltyEntityDto(
    description: description,
    amount: amount,
    price: price,
  );
}