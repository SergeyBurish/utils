import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'handle_excel_dto.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List, String> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(String json) {
    return base64Decode(json);
  }

  @override
  String toJson(Uint8List object) {
    return base64Encode(object);
  }
}

@JsonSerializable()
class HandleExcelDto {
  @Uint8ListConverter()
  final Uint8List bytes;

  HandleExcelDto({required this.bytes});

  factory HandleExcelDto.fromJson(Map<String, dynamic> json) => _$HandleExcelDtoFromJson(json);
  Map<String, dynamic> toJson() => _$HandleExcelDtoToJson(this);
}