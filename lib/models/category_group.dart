import 'package:chainmore/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_group.g.dart';

@JsonSerializable()
class CategoryGroup {
  int id;
  String title;
  List<Category> categories;

  CategoryGroup({
    this.id,
    this.title,
    this.categories,
  });

  factory CategoryGroup.fromJson(Map<String, dynamic> json) => _$CategoryGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryGroupToJson(this);
}
