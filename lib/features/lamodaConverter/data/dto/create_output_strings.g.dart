// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_output_strings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOutputStrings _$CreateOutputStringsFromJson(Map<String, dynamic> json) =>
    CreateOutputStrings(
      from: json['from'] as String,
      bid: json['bid'] as String,
      day: json['day'] as String,
      night: json['night'] as String,
      basicTariffs: json['basicTariffs'] as String,
      processEng: json['processEng'] as String,
      tariffForWages: json['tariffForWages'] as String,
    );

Map<String, dynamic> _$CreateOutputStringsToJson(
  CreateOutputStrings instance,
) => <String, dynamic>{
  'from': instance.from,
  'bid': instance.bid,
  'day': instance.day,
  'night': instance.night,
  'basicTariffs': instance.basicTariffs,
  'processEng': instance.processEng,
  'tariffForWages': instance.tariffForWages,
};
