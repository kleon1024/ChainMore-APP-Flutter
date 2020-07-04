import 'package:json_annotation/json_annotation.dart';

part 'resource_media_bean.g.dart';

@JsonSerializable()
class ResourceMediaBean {
  int     resource_id;
  int     media_id;
  String  resource_name;
  String  media_name;

  ResourceMediaBean({
    this.resource_id,
    this.media_id,
    this.resource_name,
    this.media_name,
  });

  factory ResourceMediaBean.fromJson(Map<String, dynamic> json) => _$ResourceMediaBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceMediaBeanToJson(this);
}
