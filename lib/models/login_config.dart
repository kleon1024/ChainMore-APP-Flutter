import 'package:json_annotation/json_annotation.dart';

part 'login_config.g.dart';

@JsonSerializable()
class LoginConfig {
  bool initial;

  LoginConfig({
    this.initial
  });

  factory LoginConfig.fromJson(Map<String, dynamic> json) => _$LoginConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LoginConfigToJson(this);
}
