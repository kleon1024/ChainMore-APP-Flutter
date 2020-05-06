// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadMap _$RoadMapFromJson(Map<String, dynamic> json) {
  return RoadMap(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    createTimestamp: json['createTimestamp'] as String,
    modifyTimestamp: json['modifyTimestamp'] as String,
    creator: json['creator'] == null
        ? null
        : Author.fromJson(json['creator'] as Map<String, dynamic>),
    learners: json['learners'] as int,
    heads: json['heads'] == null
        ? null
        : DomainTree.fromJson(json['heads'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RoadMapToJson(RoadMap instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createTimestamp': instance.createTimestamp,
      'modifyTimestamp': instance.modifyTimestamp,
      'creator': instance.creator,
      'learners': instance.learners,
      'heads': instance.heads,
    };
