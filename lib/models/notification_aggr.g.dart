// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_aggr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationAggr _$NotificationAggrFromJson(Map<String, dynamic> json) =>
    NotificationAggr()
      ..id = json['id'] as String? ?? ''
      ..data = (json['data'] as List<dynamic>?)
              ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

Map<String, dynamic> _$NotificationAggrToJson(NotificationAggr instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification()
  ..id = json['id'] as String? ?? ''
  ..image = json['image'] as String? ?? ''
  ..title = json['title'] as String? ?? ''
  ..link = json['link'] as String? ?? ''
  ..body = json['body'] as String? ?? ''
  ..timestampCreated = parseToDateTime(json['timestampCreated']);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'link': instance.link,
      'body': instance.body,
      'timestampCreated': parseToDateTime(instance.timestampCreated),
    };
