import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  String title;
  String description;
  String url;
  String timestamp;
  Author author;
  String category;
  Domain domain;
  int votes;
  int comments;
  int collects;

  Post({
    this.id,
    this.title,
    this.description,
    this.url,
    this.timestamp,
    this.author,
    this.category,
    this.domain,
    this.votes,
    this.comments,
    this.collects,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
