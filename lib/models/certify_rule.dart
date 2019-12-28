import 'package:chainmore/models/choiceproblem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certify_rule.g.dart';

@JsonSerializable()
class CertifyRule {
  int     id;
  String  type;
  List<ChoiceProblem> choiceproblems;
  
  CertifyRule({
    this.id,
    this.type,
    this.choiceproblems,
  });

  factory CertifyRule.fromJson(Map<String, dynamic> json) => _$CertifyRuleFromJson(json);

  Map<String, dynamic> toJson() => _$CertifyRuleToJson(this);
}
