import 'package:json_annotation/json_annotation.dart';

import '_parsers.dart';

part 'strategy_aggr.g.dart';

@JsonSerializable(explicitToJson: true)
class StrategyAggr {
  @JsonKey(defaultValue: '', name: 'id')
  String id;
  @JsonKey(defaultValue: [], name: 'data')
  List<Strategy> data;

  StrategyAggr()
      : id = '',
        data = [];

  factory StrategyAggr.fromJson(Map<String, dynamic> json) => _$StrategyAggrFromJson(json);
  Map<String, dynamic> toJson() => _$StrategyAggrToJson(this)..remove('id');
}

@JsonSerializable(explicitToJson: true)
class Strategy {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: '')
  String image;
  @JsonKey(defaultValue: '')
  String title;
  @JsonKey(defaultValue: '')
  String body;
  @JsonKey(defaultValue: false)
  bool isFeatured;
  @JsonKey(defaultValue: false)
  bool isPremium;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? postDate;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? timestampCreated;

  Strategy()
      : id = '',
        image = '',
        title = '',
        body = '',
        isFeatured = false,
        isPremium = false,
        postDate = null,
        timestampCreated = null;

  factory Strategy.fromJson(Map<String, dynamic> json) => _$StrategyFromJson(json);
  Map<String, dynamic> toJson() => _$StrategyToJson(this)
    ..remove('id')
    ..remove('timestampCreated');
}
