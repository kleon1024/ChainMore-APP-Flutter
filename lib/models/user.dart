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

  User({
    this.loginType,
    this.code,
    this.nickname,
    this.username,
    this.accessToken,
    this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
