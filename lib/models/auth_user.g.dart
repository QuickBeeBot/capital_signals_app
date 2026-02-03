// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser()
  ..id = json['id'] as String?
  ..email = json['email'] as String? ?? ''
  ..referalCode = json['referalCode'] as String? ?? ''
  ..favoriteSignals = (json['favoriteSignals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      []
  ..isNotificationsEnabled = json['isNotificationsEnabled'] as bool? ?? true
  ..isAnonymous = json['isAnonymous'] as bool? ?? true
  ..timestampLastLogin = parseToDateTime(json['timestampLastLogin'])
  ..timestampCreated = parseToDateTime(json['timestampCreated'])
  ..subIsActive = json['subIsActive'] as bool? ?? false
  ..subWillRenew = json['subWillRenew'] as bool? ?? false
  ..subPeriodType = json['subPeriodType'] as String? ?? ''
  ..subProductIdentifier = json['subProductIdentifier'] as String? ?? ''
  ..subIsSandbox = json['subIsSandbox'] as bool? ?? false
  ..subOriginalPurchaseDate = parseToDateTime(json['subOriginalPurchaseDate'])
  ..subLatestPurchaseDate = parseToDateTime(json['subLatestPurchaseDate'])
  ..subExpirationDate = parseToDateTime(json['subExpirationDate'])
  ..subUnsubscribeDetectedAt = parseToDateTime(json['subUnsubscribeDetectedAt'])
  ..subBillingIssueDetectedAt =
      parseToDateTime(json['subBillingIssueDetectedAt'])
  ..subIsLifetime = json['subIsLifetime'] as bool? ?? false;

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'referalCode': instance.referalCode,
      'favoriteSignals': instance.favoriteSignals,
      'isNotificationsEnabled': instance.isNotificationsEnabled,
      'isAnonymous': instance.isAnonymous,
      'timestampLastLogin': parseToDateTime(instance.timestampLastLogin),
      'timestampCreated': parseToDateTime(instance.timestampCreated),
      'subIsActive': instance.subIsActive,
      'subWillRenew': instance.subWillRenew,
      'subPeriodType': instance.subPeriodType,
      'subProductIdentifier': instance.subProductIdentifier,
      'subIsSandbox': instance.subIsSandbox,
      'subOriginalPurchaseDate':
          parseToDateTime(instance.subOriginalPurchaseDate),
      'subLatestPurchaseDate': parseToDateTime(instance.subLatestPurchaseDate),
      'subExpirationDate': parseToDateTime(instance.subExpirationDate),
      'subUnsubscribeDetectedAt':
          parseToDateTime(instance.subUnsubscribeDetectedAt),
      'subBillingIssueDetectedAt':
          parseToDateTime(instance.subBillingIssueDetectedAt),
      'subIsLifetime': instance.subIsLifetime,
    };
