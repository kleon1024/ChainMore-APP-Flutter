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
  bool    dirty_mark;
  bool    marked;
  bool    certified;

  /// Search
  int count = 0;

  DomainBean({
    this.id,
    this.title,
    this.intro,
    this.creator_id,
    this.create_time,
    this.modify_time,
    this.deleting = false,
    this.deleted = false,
    this.dirty_mark = false,
    this.marked = false,
    this.certified = false,
    this.count = 0,
  });

  factory DomainBean.fromJson(Map<String, dynamic> json) => _$DomainBeanFromJson(json);

  Map<String, dynamic> toJson() => _$DomainBeanToJson(this);
}
