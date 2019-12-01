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
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    accessTokenExpireTime: json['accessTokenExpireTime'] as int,
    refreshTokenExpireTime: json['refreshTokenExpireTime'] as int,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'loginType': instance.loginType,
      'code': instance.code,
      'nickname': instance.nickname,
      'username': instance.username,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpireTime': instance.accessTokenExpireTime,
      'refreshTokenExpireTime': instance.refreshTokenExpireTime,
    };
