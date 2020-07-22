import 'package:json_annotation/json_annotation.dart';

part 'collection_bean.g.dart';

@JsonSerializable()
class CollectionBean {
  int id;
  String title;
  String description;
  int author_id;
  int head_id;
  int reply_id;
  int domain_id;
  String domain_title;
  String indicator;
  int type_id;
  String create_time;
  String modify_time;
  bool deleted;

  /// Local Columns
  bool dirty_collect;
  bool dirty_modify;

  bool collected;

  CollectionBean({
    this.id,
    this.title,
    this.author_id,
    this.head_id,
    this.reply_id,
    this.domain_id,
    this.domain_title,
    this.indicator,
    this.type_id,
    this.create_time,
    this.modify_time,
    this.deleted = false,
    this.dirty_collect = false,
    this.dirty_modify = false,
    this.collected = false,
  });

  factory CollectionBean.fromJson(Map<String, dynamic> json) =>
      _$CollectionBeanFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionBeanToJson(this);
}
