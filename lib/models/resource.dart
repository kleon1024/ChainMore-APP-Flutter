import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class Resource {
  int     id;
  String  title;
  String  url;
  bool    external;
  bool    free;
  int     resource_type_id;
  int     media_type_id;
  int     author_id;
  String  timestamp;
  bool    deleted;

  Resource({
    this.id,
    this.title,
    this.url,
    this.external,
    this.free,
    this.resource_type_id,
    this.media_type_id,
    this.author_id,
    this.timestamp,
    this.deleted,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => _$ResourceFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceToJson(this);
}
