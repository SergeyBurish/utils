import 'package:json_annotation/json_annotation.dart';

import 'create_tariffs_strings.dart';

part 'create_output_strings.g.dart';

@JsonSerializable()
class CreateOutputStrings extends CreateTariffsStrings {
  final String from;
  final String bid;
  final String day;
  final String night;
  final String basicTariffs;
  final String employeeDetails;

  CreateOutputStrings({
    required this.from,
    required this.bid,
    required this.day,
    required this.night,
    required this.basicTariffs,
    required this.employeeDetails,
    required String tariffs,
    required String coeffWages,
    required String coeffWages2months,
    required String tariffStartDate,
    required String processEng,
    required String cost1service,
    required String tariffWages,
    required String tariffWages2months,
    required String shouldBeDateHere,
  }) : super(
    tariffs: tariffs,
    coeffWages: coeffWages,
    coeffWages2months: coeffWages2months,
    tariffStartDate: tariffStartDate,
    processEng: processEng,
    cost1service: cost1service,
    tariffWages: tariffWages,
    tariffWages2months: tariffWages2months,
    shouldBeDateHere: shouldBeDateHere,
  );

  factory CreateOutputStrings.fromJson(Map<String, dynamic> json) => _$CreateOutputStringsFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOutputStringsToJson(this);
}