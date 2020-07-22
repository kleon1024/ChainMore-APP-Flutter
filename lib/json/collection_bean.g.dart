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
    domain_title: json['domain_title'] as String,
    indicator: json['indicator'] as String,
    type_id: json['type_id'] as int,
    create_time: json['create_time'] as String,
    modify_time: json['modify_time'] as String,
    deleted: json['deleted'] as bool,
    dirty_collect: json['dirty_collect'] as bool,
    dirty_modify: json['dirty_modify'] as bool,
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
      'domain_title': instance.domain_title,
      'indicator': instance.indicator,
      'type_id': instance.type_id,
      'create_time': instance.create_time,
      'modify_time': instance.modify_time,
      'deleted': instance.deleted,
      'dirty_collect': instance.dirty_collect,
      'dirty_modify': instance.dirty_modify,
      'collected': instance.collected,
    };
