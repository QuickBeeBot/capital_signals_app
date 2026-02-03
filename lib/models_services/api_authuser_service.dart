import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiAuthUserService {
  static Dio _dio = Dio();

  static Future<bool?> deleteAccount({required String apiBaseUrl}) async {
    try {
      User? fbUser = FirebaseAuth.instance.currentUser;
      String? jsonWebToken = await fbUser?.getIdToken();
      if (jsonWebToken == null) return null;

      if (apiBaseUrl == '') throw Exception('Api Url is not set');
      if (apiBaseUrl.endsWith('/dashboard')) apiBaseUrl = apiBaseUrl.substring(0, apiBaseUrl.length - 1);
      if (apiBaseUrl.endsWith('/')) apiBaseUrl = apiBaseUrl.substring(0, apiBaseUrl.length - 1);

      await _dio.patch(
        apiBaseUrl + '/api/user-delete-account',
        data: {'jsonWebToken': jsonWebToken},
        options: Options(receiveTimeout: Duration(seconds: 5), contentType: 'application/json'),
      );

      FirebaseAuth.instance.signOut();

      return true;
    } on DioException catch (e) {
      log('response ${e}');
      log('response ${e.response?.data['message']}');
      return false;
    }
  }

  static Future<bool?> deleteAccountGoogleAppleSignin({required String apiBaseUrl, String? jsonWebToken}) async {
    print('deleteAccountGoogleAppleSignin($apiBaseUrl');
    try {
      if (jsonWebToken == null) return null;

      if (apiBaseUrl == '') throw Exception('Api Url is not set');
      if (apiBaseUrl.endsWith('/dashboard')) apiBaseUrl = apiBaseUrl.substring(0, apiBaseUrl.length - 1);
      if (apiBaseUrl.endsWith('/')) apiBaseUrl = apiBaseUrl.substring(0, apiBaseUrl.length - 1);

      print('deleteAccountGoogleAppleSignin($apiBaseUrl/api/user-delete-account/');

      await _dio.patch(
        apiBaseUrl + '/api/user-delete-account?jsonWebToken=$jsonWebToken',
        data: {'jsonWebToken': jsonWebToken},
        options: Options(receiveTimeout: Duration(seconds: 5), contentType: 'application/json'),
      );

      return true;
    } on DioException catch (e) {
      log('response1 ${e}');
      log('response2 ${e.response}');
      log('response3 ${e.response?.data['message']}');
      return false;
    }
  }
}
