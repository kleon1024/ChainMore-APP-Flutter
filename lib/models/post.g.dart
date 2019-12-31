// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    url: json['url'] as String,
    timestamp: json['timestamp'] as String,
    author: json['author'] == null
        ? null
        : Author.fromJson(json['author'] as Map<String, dynamic>),
    category: json['category'] as String,
    domain: json['domain'] == null
        ? null
        : Domain.fromJson(json['domain'] as Map<String, dynamic>),
    votes: json['votes'] as int,
    comments: json['comments'] as int,
    collects: json['collects'] as int,
    collected: json['collected'] as bool,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'timestamp': instance.timestamp,
      'author': instance.author,
      'category': instance.category,
      'domain': instance.domain,
      'votes': instance.votes,
      'comments': instance.comments,
      'collects': instance.collects,
      'collected': instance.collected,
    };
