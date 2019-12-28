// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certify_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertifyRule _$CertifyRuleFromJson(Map<String, dynamic> json) {
  return CertifyRule(
    id: json['id'] as int,
    type: json['type'] as String,
    choiceproblems: (json['choiceproblems'] as List)
        ?.map((e) => e == null
            ? null
            : ChoiceProblem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CertifyRuleToJson(CertifyRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'choiceproblems': instance.choiceproblems,
    };
