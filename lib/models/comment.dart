import 'package:chainmore/models/author.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int     id;
  String  body;
  String  timestamp;
  int     replied;
  Author  author;
  int     post;
  int     votes;
  int     replies;

  Comment({

  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
