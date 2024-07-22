// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseRes _$BaseResFromJson(Map<String, dynamic> json) => BaseRes(
      resultCode: json['resultCode'] as String,
      msg: json['msg'] as String?,
      resultMap: json['resultMap'],
    );

Map<String, dynamic> _$BaseResToJson(BaseRes instance) => <String, dynamic>{
      'resultCode': instance.resultCode,
      'msg': instance.msg,
      'resultMap': instance.resultMap,
    };
