// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    nickname: json['nickname'] as String,
    username: json['username'] as String,
    bio: json['bio'] as String,
    likeds: json['likeds'] as int,
    watcheds: json['watcheds'] as int,
    followings: json['followings'] as int,
    followers: json['followers'] as int,
    posts: json['posts'] as int,
    domains: json['domains'] as int,
    comments: json['comments'] as int,
    certifieds: json['certifieds'] as int,
    rootCertified: json['rootCertified'] as bool,
    following: json['following'] as bool,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'username': instance.username,
      'bio': instance.bio,
      'likeds': instance.likeds,
      'watcheds': instance.watcheds,
      'followings': instance.followings,
      'followers': instance.followers,
      'posts': instance.posts,
      'domains': instance.domains,
      'comments': instance.comments,
      'certifieds': instance.certifieds,
      'rootCertified': instance.rootCertified,
      'following': instance.following,
    };
