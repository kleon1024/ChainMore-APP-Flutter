// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_search_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotSearchData _$HotSearchDataFromJson(Map<String, dynamic> json) {
  return HotSearchData(
    queries: (json['queries'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$HotSearchDataToJson(HotSearchData instance) =>
    <String, dynamic>{
      'queries': instance.queries,
    };
