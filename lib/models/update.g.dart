// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Update _$UpdateFromJson(Map<String, dynamic> json) {
  return Update(
    appStoreUrl: json['appStoreUrl'] as String,
    apkUrl: json['apkUrl'] as String,
    version: json['version'] as String,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$UpdateToJson(Update instance) => <String, dynamic>{
      'appStoreUrl': instance.appStoreUrl,
      'apkUrl': instance.apkUrl,
      'version': instance.version,
      'content': instance.content,
    };
