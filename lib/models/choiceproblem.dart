import 'package:chainmore/models/choice.dart';
import 'package:json_annotation/json_annotation.dart';

part 'choiceproblem.g.dart';

@JsonSerializable()
class ChoiceProblem {
  int     id;
  String  body;
  List<Choice> choices;
  List<int> selectedChoices;
  int     rule;
  
  ChoiceProblem({
    this.id,
    this.body,
    this.choices,
    this.selectedChoices,
    this.rule,
  });

  factory ChoiceProblem.fromJson(Map<String, dynamic> json) => _$ChoiceProblemFromJson(json);

  Map<String, dynamic> toJson() => _$ChoiceProblemToJson(this);
}
