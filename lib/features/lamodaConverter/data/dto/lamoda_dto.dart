import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/lamoda_entity.dart';

part 'lamoda_dto.g.dart';

@JsonSerializable()
class LamodaDto extends LamodaEntity {
  LamodaDto({required super.uploadPath});

  factory LamodaDto.fromJson(Map<String, dynamic> json) => _$LamodaDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LamodaDtoToJson(this);
}

extension CountMapper on LamodaEntity {
  LamodaDto toDto() => LamodaDto(uploadPath: uploadPath);
}