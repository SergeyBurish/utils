import 'package:json_annotation/json_annotation.dart';

part 'create_output_strings.g.dart';

@JsonSerializable()
class CreateOutputStrings {
  final String from;
  final String bid;
  final String day;
  final String night;
  final String basicTariffs;
  final String processEng;
  final String tariffForWages;
  final String employeeDetails;

  CreateOutputStrings({
    required this.from,
    required this.bid,
    required this.day,
    required this.night,
    required this.basicTariffs,
    required this.processEng,
    required this.tariffForWages,
    required this.employeeDetails,
  });

  factory CreateOutputStrings.fromJson(Map<String, dynamic> json) => _$CreateOutputStringsFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOutputStringsToJson(this);
}