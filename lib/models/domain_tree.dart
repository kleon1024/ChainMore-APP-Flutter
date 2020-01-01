import 'package:chainmore/models/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'domain_tree.g.dart';

@JsonSerializable()
class DomainTree {
  Domain     domain;
  List<DomainTree> subdomains;
  bool expanded;


  DomainTree({
    this.domain,
    this.subdomains,
    this.expanded,
  });

  factory DomainTree.fromJson(Map<String, dynamic> json) => _$DomainTreeFromJson(json);

  Map<String, dynamic> toJson() => _$DomainTreeToJson(this);
}
