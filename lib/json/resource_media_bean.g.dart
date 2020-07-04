// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_media_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceMediaBean _$ResourceMediaBeanFromJson(Map<String, dynamic> json) {
  return ResourceMediaBean(
    resource_id: json['resource_id'] as int,
    media_id: json['media_id'] as int,
    resource_name: json['resource_name'] as String,
    media_name: json['media_name'] as String,
  );
}

Map<String, dynamic> _$ResourceMediaBeanToJson(ResourceMediaBean instance) =>
    <String, dynamic>{
      'resource_id': instance.resource_id,
      'media_id': instance.media_id,
      'resource_name': instance.resource_name,
      'media_name': instance.media_name,
    };
