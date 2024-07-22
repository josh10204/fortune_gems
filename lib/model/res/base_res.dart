import 'package:json_annotation/json_annotation.dart';
part 'base_res.g.dart';

@JsonSerializable()
class BaseRes {
  BaseRes({
    required this.resultCode,
    this.msg,
    this.resultMap,
  });

  @JsonKey(name: 'resultCode')
  final String resultCode;

  @JsonKey(name: 'msg')
  final String? msg;

  @JsonKey(name: 'resultMap')
  final dynamic resultMap;

  factory BaseRes.fromJson(Map<String, dynamic> json) => _$BaseResFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResToJson(this);

}