// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sparkle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sparkle _$SparkleFromJson(Map<String, dynamic> json) {
  return Sparkle(
    id: json['id'] as int,
    body: json['body'] as String,
    deleted: json['deleted'] as bool,
    timestamp: json['timestamp'] as String,
    author: json['author'] == null
        ? null
        : Author.fromJson(json['author'] as Map<String, dynamic>),
    votes: json['votes'] as int,
    replied: json['replied'] == null
        ? null
        : Sparkle.fromJson(json['replied'] as Map<String, dynamic>),
    replies: (json['replies'] as List)
        ?.map((e) =>
            e == null ? null : Sparkle.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SparkleToJson(Sparkle instance) => <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'timestamp': instance.timestamp,
      'deleted': instance.deleted,
      'author': instance.author,
      'votes': instance.votes,
      'replied': instance.replied,
      'replies': instance.replies,
    };
