import 'package:json_annotation/json_annotation.dart';

part 'create_tariffs_strings.g.dart';

@JsonSerializable()
class CreateTariffsStrings {
  final String tariffs;
  final String coeffWages;
  final String coeffWages2months;
  final String tariffStartDate;
  final String processEng;
  final String cost1service;
  final String tariffWages;
  final String tariffWages2months;
  final String shouldBeDateHere;

  CreateTariffsStrings({
    required this.tariffs,
    required this.coeffWages,
    required this.coeffWages2months,
    required this.tariffStartDate,
    required this.processEng,
    required this.cost1service,
    required this.tariffWages,
    required this.tariffWages2months,
    required this.shouldBeDateHere,
  });

  factory CreateTariffsStrings.fromJson(Map<String, dynamic> json) => _$CreateTariffsStringsFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTariffsStringsToJson(this);
}