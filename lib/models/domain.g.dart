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
    aggregators: (json['aggregators'] as List)
        ?.map((e) =>
            e == null ? null : Domain.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    aggregateds: (json['aggregateds'] as List)
        ?.map((e) =>
            e == null ? null : Domain.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    dependeds: (json['dependeds'] as List)
        ?.map((e) =>
            e == null ? null : Domain.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    dependants: (json['dependants'] as List)
        ?.map((e) =>
            e == null ? null : Domain.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    certified: json['certified'] as bool,
    depended: json['depended'] as bool,
    watched: json['watched'] as bool,
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
      'aggregators': instance.aggregators,
      'aggregateds': instance.aggregateds,
      'dependeds': instance.dependeds,
      'dependants': instance.dependants,
      'certified': instance.certified,
      'depended': instance.depended,
      'watched': instance.watched,
    };
