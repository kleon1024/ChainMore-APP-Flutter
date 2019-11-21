// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      loginType: json['loginType'] as int,
      code: json['code'] as int,
      nickname: json['nickname'] as String,
      username: json['username'] as String,
      accessToken: json['accessToken'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'loginType': instance.loginType,
      'code': instance.code,
      'nickname': instance.nickname,
      'username': instance.username,
      'accessToken': instance.accessToken
    };
