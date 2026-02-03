// import 'dart:developer';

// import 'package:dio/dio.dart';

// import '../models/signal_aggr.dart';
// import '_api_baseurl.dart';

// class SignalAggrApiService {
//   static Dio _dio = Dio();

//   static Future<List<SignalAggr>> getSignalAggrs() async {
//     try {
//       Response response = await _dio.get(apiBaseUrl + '/api-signal-aggr?nameType=crypto');
//       List data = response.data['signalsAggr'];
//       List<SignalAggr> signalsAggr = data.map((item) => SignalAggr.fromJson(item)).toList();
//       return signalsAggr;
//     } on DioError catch (e) {
//       log('response ${e}');
//       log('response ${e.response?.data['message']}');
//       return [];
//     }
//   }
// }
