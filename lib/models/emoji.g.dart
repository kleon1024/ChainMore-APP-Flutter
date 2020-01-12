// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emoji _$EmojiFromJson(Map<String, dynamic> json) {
  return Emoji(
    id: json['id'] as int,
    emoji: json['emoji'] as String,
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$EmojiToJson(Emoji instance) => <String, dynamic>{
      'id': instance.id,
      'emoji': instance.emoji,
      'count': instance.count,
    };
