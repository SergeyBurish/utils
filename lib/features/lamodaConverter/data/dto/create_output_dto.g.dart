// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOutputDto _$CreateOutputDtoFromJson(Map<String, dynamic> json) =>
    CreateOutputDto(
      lamodaEntityDto: LamodaEntityDto.fromJson(
        json['lamodaEntityDto'] as Map<String, dynamic>,
      ),
      createOutputStrings: CreateOutputStrings.fromJson(
        json['createOutputStrings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CreateOutputDtoToJson(CreateOutputDto instance) =>
    <String, dynamic>{
      'lamodaEntityDto': instance.lamodaEntityDto,
      'createOutputStrings': instance.createOutputStrings,
    };
