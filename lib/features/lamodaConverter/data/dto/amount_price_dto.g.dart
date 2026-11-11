// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountPriceDto _$AmountPriceDtoFromJson(Map<String, dynamic> json) =>
    AmountPriceDto(
      amount: (json['amount'] as num).toInt(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AmountPriceDtoToJson(AmountPriceDto instance) =>
    <String, dynamic>{'amount': instance.amount, 'price': instance.price};
