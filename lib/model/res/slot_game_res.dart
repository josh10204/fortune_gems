import 'package:json_annotation/json_annotation.dart';

part 'slot_game_res.g.dart';


@JsonSerializable()
class SlotGameRes {

  SlotGameRes(
      {
        this.issue,
        this.gameInfo,
        this.totalWinAmount,
        this.uuid,
        this.exStatus,
        this.betAmount,
        this.bonusCount,
        this.cashBalance,
        this.viewOrderId,
        this.status,
        this.detail});

  @JsonKey(name: 'issue')
  final String? issue;

  @JsonKey(name: 'gameInfo')
  final String? gameInfo;

  @JsonKey(name: 'totalWinAmount')
  final int? totalWinAmount;

  @JsonKey(name: 'uuid')
  final String? uuid;

  @JsonKey(name: 'exStatus')
  final int? exStatus;

  @JsonKey(name: 'betAmount')
  final int? betAmount;

  @JsonKey(name: 'bonusCount')
  final int? bonusCount;

  @JsonKey(name: 'cashBalance')
  final int? cashBalance;

  @JsonKey(name: 'viewOrderId')
  final String? viewOrderId;

  @JsonKey(name: 'status')
  final int? status;



  @JsonKey(name: 'detail')
  final List<SlotGameDetail>? detail;

  factory SlotGameRes.fromJson(Map<String, dynamic> json) => _$SlotGameResFromJson(json);
  Map<String, dynamic> toJson() => _$SlotGameResToJson(this);

}

@JsonSerializable()
class SlotGameDetail {
  SlotGameDetail(
      {this.panel,
        this.ratio,
        this.luckyRatio,
        this.exLuckyRatio,
        this.luckyPlayResult,
        this.result});

  @JsonKey(name: 'panel')
  final List<String>? panel;

  @JsonKey(name: 'ratio')
  final int? ratio;

  @JsonKey(name: 'luckyRatio')
  final int? luckyRatio;

  @JsonKey(name: 'exLuckyRatio')
  final int? exLuckyRatio;

  @JsonKey(name: 'luckyPlayResult')
  final int? luckyPlayResult;

  @JsonKey(name: 'result')
  final List<SlotGameResult>? result;

  factory SlotGameDetail.fromJson(Map<String, dynamic> json) => _$SlotGameDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SlotGameDetailToJson(this);
}

@JsonSerializable()
class SlotGameResult {

  SlotGameResult(
      {this.item,
        this.playResult,
        this.line,
        this.linkCount,
        this.isDirect,
        this.odd});

  @JsonKey(name: 'item')
  final String? item;

  @JsonKey(name: 'playResult')
  final int? playResult;

  @JsonKey(name: 'line')
  final int? line;

  @JsonKey(name: 'linkCount')
  final int? linkCount;

  @JsonKey(name: 'isDirect')
  final bool? isDirect;

  @JsonKey(name: 'odd')
  final int? odd;

  factory SlotGameResult.fromJson(Map<String, dynamic> json) => _$SlotGameResultFromJson(json);
  Map<String, dynamic> toJson() => _$SlotGameResultToJson(this);

}