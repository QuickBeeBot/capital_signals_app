import 'package:json_annotation/json_annotation.dart';
import '_parsers.dart';

part 'news_aggr.g.dart';

@JsonSerializable(explicitToJson: true)
class NewsAggr {
  @JsonKey(defaultValue: '', name: 'id')
  String id;
  @JsonKey(defaultValue: '', name: 'name')
  String name;
  @JsonKey(defaultValue: [], name: 'data')
  List<News> data;

  NewsAggr()
      : id = '',
        name = '',
        data = [];

  factory NewsAggr.fromJson(Map<String, dynamic> json) => _$NewsAggrFromJson(json);
  Map<String, dynamic> toJson() => _$NewsAggrToJson(this)..remove('id');
}

@JsonSerializable(explicitToJson: true)
class News {
  @JsonKey(defaultValue: '', name: 'image')
  String image;
  @JsonKey(defaultValue: '', name: 'site')
  String site;
  @JsonKey(defaultValue: '', name: 'symbol')
  String symbol;
  @JsonKey(defaultValue: '', name: 'text')
  String text;
  @JsonKey(defaultValue: '', name: 'url')
  String url;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime, name: 'publishedDate')
  DateTime? publishedDate;

  News()
      : image = '',
        site = '',
        symbol = '',
        text = '',
        url = '',
        publishedDate = null;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
  Map<String, dynamic> toJson() => _$NewsToJson(this)
    ..remove('id')
    ..remove('timestampCreated');

  DateTime getPublishedDate() {
    return publishedDate ?? DateTime.now();
  }
}
