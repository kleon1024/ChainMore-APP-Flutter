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

  Domain({
    this.id,
    this.title,
    this.timestamp,
    this.watchers,
    this.bio,
    this.posts,
    this.description,
  });

  factory Domain.fromJson(Map<String, dynamic> json) => _$DomainFromJson(json);

  Map<String, dynamic> toJson() => _$DomainToJson(this);
}
