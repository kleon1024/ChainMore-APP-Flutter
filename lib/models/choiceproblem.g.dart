// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choiceproblem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoiceProblem _$ChoiceProblemFromJson(Map<String, dynamic> json) {
  return ChoiceProblem(
    id: json['id'] as int,
    body: json['body'] as String,
    choices: (json['choices'] as List)
        ?.map((e) =>
            e == null ? null : Choice.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    selectedChoices:
        (json['selectedChoices'] as List)?.map((e) => e as int)?.toList(),
    rule: json['rule'] as int,
  );
}

Map<String, dynamic> _$ChoiceProblemToJson(ChoiceProblem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'choices': instance.choices,
      'selectedChoices': instance.selectedChoices,
      'rule': instance.rule,
    };
