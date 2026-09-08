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
      employeeDetails: json['employeeDetails'] as String,
      tariffs: json['tariffs'] as String,
      coeffWages: json['coeffWages'] as String,
      coeffWages2months: json['coeffWages2months'] as String,
      tariffStartDate: json['tariffStartDate'] as String,
      processEng: json['processEng'] as String,
      cost1service: json['cost1service'] as String,
      tariffWages: json['tariffWages'] as String,
      tariffWages2months: json['tariffWages2months'] as String,
      shouldBeDateHere: json['shouldBeDateHere'] as String,
    );

Map<String, dynamic> _$CreateOutputStringsToJson(
  CreateOutputStrings instance,
) => <String, dynamic>{
  'tariffs': instance.tariffs,
  'coeffWages': instance.coeffWages,
  'coeffWages2months': instance.coeffWages2months,
  'tariffStartDate': instance.tariffStartDate,
  'processEng': instance.processEng,
  'cost1service': instance.cost1service,
  'tariffWages': instance.tariffWages,
  'tariffWages2months': instance.tariffWages2months,
  'shouldBeDateHere': instance.shouldBeDateHere,
  'from': instance.from,
  'bid': instance.bid,
  'day': instance.day,
  'night': instance.night,
  'basicTariffs': instance.basicTariffs,
  'employeeDetails': instance.employeeDetails,
};
