import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/amount_price.dart';

part 'amount_price_dto.g.dart';

@JsonSerializable()
class AmountPriceDto extends AmountPrice {
  AmountPriceDto({required super.amount, super.price});

  factory AmountPriceDto.fromJson(Map<String, dynamic> json) => _$AmountPriceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AmountPriceDtoToJson(this);
}

extension AmountPriceMapper on AmountPrice {
  AmountPriceDto toDto() => AmountPriceDto(amount: amount, price: price);
}