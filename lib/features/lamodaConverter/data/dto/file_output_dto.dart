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
    required this.fromDate,
    required this.error,
    required this.errorArgs,
  });

  factory FileOutputDto.fromJson(Map<String, dynamic> json) => _$FileOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FileOutputDtoToJson(this);
}