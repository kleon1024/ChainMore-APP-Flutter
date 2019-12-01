import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int loginType;
  int code;
  String nickname;
  String username;
  String accessToken;
  String refreshToken;
  int accessTokenExpireTime;
  int refreshTokenExpireTime;

  User({
    this.loginType,
    this.code,
    this.nickname,
    this.username,
    this.accessToken,
    this.refreshToken,
    this.accessTokenExpireTime,
    this.refreshTokenExpireTime,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
