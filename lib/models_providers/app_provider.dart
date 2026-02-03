import 'dart:async';

import 'package:flutter/material.dart' hide Notification;
import '../models/announcement_aggr.dart';
import '../models/auth_user.dart';
import '../models/notification_aggr.dart';
import '../models/post_aggr.dart';
import '../models/signal_aggr_open.dart';
import '../models/video_lesson_aggr.dart';
import '../models_services/firestore_service.dart';

import '../models/news_aggr.dart';
import 'auth_provider.dart';

class AppProvider with ChangeNotifier {
  /* -------------------------------- NOTE Init ------------------------------- */
  String? authUserId;
  AuthUser? authUser;

  AuthProvider? _authProvider;
  AuthProvider? get authProvider => _authProvider;
  set authProvider(AuthProvider? authProvider) {
    _authProvider = authProvider;
    bool rerun = authUserId == null || authUserId == '' || authUserId != _authProvider?.authUser?.id;

    if (_authProvider?.authUser != null && rerun) {
      streamAggrNews();
      streamPostsAggr();
      streamVideoLessonAggr();
      streamAnnoucementsAggr();
      streamSignalsAggrOpen();
      streamNotificationsAggr();

      notifyListeners();
      authUserId = _authProvider?.authUser?.id ?? '';
      authUser = _authProvider?.authUser;
    }

    if (_authProvider?.authUser == null) {
      cancleStreamAggrNews();
      cancleStreamPost();
      cancleStreamVideoLessons();
      cancleStreamAnnoucements();
      cancleStreamSignalsAggrOpen();
      cancleStreamNotifications();

      notifyListeners();
      authUserId = null;
      authUser = null;
    }

    authUser = _authProvider?.authUser;
    print(authUser?.favoriteSignals);
    notifyListeners();
  }

  /* -------------------------------- NOTE Cancle Streams ------------------------------- */
  void cancleAllStreams() {
    cancleStreamAggrNews();
    cancleStreamPost();
    cancleStreamVideoLessons();
    cancleStreamAnnoucements();
    notifyListeners();
    authUserId = null;
    authUser = null;
  }

  /* -------------------------------- NOTE NEWS ------------------------------- */
  List<NewsAggr> _newsAggr = [];
  List<NewsAggr> get newsAggr => _newsAggr;
  StreamSubscription<List<NewsAggr>>? _streamSubscriptionNewsAggr;

  List<News> _newsAll = [];
  List<News> get newsAll => _newsAll;

  List<News> _newsCrypto = [];
  List<News> get newsCrypto => _newsCrypto;

  List<News> _newsForex = [];
  List<News> get newsForex => _newsForex;

  List<News> _newsStocks = [];
  List<News> get newsStocks => _newsStocks;

  void streamAggrNews() {
    var res = FirestoreService.streamNewsAggr();
    _streamSubscriptionNewsAggr = res.listen((event) {
      _newsAggr = event;

      _newsCrypto = [];
      _newsForex = [];
      _newsStocks = [];

      _newsAggr.forEach((element) {
        if (element.id == "crypto") _newsCrypto = element.data;
        if (element.id == "forex") _newsForex = element.data;
        if (element.id == "stocks") _newsStocks = element.data;
      });

      _newsAll = _newsCrypto + _newsForex + _newsStocks;
      _newsAll.sort((a, b) => b.getPublishedDate().compareTo(a.getPublishedDate()));

      notifyListeners();
    });
  }

  void cancleStreamAggrNews() {
    _streamSubscriptionNewsAggr?.cancel();
  }

  /* -------------------------------- NOTE Post ------------------------------- */
  List<Notification> _notifications = [];
  List<Notification> get notifications => _notifications;
  StreamSubscription<NotificationAggr>? _streamSubscriptionNotificationsAggr;

  void streamNotificationsAggr() {
    var res = FirestoreService.streamNotificationAggr();

    _streamSubscriptionNotificationsAggr = res.listen((event) {
      _notifications = event.data;
      notifyListeners();
    });
  }

  void cancleStreamNotifications() {
    _streamSubscriptionNotificationsAggr?.cancel();
  }

  /* -------------------------------- NOTE Post ------------------------------- */
  List<Post> _posts = [];
  List<Post> get posts => _posts;
  StreamSubscription<PostAggr>? _streamSubscriptionPost;

  void streamPostsAggr() {
    var res = FirestoreService.streamPostsAggr();
    _streamSubscriptionPost = res.listen((event) {
      _posts = event.data;
      notifyListeners();
    });
  }

  void cancleStreamPost() {
    _streamSubscriptionPost?.cancel();
  }


  /* -------------------------------- NOTE Strategy ------------------------------- */
  List<Post> _strategies = [];
  List<Post> get strategies => _strategies;
  StreamSubscription<PostAggr>? _streamSubscriptionStrategy;

  void streamStrategiesAggr() {
    var res = FirestoreService.streamPostsAggr();
    _streamSubscriptionStrategy = res.listen((event) {
      _strategies = event.data;
      notifyListeners();
    });
  }

  void cancleStreamStrategy() {
    _streamSubscriptionStrategy?.cancel();
  }

  /* -------------------------------- NOTE Video ------------------------------- */
  List<VideoLesson> _videoLessons = [];
  List<VideoLesson> get videoLessons => _videoLessons;

  VideoLessonAggr _vedioLessonAggr = VideoLessonAggr();
  VideoLessonAggr get vedioLessonAggr => _vedioLessonAggr;
  StreamSubscription<VideoLessonAggr>? _streamSubscriptionVideoLessonAggr;

  void streamVideoLessonAggr() {
    var res = FirestoreService.streamVideoLessonAggr();
    _streamSubscriptionVideoLessonAggr = res.listen((event) {
      _vedioLessonAggr = event;
      _videoLessons = _vedioLessonAggr.data;

      notifyListeners();
    });
  }

  void cancleStreamVideoLessons() {
    _streamSubscriptionVideoLessonAggr?.cancel();
  }

  /* -------------------------------- NOTE Announcment ------------------------------- */
  List<Announcement> _annoucements = [];
  List<Announcement> get announcements => _annoucements;

  AnnouncementAggr _annoucementAggr = AnnouncementAggr();
  AnnouncementAggr get annoucementAggr => _annoucementAggr;
  StreamSubscription<AnnouncementAggr>? _streamSubscriptionAnnoucementAggr;

  void streamAnnoucementsAggr() {
    var res = FirestoreService.streamAnnouncementsAggr();
    _streamSubscriptionAnnoucementAggr = res.listen((event) {
      _annoucementAggr = event;
      _annoucements = _annoucementAggr.data;

      notifyListeners();
    });
  }

  void cancleStreamAnnoucements() {
    _streamSubscriptionAnnoucementAggr?.cancel();
  }

/* ---------------------------- NOTE SIGNAL ARRGS --------------------------- */
  List<SignalAggrOpen> _signalAggrsOpen = [];
  List<SignalAggrOpen> get signalAggrsOpen => _signalAggrsOpen;
  StreamSubscription<List<SignalAggrOpen>>? _streamSubscriptionSignalAggrsOpen;

  void streamSignalsAggrOpen() {
    var res = FirestoreService.streamSignalsAggrOpen();
    _streamSubscriptionSignalAggrsOpen = res.listen((event) {
      _signalAggrsOpen = event;
      notifyListeners();
    });
  }

  void cancleStreamSignalsAggrOpen() {
    _streamSubscriptionSignalAggrsOpen?.cancel();
  }
}
