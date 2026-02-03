import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../models/_parsers.dart';
import '../constants/app_constants.dart';

class RevenueCatSevice {
  static String _androidKey = AppConstants.REVENUECAT_ANDROID_KEY;
  static String _iosKey = AppConstants.REVENUECAT_IOS_KEY;
  static String _apiKey = Platform.isIOS ? _iosKey : _androidKey;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future init() async {
    try {
      // await Purchases.setLogLevel(LogLevel.debug);
      PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
      await Purchases.configure(configuration);
    } catch (e) {
      print('error in RevenueCatSevice init: $e');
    }
  }

  static Future<List<Offering>> getOfferings() async {
    try {
      final offering = await Purchases.getOfferings();
      final current = offering.current;
      return current == null ? [] : [current];
    } catch (e) {
      print('getOfferings error: $e');
      return [];
    }
  }

  static Future<List<Package>> getPackages() async {
    try {
      List<Offering> offerings = await RevenueCatSevice.getOfferings();
      final _packages = offerings.map((e) => e.availablePackages).expand((element) => element).toList();
      return _packages;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      print('Error package ${e}');
      return false;
    }
  }

  static Future updateUserSub(EntitlementInfo entitlementInfo) async {
    try {
      User? fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser == null) return;

      await _firestore.collection('users').doc(fbUser.uid).update({
        'subBillingIssueDetectedAt': parseToDateTime(entitlementInfo.billingIssueDetectedAt),
        'subExpirationDate': parseToDateTime(entitlementInfo.expirationDate),
        'subIsActive': entitlementInfo.isActive,
        'subIsSandbox': entitlementInfo.isSandbox,
        'subLatestPurchaseDate': parseToDateTime(entitlementInfo.latestPurchaseDate),
        'subOriginalPurchaseDate': parseToDateTime(entitlementInfo.originalPurchaseDate),
        'subPeriodType': entitlementInfo.periodType.toString(),
        'subProductIdentifier': entitlementInfo.productIdentifier,
        'subUnsubscribeDetectedAt': parseToDateTime(entitlementInfo.unsubscribeDetectedAt),
        'subWillRenew': entitlementInfo.willRenew,
      });

      return true;
    } catch (e) {
      print('Error package ${e}');
      return false;
    }
  }
}
