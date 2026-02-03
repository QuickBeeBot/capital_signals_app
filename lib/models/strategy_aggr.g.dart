// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_aggr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategyAggr _$StrategyAggrFromJson(Map<String, dynamic> json) => StrategyAggr()
  ..id = json['id'] as String? ?? ''
  ..data = (json['data'] as List<dynamic>?)
          ?.map((e) => Strategy.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];

Map<String, dynamic> _$StrategyAggrToJson(StrategyAggr instance) => <String, dynamic>{
      'id': instance.id,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

Strategy _$StrategyFromJson(Map<String, dynamic> json) => Strategy()
  ..id = json['id'] as String? ?? ''
  ..image = json['image'] as String? ?? ''
  ..title = json['title'] as String? ?? ''
  ..body = json['body'] as String? ?? ''
  ..isFeatured = json['isFeatured'] as bool? ?? false
  ..isPremium = json['isPremium'] as bool? ?? false
  ..postDate = parseToDateTime(json['postDate'])
  ..timestampCreated = parseToDateTime(json['timestampCreated']);

Map<String, dynamic> _$StrategyToJson(Strategy instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'body': instance.body,
      'isFeatured': instance.isFeatured,
      'isPremium': instance.isPremium,
      'postDate': parseToDateTime(instance.postDate),
      'timestampCreated': parseToDateTime(instance.timestampCreated),
    };
