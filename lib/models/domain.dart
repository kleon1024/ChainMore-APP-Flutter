import 'package:json_annotation/json_annotation.dart';

part 'domain.g.dart';

@JsonSerializable()
class Domain {
  int     id;
  String  title;
  String  timestamp;
  int     watchers;
  String  bio;
  int     posts;
  String  description;
  List<Domain> aggregators;
  List<Domain> aggregateds;
  List<Domain> dependeds;
  List<Domain> dependants;

  bool certified;
  bool depended;
  bool watched;

  Domain({
    this.id,
    this.title,
    this.timestamp,
    this.watchers,
    this.bio,
    this.posts,
    this.description,
    this.aggregators,
    this.aggregateds,
    this.dependeds,
    this.dependants,
    this.certified,
    this.depended,
    this.watched,
  });

  factory Domain.fromJson(Map<String, dynamic> json) => _$DomainFromJson(json);

  Map<String, dynamic> toJson() => _$DomainToJson(this);
}
