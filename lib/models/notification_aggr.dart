import 'package:json_annotation/json_annotation.dart';

import '_parsers.dart';

part 'notification_aggr.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationAggr {
  @JsonKey(defaultValue: '', name: 'id')
  String id;
  @JsonKey(defaultValue: [], name: 'data')
  List<Notification> data;

  NotificationAggr()
      : id = '',
        data = [];

  factory NotificationAggr.fromJson(Map<String, dynamic> json) => _$NotificationAggrFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationAggrToJson(this)..remove('id');
}

@JsonSerializable(explicitToJson: true)
class Notification {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: '')
  String image;
  @JsonKey(defaultValue: '')
  String title;
  @JsonKey(defaultValue: '')
  String link;
  @JsonKey(defaultValue: '')
  String body;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? timestampCreated;

  Notification()
      : id = '',
        image = '',
        title = '',
        link = '',
        body = '',
        timestampCreated = null;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this)
    ..remove('id')
    ..remove('timestampCreated');
}
