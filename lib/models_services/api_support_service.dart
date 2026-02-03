import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/support.dart';

class ApiService {
  static Dio _dio = Dio();

  static Future<bool> sendSupportEmail({required Support support, required String apiBaseUrl}) async {
    try {
      Response response = await _dio.post(
        apiBaseUrl + '/api/contact',
        data: {...support.toJson()},
        options: Options(receiveTimeout: Duration(seconds: 5), contentType: 'application/json'),
      );
      print(response.data);
      return true;
    } on DioException catch (e) {
      log('response ${e}');
      log('response ${e.response?.data['message']}');
      return false;
    }
  }
}
