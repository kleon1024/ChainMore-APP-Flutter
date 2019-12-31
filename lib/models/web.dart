import 'package:chainmore/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'web.g.dart';

@JsonSerializable()
class Web {
  String url;
  Post post;

  Web({
    this.url,
    this.post,
  });

  factory Web.fromJson(Map<String, dynamic> json) => _$WebFromJson(json);

  Map<String, dynamic> toJson() => _$WebToJson(this);
}
