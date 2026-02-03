// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_controls_public.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppControlsPublic _$AppControlsPublicFromJson(Map<String, dynamic> json) =>
    AppControlsPublic()
      ..id = json['id'] as String? ?? ''
      ..apiWebSocketUrl = json['apiWebSocketUrl'] as String? ?? ''
      ..frontendUrl = json['frontendUrl'] as String? ?? ''
      ..adminUrl = json['adminUrl'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..apiHasAccess = json['apiHasAccess'] as bool? ?? false
      ..linkGooglePlay = json['linkGooglePlay'] as String? ?? ''
      ..linkAppStore = json['linkAppStore'] as String? ?? ''
      ..linkFacebook = json['linkFacebook'] as String? ?? ''
      ..linkInstagram = json['linkInstagram'] as String? ?? ''
      ..linkTwitter = json['linkTwitter'] as String? ?? ''
      ..linkYoutube = json['linkYoutube'] as String? ?? ''
      ..linkTelegram = json['linkTelegram'] as String? ?? ''
      ..linkWhatsapp = json['linkWhatsapp'] as String? ?? ''
      ..linkSupport = json['linkSupport'] as String? ?? ''
      ..linkTerms = json['linkTerms'] as String? ?? ''
      ..linkPivacy = json['linkPivacy'] as String? ?? ''
      ..showSignalAggrPerformance7Days =
          json['showSignalAggrPerformance7Days'] as bool? ?? true
      ..showSignalAggrPerformance14Days =
          json['showSignalAggrPerformance14Days'] as bool? ?? true
      ..showSignalAggrPerformance30Days =
          json['showSignalAggrPerformance30Days'] as bool? ?? true
      ..showSignalAggrPerformance =
          json['showSignalAggrPerformance'] as bool? ?? true;

Map<String, dynamic> _$AppControlsPublicToJson(AppControlsPublic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'apiWebSocketUrl': instance.apiWebSocketUrl,
      'frontendUrl': instance.frontendUrl,
      'adminUrl': instance.adminUrl,
      'name': instance.name,
      'apiHasAccess': instance.apiHasAccess,
      'linkGooglePlay': instance.linkGooglePlay,
      'linkAppStore': instance.linkAppStore,
      'linkFacebook': instance.linkFacebook,
      'linkInstagram': instance.linkInstagram,
      'linkTwitter': instance.linkTwitter,
      'linkYoutube': instance.linkYoutube,
      'linkTelegram': instance.linkTelegram,
      'linkWhatsapp': instance.linkWhatsapp,
      'linkSupport': instance.linkSupport,
      'linkTerms': instance.linkTerms,
      'linkPivacy': instance.linkPivacy,
      'showSignalAggrPerformance7Days': instance.showSignalAggrPerformance7Days,
      'showSignalAggrPerformance14Days':
          instance.showSignalAggrPerformance14Days,
      'showSignalAggrPerformance30Days':
          instance.showSignalAggrPerformance30Days,
      'showSignalAggrPerformance': instance.showSignalAggrPerformance,
    };
