import 'package:json_annotation/json_annotation.dart';

part 'app_controls_public.g.dart';

@JsonSerializable(explicitToJson: true)
class AppControlsPublic {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: '')
  String apiWebSocketUrl;
  @JsonKey(defaultValue: '')
  String frontendUrl;
  @JsonKey(defaultValue: '')
  String adminUrl;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: false)
  bool apiHasAccess;
  @JsonKey(defaultValue: '')
  String linkGooglePlay;
  @JsonKey(defaultValue: '')
  String linkAppStore;
  @JsonKey(defaultValue: '')
  String linkFacebook;
  @JsonKey(defaultValue: '')
  String linkInstagram;
  @JsonKey(defaultValue: '')
  String linkTwitter;
  @JsonKey(defaultValue: '')
  String linkYoutube;
  @JsonKey(defaultValue: '')
  String linkTelegram;
  @JsonKey(defaultValue: '')
  String linkWhatsapp;
  @JsonKey(defaultValue: '')
  String linkSupport;
  @JsonKey(defaultValue: '')
  String linkTerms;
  @JsonKey(defaultValue: '')
  String linkPivacy;

  @JsonKey(defaultValue: true)
  bool showSignalAggrPerformance7Days;
  @JsonKey(defaultValue: true)
  bool showSignalAggrPerformance14Days;
  @JsonKey(defaultValue: true)
  bool showSignalAggrPerformance30Days;
  @JsonKey(defaultValue: true)
  bool showSignalAggrPerformance;

  AppControlsPublic()
      : id = '',
        apiWebSocketUrl = '',
        frontendUrl = '',
        adminUrl = '',
        name = '',
        apiHasAccess = false,
        linkGooglePlay = '',
        linkAppStore = '',
        linkFacebook = '',
        linkInstagram = '',
        linkTwitter = '',
        linkYoutube = '',
        linkTelegram = '',
        linkWhatsapp = '',
        linkSupport = '',
        linkTerms = '',
        linkPivacy = '',
        showSignalAggrPerformance7Days = true,
        showSignalAggrPerformance14Days = true,
        showSignalAggrPerformance30Days = true,
        showSignalAggrPerformance = true;

  factory AppControlsPublic.fromJson(Map<String, dynamic> json) => _$AppControlsPublicFromJson(json);
  Map<String, dynamic> toJson() => _$AppControlsPublicToJson(this)
    ..remove('id')
    ..remove('timestampCreated');
}
