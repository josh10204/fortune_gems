// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_game_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotGameRes _$SlotGameResFromJson(Map<String, dynamic> json) => SlotGameRes(
      issue: json['issue'] as String?,
      gameInfo: json['gameInfo'] as String?,
      totalWinAmount: (json['totalWinAmount'] as num?)?.toInt(),
      uuid: json['uuid'] as String?,
      exStatus: (json['exStatus'] as num?)?.toInt(),
      betAmount: (json['betAmount'] as num?)?.toInt(),
      bonusCount: (json['bonusCount'] as num?)?.toInt(),
      cashBalance: (json['cashBalance'] as num?)?.toInt(),
      viewOrderId: json['viewOrderId'] as String?,
      status: (json['status'] as num?)?.toInt(),
      detail: (json['detail'] as List<dynamic>?)
          ?.map((e) => SlotGameDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlotGameResToJson(SlotGameRes instance) =>
    <String, dynamic>{
      'issue': instance.issue,
      'gameInfo': instance.gameInfo,
      'totalWinAmount': instance.totalWinAmount,
      'uuid': instance.uuid,
      'exStatus': instance.exStatus,
      'betAmount': instance.betAmount,
      'bonusCount': instance.bonusCount,
      'cashBalance': instance.cashBalance,
      'viewOrderId': instance.viewOrderId,
      'status': instance.status,
      'detail': instance.detail,
    };

SlotGameDetail _$SlotGameDetailFromJson(Map<String, dynamic> json) =>
    SlotGameDetail(
      panel:
          (json['panel'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ratio: (json['ratio'] as num?)?.toInt(),
      luckyRatio: (json['luckyRatio'] as num?)?.toInt(),
      exLuckyRatio: (json['exLuckyRatio'] as num?)?.toInt(),
      luckyPlayResult: (json['luckyPlayResult'] as num?)?.toInt(),
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => SlotGameResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlotGameDetailToJson(SlotGameDetail instance) =>
    <String, dynamic>{
      'panel': instance.panel,
      'ratio': instance.ratio,
      'luckyRatio': instance.luckyRatio,
      'exLuckyRatio': instance.exLuckyRatio,
      'luckyPlayResult': instance.luckyPlayResult,
      'result': instance.result,
    };

SlotGameResult _$SlotGameResultFromJson(Map<String, dynamic> json) =>
    SlotGameResult(
      item: json['item'] as String?,
      playResult: (json['playResult'] as num?)?.toInt(),
      line: (json['line'] as num?)?.toInt(),
      linkCount: (json['linkCount'] as num?)?.toInt(),
      isDirect: json['isDirect'] as bool?,
      odd: (json['odd'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SlotGameResultToJson(SlotGameResult instance) =>
    <String, dynamic>{
      'item': instance.item,
      'playResult': instance.playResult,
      'line': instance.line,
      'linkCount': instance.linkCount,
      'isDirect': instance.isDirect,
      'odd': instance.odd,
    };
