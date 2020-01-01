// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainTree _$DomainTreeFromJson(Map<String, dynamic> json) {
  return DomainTree(
    domain: json['domain'] == null
        ? null
        : Domain.fromJson(json['domain'] as Map<String, dynamic>),
    subdomains: (json['subdomains'] as List)
        ?.map((e) =>
            e == null ? null : DomainTree.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    expanded: json['expanded'] as bool,
  );
}

Map<String, dynamic> _$DomainTreeToJson(DomainTree instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'subdomains': instance.subdomains,
      'expanded': instance.expanded,
    };
