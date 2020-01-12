import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/category.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/emoji.dart';
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
  List<Category> categories;
  Domain domain;
  int votes;
  int comments;
  int collects;
  List<Emoji> emojis;

  bool collected;

  Post({
    this.id,
    this.title,
    this.description,
    this.url,
    this.timestamp,
    this.author,
    this.categories,
    this.domain,
    this.votes,
    this.comments,
    this.collects,
    this.emojis,

    this.collected,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
