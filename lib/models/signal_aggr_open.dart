



import 'package:json_annotation/json_annotation.dart';
import '_parsers.dart';

part 'signal_aggr_open.g.dart';

@JsonSerializable(explicitToJson: true)
class SignalAggrOpen {
  @JsonKey(defaultValue: '', name: 'id')
  String id;
  @JsonKey(defaultValue: '', name: 'name')
  String name;
  @JsonKey(defaultValue: 0, name: 'sort')
  num sort;
  @JsonKey(defaultValue: [], name: 'data')
  List<Signal> signals;
  @JsonKey(name: 'performance7Days', defaultValue: null)
  SignalAggrPerformance? performance7Days;
  @JsonKey(name: 'performance14Days', defaultValue: null)
  SignalAggrPerformance? performance14Days;
  @JsonKey(name: 'performance30Days', defaultValue: null)
  SignalAggrPerformance? performance30Days;

  SignalAggrOpen()
      : id = '',
        name = '',
        sort = 0,
        signals = [],
        performance7Days = SignalAggrPerformance(),
        performance14Days = SignalAggrPerformance(),
        performance30Days = SignalAggrPerformance();

  factory SignalAggrOpen.fromJson(Map<String, dynamic> json) => _$SignalAggrOpenFromJson(json);
  Map<String, dynamic> toJson() => _$SignalAggrOpenToJson(this)..remove('id');
}

