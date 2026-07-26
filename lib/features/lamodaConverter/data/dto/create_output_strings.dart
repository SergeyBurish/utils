import 'package:json_annotation/json_annotation.dart';

part 'create_output_strings.g.dart';

@JsonSerializable()
class CreateOutputStrings {
  final String from;
  final String day;
  final String night;

  CreateOutputStrings({required this.from, required this.day, required this.night});

  factory CreateOutputStrings.fromJson(Map<String, dynamic> json) => _$CreateOutputStringsFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOutputStringsToJson(this);
}