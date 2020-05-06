import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/domain_tree.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roadmap.g.dart';

@JsonSerializable()
class RoadMap {
  int id;
  String title;
  String description;
  String createTimestamp;
  String modifyTimestamp;
  Author creator;
  int learners;
  DomainTree heads;

  RoadMap({
    this.id,
    this.title,
    this.description,
    this.createTimestamp,
    this.modifyTimestamp,
    this.creator,
    this.learners,
    this.heads,
  });

  factory RoadMap.fromJson(Map<String, dynamic> json) => _$RoadMapFromJson(json);

  Map<String, dynamic> toJson() => _$RoadMapToJson(this);
}
