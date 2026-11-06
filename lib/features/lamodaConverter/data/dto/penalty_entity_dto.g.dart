// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penalty_entity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PenaltyEntityDto _$PenaltyEntityDtoFromJson(Map<String, dynamic> json) =>
    PenaltyEntityDto(
      description: json['description'] as String,
      amount: (json['amount'] as num).toInt(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PenaltyEntityDtoToJson(PenaltyEntityDto instance) =>
    <String, dynamic>{
      'description': instance.description,
      'amount': instance.amount,
      'price': instance.price,
    };
