import 'package:json_annotation/json_annotation.dart';

part 'file_output_dto.g.dart';

@JsonSerializable()
class FileOutputDto {
  final List<int> bytes;
  final String fromDate;
  final String error;
  final List<String> errorArgs;

  FileOutputDto({
    required this.bytes,
    required this.error,
    required this.errorArgs, required this.fromDate,
  });

  factory FileOutputDto.fromJson(Map<String, dynamic> json) => _$FileOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FileOutputDtoToJson(this);
}