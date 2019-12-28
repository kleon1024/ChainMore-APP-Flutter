import 'package:json_annotation/json_annotation.dart';

part 'domain_search.g.dart';

@JsonSerializable()
class DomainSearchData {
  String state;

  DomainSearchData({
    this.state
  });

  factory DomainSearchData.fromJson(Map<String, dynamic> json) => _$DomainSearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$DomainSearchDataToJson(this);
}
