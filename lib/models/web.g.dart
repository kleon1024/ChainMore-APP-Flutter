// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Web _$WebFromJson(Map<String, dynamic> json) {
  return Web(
    url: json['url'] as String,
    post: json['post'] == null
        ? null
        : Post.fromJson(json['post'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WebToJson(Web instance) => <String, dynamic>{
      'url': instance.url,
      'post': instance.post,
    };
