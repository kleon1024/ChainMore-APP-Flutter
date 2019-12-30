import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  String nickname;
  String username;
  String bio;
  int likeds;
  int watcheds;
  int followings;
  int followers;
  int posts;
  int domains;
  int comments;
  int certifieds;

  UserInfo({
    this.nickname,
    this.username,
    this.bio,
    this.likeds,
    this.watcheds,
    this.followings,
    this.followers,
    this.posts,
    this.domains,
    this.comments,
    this.certifieds,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
