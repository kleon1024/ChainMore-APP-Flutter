import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sparkle.g.dart';

@JsonSerializable()
class Sparkle {
  int id;
  String body;
  String timestamp;
  bool deleted;
  Author author;
  int votes;
  Sparkle replied;
  List<Sparkle> replies;

  Sparkle({
    this.id,
    this.body,
    this.deleted,
    this.timestamp,
    this.author,
    this.votes,
    this.replied,
    this.replies,
  });

  factory Sparkle.fromJson(Map<String, dynamic> json) => _$SparkleFromJson(json);

  Map<String, dynamic> toJson() => _$SparkleToJson(this);
}
