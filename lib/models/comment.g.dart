// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    id: json['id'] as int,
    body: json['body'] as String,
    timestamp: json['timestamp'] as String,
    replied: json['replied'] as int,
    author: json['author'] == null
        ? null
        : Author.fromJson(json['author'] as Map<String, dynamic>),
    post: json['post'] as int,
    votes: json['votes'] as int,
    replies: json['replies'] as int,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'timestamp': instance.timestamp,
      'replied': instance.replied,
      'author': instance.author,
      'post': instance.post,
      'votes': instance.votes,
      'replies': instance.replies,
    };
