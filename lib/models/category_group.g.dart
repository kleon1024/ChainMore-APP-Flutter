// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryGroup _$CategoryGroupFromJson(Map<String, dynamic> json) {
  return CategoryGroup(
    id: json['id'] as int,
    title: json['title'] as String,
    categories: (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CategoryGroupToJson(CategoryGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'categories': instance.categories,
    };
