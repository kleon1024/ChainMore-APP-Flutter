// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainBean _$DomainBeanFromJson(Map<String, dynamic> json) {
  return DomainBean(
    id: json['id'] as int,
    title: json['title'] as String,
    intro: json['intro'] as String,
    creator_id: json['creator_id'] as int,
    create_time: json['create_time'] as String,
    modify_time: json['modify_time'] as String,
    deleting: json['deleting'] as bool,
    deleted: json['deleted'] as bool,
    local_id: json['local_id'] as int,
    dirty: json['dirty'] as bool,
    update_time: json['update_time'] as String,
    marked: json['marked'] as bool,
  );
}

Map<String, dynamic> _$DomainBeanToJson(DomainBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'intro': instance.intro,
      'creator_id': instance.creator_id,
      'create_time': instance.create_time,
      'modify_time': instance.modify_time,
      'deleting': instance.deleting,
      'deleted': instance.deleted,
      'local_id': instance.local_id,
      'dirty': instance.dirty,
      'update_time': instance.update_time,
      'marked': instance.marked,
    };