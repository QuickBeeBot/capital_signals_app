import 'package:json_annotation/json_annotation.dart';

import '_parsers.dart';

part 'auth_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthUser {
  String? id;
  @JsonKey(defaultValue: '')
  String email;
  @JsonKey(defaultValue: '')
  String referalCode;
  @JsonKey(defaultValue: [])
  List<String> favoriteSignals;
  @JsonKey(defaultValue: true)
  bool isNotificationsEnabled;
  @JsonKey(defaultValue: true)
  bool isAnonymous;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? timestampLastLogin;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? timestampCreated;

  // subcription
  @JsonKey(defaultValue: false)
  bool subIsActive;
  @JsonKey(defaultValue: false)
  bool subWillRenew;
  @JsonKey(defaultValue: '')
  String subPeriodType;
  @JsonKey(defaultValue: '')
  String subProductIdentifier;
  @JsonKey(defaultValue: false)
  bool subIsSandbox;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? subOriginalPurchaseDate;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? subLatestPurchaseDate;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? subExpirationDate;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? subUnsubscribeDetectedAt;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? subBillingIssueDetectedAt;
  @JsonKey(defaultValue: false)
  bool subIsLifetime;

  AuthUser()
      : isNotificationsEnabled = true,
        email = '',
        favoriteSignals = [],
        referalCode = '',
        subIsActive = false,
        isAnonymous = true,
        subWillRenew = false,
        subIsSandbox = false,
        subPeriodType = '',
        subProductIdentifier = '',
        subIsLifetime = false;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserToJson(this)
    ..remove('id')
    ..remove('timestampLastLogin')
    ..remove('timestampCreated');

  // functions
  bool get hasActiveSubscription => verifySubscription(this);
  bool get hasLifetime => subIsLifetime;
}

bool verifySubscription(AuthUser authUser) {
  if (authUser.subIsLifetime) return true;
  if (authUser.subExpirationDate == null) return false;
  if (timeInUtc(authUser.subExpirationDate!).isAfter(timeInUtc(DateTime.now()))) return true;
  return false;
}

DateTime timeInUtc(DateTime d) {
  return DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second, d.millisecond, d.microsecond);
}
