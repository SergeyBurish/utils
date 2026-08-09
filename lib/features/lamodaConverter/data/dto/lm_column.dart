import 'package:json_annotation/json_annotation.dart';

part 'lm_column.g.dart';

@JsonSerializable()
class LmColumn {
  final String name;
  final int rotation;
  final String? bgColor;

  const LmColumn({
    required this.name,
    this.rotation = 0,
    this.bgColor,
  });

  factory LmColumn.fromJson(Map<String, dynamic> json) => _$LmColumnFromJson(json);
  Map<String, dynamic> toJson() => _$LmColumnToJson(this);
}