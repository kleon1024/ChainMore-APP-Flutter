import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hot_search_data.g.dart';

@JsonSerializable()
class HotSearchData {
  List<String> queries;
  
  HotSearchData({
    this.queries,
  });

  factory HotSearchData.fromJson(Map<String, dynamic> json) => _$HotSearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$HotSearchDataToJson(this);
}
