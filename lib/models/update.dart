import 'package:json_annotation/json_annotation.dart';

part 'update.g.dart';

@JsonSerializable()
class Update {
  String appStoreUrl;
  String apkUrl;
  String version;
  String content;

  Update({
    this.appStoreUrl,
    this.apkUrl,
    this.version,
    this.content,
  });

  factory Update.fromJson(Map<String, dynamic> json) => _$UpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateToJson(this);
}
