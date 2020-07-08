import 'package:json_annotation/json_annotation.dart';

part 'domain_bean.g.dart';

@JsonSerializable()
class DomainBean {
  int     id;
  String  title;
  String  intro;
  int     creator_id;
  String  create_time;
  String  modify_time;
  bool    deleting;
  bool    deleted;

  /// Local Columns
  int     local_id;
  bool    dirty;
  String  update_time;
  bool    marked;

  DomainBean({
    this.id,
    this.title,
    this.intro,
    this.creator_id,
    this.create_time,
    this.modify_time,
    this.deleting,
    this.deleted,
    this.local_id,
    this.dirty,
    this.update_time,
    this.marked,
  });

  factory DomainBean.fromJson(Map<String, dynamic> json) => _$DomainBeanFromJson(json);

  Map<String, dynamic> toJson() => _$DomainBeanToJson(this);
}