@JsonSerializable(explicitToJson: true)
class Signal {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: false, name: 'isAuto')
  bool isAuto;
  @JsonKey(defaultValue: '', name: 'symbol')
  String symbol;
  @JsonKey(defaultValue: 0, name: 'entryPrice')
  num entryPrice;
  @JsonKey(defaultValue: '', name: 'entryType')
  String entryType;
  @JsonKey(defaultValue: false, name: 'isFree')
  bool isFree;
  @JsonKey(defaultValue: '', name: 'analysisImage')
  String analysisImage;
  @JsonKey(defaultValue: '', name: 'analysisText')
  String analysisText;
  @JsonKey(defaultValue: '', name: 'market')
  String market;
  @JsonKey(defaultValue: '', name: 'comment')
  String comment;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime, name: 'entryDateTime')
  DateTime? entryDateTime;
  //
  @JsonKey(defaultValue: 0, name: 'stopLoss')
  num stopLoss;
  @JsonKey(defaultValue: 0, name: 'stopLossPct')
  num stopLossPct;
  @JsonKey(defaultValue: 0, name: 'stopLossPips')
  num stopLossPips;
  @JsonKey(defaultValue: '', name: 'stopLossResult')
  String stopLossResult;
  @JsonKey(defaultValue: '', name: 'stopLossComment')
  String stopLossComment;
  @JsonKey(defaultValue: false, name: 'stopLossHit')
  bool stopLossHit;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime, name: 'stopLossDateTime')
  DateTime? stopLossDateTime;
  //
  @JsonKey(defaultValue: 0, name: 'takeProfit1')
  num takeProfit1;
  @JsonKey(defaultValue: 0, name: 'takeProfit1Pct')
  num takeProfit1Pct;
  @JsonKey(defaultValue: 0, name: 'takeProfit1Pips')
  num takeProfit1Pips;
  @JsonKey(defaultValue: '', name: 'takeProfit1Result')
  String takeProfit1Result;
  @JsonKey(defaultValue: '', name: 'takeProfit1Comment')
  String takeProfit1Comment;
  @JsonKey(defaultValue: false, name: 'takeProfit1Hit')
  bool takeProfit1Hit;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime, name: 'takeProfit1DateTime')
  DateTime? takeProfit1DateTime;
  //
  @JsonKey(defaultValue: 0, name: 'takeProfit2')
  num takeProfit2;
  @JsonKey(defaultValue: 0, name: 'takeProfit2Pct')
  num takeProfit2Pct;
  @JsonKey(defaultValue: 0, name: 'takeProfit2Pips')
  num takeProfit2Pips;
  @JsonKey(defaultValue: '', name: 'takeProfit2Result')
  String takeProfit2Result;
  @JsonKey(defaultValue: '', name: 'takeProfit2Comment')
  String takeProfit2Comment;
  @JsonKey(defaultValue: false, name: 'takeProfit2Hit')
  bool takeProfit2Hit;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime, name: 'takeProfit2DateTime')
  DateTime? takeProfit2DateTime;
  //
  @JsonKey(defaultValue: 0, name: 'takeProfit3')
  num takeProfit3;
  @JsonKey(defaultValue: 0, name: 'takeProfit3Pct')
  num takeProfit3Pct;
  @JsonKey(defaultValue: 0, name: 'takeProfit3Pips')
  num takeProfit3Pips;
  @JsonKey(defaultValue: '', name: 'takeProfit3Result')
  String takeProfit3Result;
  @JsonKey(defaultValue: '', name: 'takeProfit3Comment')
  String takeProfit3Comment;
  @JsonKey(defaultValue: false, name: 'takeProfit3Hit')
  bool takeProfit3Hit;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime, name: 'takeProfit3DateTime')
  DateTime? takeProfit3DateTime;
  //
  @JsonKey(defaultValue: false, name: 'isClosed')
  bool isClosed;
  @JsonKey(defaultValue: false, name: 'isClosedManual')
  bool isClosedManual;
  @JsonKey(defaultValue: false, name: 'isClosedAuto')
  bool isClosedAuto;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime, name: 'timestampClosed')
  DateTime? timestampClosed;
  //
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? timestampCreated;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? timestampUpdated;

  Signal()
      : id = '',
        symbol = '',
        isAuto = false,
        entryPrice = 0,
        entryType = '',
        isFree = false,
        analysisImage = '',
        analysisText = '',
        market = '',
        comment = '',
        entryDateTime = null,
        stopLoss = 0,
        stopLossPct = 0,
        stopLossPips = 0,
        stopLossResult = '',
        stopLossComment = '',
        stopLossHit = false,
        stopLossDateTime = null,
        takeProfit1 = 0,
        takeProfit1Pct = 0,
        takeProfit1Pips = 0,
        takeProfit1Result = '',
        takeProfit1Comment = '',
        takeProfit1Hit = false,
        takeProfit1DateTime = null,
        takeProfit2 = 0,
        takeProfit2Pct = 0,
        takeProfit2Pips = 0,
        takeProfit2Result = '',
        takeProfit2Comment = '',
        takeProfit2Hit = false,
        takeProfit2DateTime = null,
        takeProfit3 = 0,
        takeProfit3Pct = 0,
        takeProfit3Pips = 0,
        takeProfit3Result = '',
        takeProfit3Comment = '',
        takeProfit3Hit = false,
        takeProfit3DateTime = null,
        isClosed = false,
        isClosedManual = false,
        isClosedAuto = false,
        timestampClosed = null,
        timestampCreated = null,
        timestampUpdated = null;

  factory Signal.fromJson(Map<String, dynamic> json) => _$SignalFromJson(json);
  Map<String, dynamic> toJson() => _$SignalToJson(this)
    ..remove('id')
    ..remove('timestampCreated');

  gerHasAnalysis() {
    if (analysisImage != '' || analysisText != '') return true;
    return false;
  }

  getSignalClosedDateTime() {
    if (timestampClosed != null) return timestampClosed;
    return null;
  }

  compareEntryPriceWithCurrentPrice({required num price, isPips = false}) {
    if (price == 0) return 0;

    if (isPips) {
      num val = 0;
      if (entryType == 'Long') val = (price - entryPrice) * 10000;
      if (entryType == 'Short') val = (entryPrice - price) * 10000;

      if (symbol.contains('JPY')) val = val / 100;

      return (val / 1).round() * 1;
    }

    if (isPips == false) {
      if (entryType == 'Long') return (price - entryPrice) / entryPrice;
      if (entryType == 'Short') return (entryPrice - price) / price;
    }

    return 0;
  }
}

@JsonSerializable(explicitToJson: true)
class SignalAggrPerformance {
  @JsonKey(defaultValue: 0)
  num trades;
  @JsonKey(defaultValue: 0)
  num profitPercentPerTrade;
  @JsonKey(defaultValue: 0)
  num winRate;

  SignalAggrPerformance()
      : trades = 0,
        profitPercentPerTrade = 0,
        winRate = 0;

  factory SignalAggrPerformance.fromJson(Map<String, dynamic> json) => _$SignalAggrPerformanceFromJson(json);
  Map<String, dynamic> toJson() => _$SignalAggrPerformanceToJson(this)
    ..remove('id')
    ..remove('timestampCreated');
}
