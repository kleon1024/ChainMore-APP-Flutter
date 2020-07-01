// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) {
  return Resource(
    id: json['id'] as int,
    title: json['title'] as String,
    url: json['url'] as String,
    external: json['external'] as bool,
    free: json['free'] as bool,
    resource_type_id: json['resource_type_id'] as int,
    media_type_id: json['media_type_id'] as int,
    author_id: json['author_id'] as int,
    timestamp: json['timestamp'] as String,
    deleted: json['deleted'] as bool,
  );
}

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'external': instance.external,
      'free': instance.free,
      'resource_type_id': instance.resource_type_id,
      'media_type_id': instance.media_type_id,
      'author_id': instance.author_id,
      'timestamp': instance.timestamp,
      'deleted': instance.deleted,
    };
