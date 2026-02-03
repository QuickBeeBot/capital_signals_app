import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import '../models/signal_aggr_open.dart';
import '../models/ws_symbol.dart';

import '../models/app_controls_public.dart';
import '../models_services/firestore_service.dart';
import 'auth_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppControlsProvider with ChangeNotifier {
  /* -------------------------------- NOTE Init ------------------------------- */
  String? authUserId;
  String? apiWebSocketUrl;
  bool? apihasAccess;

  AuthProvider? _authProvider;
  AuthProvider? get authProvider => _authProvider;
  set authProvider(AuthProvider? authProvider) {
    _authProvider = authProvider;
    bool rerun = authUserId == null || authUserId != _authProvider?.authUser?.id;

    if (_authProvider?.authUser != null && rerun) {
      streamAppControls();
      notifyListeners();

      authUserId = _authProvider?.authUser?.id ?? '';
    }

    if (_authProvider?.authUser == null) {
      cancelSocketIo();
      cancleStreamAppControls();
      notifyListeners();

      authUserId = null;
    }
  }

  /* ---------------------------- NOTE APP CONTROLS --------------------------- */
  AppControlsPublic _appControls = AppControlsPublic();
  AppControlsPublic get appControls => _appControls;
  StreamSubscription<AppControlsPublic>? _streamSubscriptionAppControls;

  void streamAppControls() {
    var res = FirestoreService.streamAppControlsPublic();
    _streamSubscriptionAppControls = res.listen((event) {
      _appControls = event;

      apiWebSocketUrl = _appControls.apiWebSocketUrl;
      apihasAccess = _appControls.apiHasAccess;

      startSocketIo();

      notifyListeners();
    });
  }

  void cancleStreamAppControls() {
    _streamSubscriptionAppControls?.cancel();
  }

  /* -------------------------------- NOTE Symbols ws ------------------------------- */
  List<WSSymbol> wsSymbols = [];
  IO.Socket? socket;

  void startSocketIo() async {
    User? fbUser = FirebaseAuth.instance.currentUser;
    String? jsonWebToken = await fbUser?.getIdToken(true) ?? '';

    if (apiWebSocketUrl == null || apiWebSocketUrl == '' || apihasAccess == null || apihasAccess == false) {
      socket?.close();
      socket?.disconnect();
      return;
    }

    socket?.close();
    socket?.disconnect();

    socket = IO.io(apiWebSocketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'path': '/socketio/socket.io',
      'autoConnect': false,
      'forceNew': true,
      'extraHeaders': {'jsonWebToken': jsonWebToken, 'userId': fbUser?.uid}
    });

    socket?.connect();

    socket?.on('connect', (_) => print('websocket connect'));

    socket?.on('disconnect', (_) => print('websocket disconnect'));

    socket?.on('connect_error', (data) => print('websocket error ${data}'));

    socket?.on('prices_all', (message) {
      var data = message['data'];
      print('websocket prices_crypto ${data.length}');
      List<WSSymbol> _wsSymbols = [];

      for (var item in data) {
        _wsSymbols.add(WSSymbol.fromJson(item));
      }

      if (_wsSymbols.length > 0) {
        wsSymbols = _wsSymbols;
        notifyListeners();
      }
    });
  }

  void cancleAllStreams() {
    cancelSocketIo();
    notifyListeners();
    authUserId = null;
  }

  void cancelSocketIo() {
    socket?.close();
    socket?.disconnect();
    socket = null;
  }

  num getWSSymbolPrice(Signal signal) {
    var symbols = wsSymbols.map((e) => e.symbol).toList();
    if (symbols.contains(signal.symbol)) {
      return wsSymbols[symbols.indexOf(signal.symbol)].price;
    }
    return signal.entryPrice;
  }
}
