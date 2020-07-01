import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class ResourceBean {
  int     id;
  String  title;
  String  url;
  bool    external;
  bool    free;
  int     resource_type_id;
  int     media_type_id;
  int     author_id;
  String  create_time;
  String  modify_time;
  bool    deleted;

  /// Local Columns
  int     local_id;
  bool    dirty;
  String  update_time;

  ResourceBean({
    this.id,
    this.title,
    this.url,
    this.external,
    this.free,
    this.resource_type_id,
    this.media_type_id,
    this.author_id,
    this.create_time,
    this.modify_time,
    this.deleted,
    this.local_id,
    this.dirty,
    this.update_time,
  });

  factory ResourceBean.fromJson(Map<String, dynamic> json) => _$ResourceBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceBeanToJson(this);
}
