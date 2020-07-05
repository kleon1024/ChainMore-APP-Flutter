// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionBean _$CollectionBeanFromJson(Map<String, dynamic> json) {
  return CollectionBean(
    id: json['id'] as int,
    title: json['title'] as String,
    author_id: json['author_id'] as int,
    head_id: json['head_id'] as int,
    reply_id: json['reply_id'] as int,
    domain_id: json['domain_id'] as int,
    create_time: json['create_time'] as String,
    modify_time: json['modify_time'] as String,
    deleted: json['deleted'] as bool,
    local_id: json['local_id'] as int,
    dirty: json['dirty'] as bool,
    update_time: json['update_time'] as String,
    collected: json['collected'] as bool,
  )..description = json['description'] as String;
}

Map<String, dynamic> _$CollectionBeanToJson(CollectionBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'author_id': instance.author_id,
      'head_id': instance.head_id,
      'reply_id': instance.reply_id,
      'domain_id': instance.domain_id,
      'create_time': instance.create_time,
      'modify_time': instance.modify_time,
      'deleted': instance.deleted,
      'local_id': instance.local_id,
      'dirty': instance.dirty,
      'update_time': instance.update_time,
      'collected': instance.collected,
    };
