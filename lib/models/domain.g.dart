// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Domain _$DomainFromJson(Map<String, dynamic> json) {
  return Domain(
    id: json['id'] as int,
    title: json['title'] as String,
    timestamp: json['timestamp'] as String,
    watchers: json['watchers'] as int,
    bio: json['bio'] as String,
    posts: json['posts'] as int,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$DomainToJson(Domain instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'timestamp': instance.timestamp,
      'watchers': instance.watchers,
      'bio': instance.bio,
      'posts': instance.posts,
      'description': instance.description,
    };
