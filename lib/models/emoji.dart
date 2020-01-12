import 'package:json_annotation/json_annotation.dart';

part 'emoji.g.dart';

@JsonSerializable()
class Emoji {
  int id;
  String emoji;
  int count;

  Emoji({
    this.id,
    this.emoji,
    this.count,
  });

  factory Emoji.fromJson(Map<String, dynamic> json) => _$EmojiFromJson(json);

  Map<String, dynamic> toJson() => _$EmojiToJson(this);
}
