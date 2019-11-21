// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(code: json['code'] as int, msg: json['msg'] as String);
}

Map<String, dynamic> _$ResultToJson(Result instance) =>
    <String, dynamic>{'msg': instance.msg, 'code': instance.code};
