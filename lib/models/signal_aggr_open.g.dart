// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signal_aggr_open.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignalAggrOpen _$SignalAggrOpenFromJson(Map<String, dynamic> json) =>
    SignalAggrOpen()
      ..id = json['id'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..sort = json['sort'] as num? ?? 0
      ..signals = (json['data'] as List<dynamic>?)
              ?.map((e) => Signal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..performance7Days = json['performance7Days'] == null
          ? null
          : SignalAggrPerformance.fromJson(
              json['performance7Days'] as Map<String, dynamic>)
      ..performance14Days = json['performance14Days'] == null
          ? null
          : SignalAggrPerformance.fromJson(
              json['performance14Days'] as Map<String, dynamic>)
      ..performance30Days = json['performance30Days'] == null
          ? null
          : SignalAggrPerformance.fromJson(
              json['performance30Days'] as Map<String, dynamic>);

Map<String, dynamic> _$SignalAggrOpenToJson(SignalAggrOpen instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sort': instance.sort,
      'data': instance.signals.map((e) => e.toJson()).toList(),
      'performance7Days': instance.performance7Days?.toJson(),
      'performance14Days': instance.performance14Days?.toJson(),
      'performance30Days': instance.performance30Days?.toJson(),
    };

Signal _$SignalFromJson(Map<String, dynamic> json) => Signal()
  ..id = json['id'] as String? ?? ''
  ..isAuto = json['isAuto'] as bool? ?? false
  ..symbol = json['symbol'] as String? ?? ''
  ..entryPrice = json['entryPrice'] as num? ?? 0
  ..entryType = json['entryType'] as String? ?? ''
  ..isFree = json['isFree'] as bool? ?? false
  ..analysisImage = json['analysisImage'] as String? ?? ''
  ..analysisText = json['analysisText'] as String? ?? ''
  ..market = json['market'] as String? ?? ''
  ..comment = json['comment'] as String? ?? ''
  ..entryDateTime = parseToDateTime(json['entryDateTime'])
  ..stopLoss = json['stopLoss'] as num? ?? 0
  ..stopLossPct = json['stopLossPct'] as num? ?? 0
  ..stopLossPips = json['stopLossPips'] as num? ?? 0
  ..stopLossResult = json['stopLossResult'] as String? ?? ''
  ..stopLossComment = json['stopLossComment'] as String? ?? ''
  ..stopLossHit = json['stopLossHit'] as bool? ?? false
  ..stopLossDateTime = parseToDateTime(json['stopLossDateTime'])
  ..takeProfit1 = json['takeProfit1'] as num? ?? 0
  ..takeProfit1Pct = json['takeProfit1Pct'] as num? ?? 0
  ..takeProfit1Pips = json['takeProfit1Pips'] as num? ?? 0
  ..takeProfit1Result = json['takeProfit1Result'] as String? ?? ''
  ..takeProfit1Comment = json['takeProfit1Comment'] as String? ?? ''
  ..takeProfit1Hit = json['takeProfit1Hit'] as bool? ?? false
  ..takeProfit1DateTime = parseToDateTime(json['takeProfit1DateTime'])
  ..takeProfit2 = json['takeProfit2'] as num? ?? 0
  ..takeProfit2Pct = json['takeProfit2Pct'] as num? ?? 0
  ..takeProfit2Pips = json['takeProfit2Pips'] as num? ?? 0
  ..takeProfit2Result = json['takeProfit2Result'] as String? ?? ''
  ..takeProfit2Comment = json['takeProfit2Comment'] as String? ?? ''
  ..takeProfit2Hit = json['takeProfit2Hit'] as bool? ?? false
  ..takeProfit2DateTime = parseToDateTime(json['takeProfit2DateTime'])
  ..takeProfit3 = json['takeProfit3'] as num? ?? 0
  ..takeProfit3Pct = json['takeProfit3Pct'] as num? ?? 0
  ..takeProfit3Pips = json['takeProfit3Pips'] as num? ?? 0
  ..takeProfit3Result = json['takeProfit3Result'] as String? ?? ''
  ..takeProfit3Comment = json['takeProfit3Comment'] as String? ?? ''
  ..takeProfit3Hit = json['takeProfit3Hit'] as bool? ?? false
  ..takeProfit3DateTime = parseToDateTime(json['takeProfit3DateTime'])
  ..isClosed = json['isClosed'] as bool? ?? false
  ..isClosedManual = json['isClosedManual'] as bool? ?? false
  ..isClosedAuto = json['isClosedAuto'] as bool? ?? false
  ..timestampClosed = parseToDateTime(json['timestampClosed'])
  ..timestampCreated = parseToDateTime(json['timestampCreated'])
  ..timestampUpdated = parseToDateTime(json['timestampUpdated']);

Map<String, dynamic> _$SignalToJson(Signal instance) => <String, dynamic>{
      'id': instance.id,
      'isAuto': instance.isAuto,
      'symbol': instance.symbol,
      'entryPrice': instance.entryPrice,
      'entryType': instance.entryType,
      'isFree': instance.isFree,
      'analysisImage': instance.analysisImage,
      'analysisText': instance.analysisText,
      'market': instance.market,
      'comment': instance.comment,
      'entryDateTime': parseToDateTime(instance.entryDateTime),
      'stopLoss': instance.stopLoss,
      'stopLossPct': instance.stopLossPct,
      'stopLossPips': instance.stopLossPips,
      'stopLossResult': instance.stopLossResult,
      'stopLossComment': instance.stopLossComment,
      'stopLossHit': instance.stopLossHit,
      'stopLossDateTime': parseToDateTime(instance.stopLossDateTime),
      'takeProfit1': instance.takeProfit1,
      'takeProfit1Pct': instance.takeProfit1Pct,
      'takeProfit1Pips': instance.takeProfit1Pips,
      'takeProfit1Result': instance.takeProfit1Result,
      'takeProfit1Comment': instance.takeProfit1Comment,
      'takeProfit1Hit': instance.takeProfit1Hit,
      'takeProfit1DateTime': parseToDateTime(instance.takeProfit1DateTime),
      'takeProfit2': instance.takeProfit2,
      'takeProfit2Pct': instance.takeProfit2Pct,
      'takeProfit2Pips': instance.takeProfit2Pips,
      'takeProfit2Result': instance.takeProfit2Result,
      'takeProfit2Comment': instance.takeProfit2Comment,
      'takeProfit2Hit': instance.takeProfit2Hit,
      'takeProfit2DateTime': parseToDateTime(instance.takeProfit2DateTime),
      'takeProfit3': instance.takeProfit3,
      'takeProfit3Pct': instance.takeProfit3Pct,
      'takeProfit3Pips': instance.takeProfit3Pips,
      'takeProfit3Result': instance.takeProfit3Result,
      'takeProfit3Comment': instance.takeProfit3Comment,
      'takeProfit3Hit': instance.takeProfit3Hit,
      'takeProfit3DateTime': parseToDateTime(instance.takeProfit3DateTime),
      'isClosed': instance.isClosed,
      'isClosedManual': instance.isClosedManual,
      'isClosedAuto': instance.isClosedAuto,
      'timestampClosed': parseToDateTime(instance.timestampClosed),
      'timestampCreated': parseToDateTime(instance.timestampCreated),
      'timestampUpdated': parseToDateTime(instance.timestampUpdated),
    };

SignalAggrPerformance _$SignalAggrPerformanceFromJson(
        Map<String, dynamic> json) =>
    SignalAggrPerformance()
      ..trades = json['trades'] as num? ?? 0
      ..profitPercentPerTrade = json['profitPercentPerTrade'] as num? ?? 0
      ..winRate = json['winRate'] as num? ?? 0;

Map<String, dynamic> _$SignalAggrPerformanceToJson(
        SignalAggrPerformance instance) =>
    <String, dynamic>{
      'trades': instance.trades,
      'profitPercentPerTrade': instance.profitPercentPerTrade,
      'winRate': instance.winRate,
    };
