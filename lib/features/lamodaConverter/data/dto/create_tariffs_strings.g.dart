// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_tariffs_strings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTariffsStrings _$CreateTariffsStringsFromJson(
  Map<String, dynamic> json,
) => CreateTariffsStrings(
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

Map<String, dynamic> _$CreateTariffsStringsToJson(
  CreateTariffsStrings instance,
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
};
