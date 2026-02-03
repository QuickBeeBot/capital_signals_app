import 'package:json_annotation/json_annotation.dart';

import '_parsers.dart';

part 'post_aggr.g.dart';

@JsonSerializable(explicitToJson: true)
class PostAggr {
  @JsonKey(defaultValue: '', name: 'id')
  String id;
  @JsonKey(defaultValue: [], name: 'data')
  List<Post> data;

  PostAggr()
      : id = '',
        data = [];

  factory PostAggr.fromJson(Map<String, dynamic> json) => _$PostAggrFromJson(json);
  Map<String, dynamic> toJson() => _$PostAggrToJson(this)..remove('id');
}

@JsonSerializable(explicitToJson: true)
class Post {
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

  Post()
      : id = '',
        image = '',
        title = '',
        body = '',
        isFeatured = false,
        isPremium = false,
        postDate = null,
        timestampCreated = null;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this)
    ..remove('id')
    ..remove('timestampCreated');
}
