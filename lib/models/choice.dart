import 'package:json_annotation/json_annotation.dart';

part 'choice.g.dart';

@JsonSerializable()
class Choice {
  int     id;
  String  body;

  Choice({
    this.id,
    this.body,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
