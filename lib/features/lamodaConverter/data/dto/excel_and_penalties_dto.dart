import 'package:json_annotation/json_annotation.dart';

import 'amount_price_dto.dart';
import 'handle_excel_dto.dart';
import 'typedefs_dto.dart';

part 'excel_and_penalties_dto.g.dart';

@JsonSerializable()
class ExcelAndPenaltiesDto extends HandleExcelDto {
  final PenaltiesDto penalties;
  ExcelAndPenaltiesDto({required super.bytes, required this.penalties});

  factory ExcelAndPenaltiesDto.fromJson(Map<String, dynamic> json) => _$ExcelAndPenaltiesDtoFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$ExcelAndPenaltiesDtoToJson(this);
}