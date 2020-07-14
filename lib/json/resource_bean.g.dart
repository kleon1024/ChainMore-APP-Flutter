// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceBean _$ResourceBeanFromJson(Map<String, dynamic> json) {
  return ResourceBean(
    id: json['id'] as int,
    title: json['title'] as String,
    url: json['url'] as String,
    external: json['external'] as bool,
    free: json['free'] as bool,
    resource_type_id: json['resource_type_id'] as int,
    media_type_id: json['media_type_id'] as int,
    author_id: json['author_id'] as int,
    create_time: json['create_time'] as String,
    modify_time: json['modify_time'] as String,
    deleted: json['deleted'] as bool,
    dirty_modify: json['dirty_modify'] as bool,
    dirty_collect: json['dirty_collect'] as bool,
    collected: json['collected'] as bool,
  );
}

Map<String, dynamic> _$ResourceBeanToJson(ResourceBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'external': instance.external,
      'free': instance.free,
      'resource_type_id': instance.resource_type_id,
      'media_type_id': instance.media_type_id,
      'author_id': instance.author_id,
      'create_time': instance.create_time,
      'modify_time': instance.modify_time,
      'deleted': instance.deleted,
      'dirty_modify': instance.dirty_modify,
      'dirty_collect': instance.dirty_collect,
      'collected': instance.collected,
    };
