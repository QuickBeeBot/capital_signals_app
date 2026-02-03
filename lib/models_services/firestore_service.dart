import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement_aggr.dart';
import '../models/app_controls_public.dart';
import '../models/news_aggr.dart';
import '../models/notification_aggr.dart';
import '../models/post_aggr.dart';
import '../models/strategy_aggr.dart';
import '../models/support.dart';
import '../models/video_lesson_aggr.dart';

import '../models/signal_aggr_open.dart';

class FirestoreService {
/* ---------------------------- NOTE NEWS SERVICE --------------------------- */
  static Stream<List<NewsAggr>> streamNewsAggr() {
    var ref = FirebaseFirestore.instance.collection('newsAggr').where('isEnabled', isEqualTo: true).snapshots();
    return ref.map((doc) => doc.docs.map((doc) => NewsAggr.fromJson({...doc.data(), "id": doc.id})).toList());
  }

  static Stream<NotificationAggr> streamNotificationAggr() {
    var ref = FirebaseFirestore.instance.collection('notificationsAggr').doc('notifications').snapshots();
    return ref.map((doc) => NotificationAggr.fromJson({...?doc.data(), "id": doc.id}));
  }

  static Stream<AnnouncementAggr> streamAnnouncementsAggr() {
    var ref = FirebaseFirestore.instance.collection('announcementsAggr').doc('announcements').snapshots();
    return ref.map((doc) => AnnouncementAggr.fromJson({...?doc.data(), "id": doc.id}));
  }

  static Stream<PostAggr> streamPostsAggr() {
    // var ref = FirebaseFirestore.instance.collection('posts').where('isFree', isEqualTo: true).snapshots();
    var ref = FirebaseFirestore.instance.collection('postsAggr').doc('posts').snapshots();
    // return ref.map((doc) => doc.docs.map((doc) => PostAggr.fromJson({...doc.data(), "id": doc.id})));
    return ref.map((doc) => PostAggr.fromJson({...?doc.data(), "id": doc.id}));
  }

  static Stream<StrategyAggr> streamStrategiesAggr() {
    // var ref = FirebaseFirestore.instance.collection('posts').where('isFree', isEqualTo: true).snapshots();
    var ref = FirebaseFirestore.instance.collection('postsAggr').doc('posts').snapshots();
    return ref.map((doc) => StrategyAggr.fromJson({...?doc.data(), "id": doc.id}));
  }

  static Stream<VideoLessonAggr> streamVideoLessonAggr() {
    var ref = FirebaseFirestore.instance.collection('videoLessonsAggr').doc('videoLessons').snapshots();
    return ref.map((doc) => VideoLessonAggr.fromJson({...?doc.data(), "id": doc.id}));
  }

  static Stream<AppControlsPublic> streamAppControlsPublic() {
    var ref = FirebaseFirestore.instance.collection('appControlsPublic').doc('appControlsPublic').snapshots();
    return ref.map((doc) => AppControlsPublic.fromJson({...?doc.data(), "id": doc.id}));
  }

  static Stream<List<SignalAggrOpen>> streamSignalsAggrOpen() {
    var ref = FirebaseFirestore.instance.collection('signalsAggrOpen').where('isEnabled', isEqualTo: true).orderBy('sort', descending: false).snapshots();

    var x = ref.map((doc) => doc.docs.map((doc) => SignalAggrOpen.fromJson({...doc.data(), "id": doc.id})).toList());
    return x.map((list) => list..sort((a, b) => a.sort.compareTo(b.sort)));
  }

  static Future<List<Signal>> getSignals({String type = 'crypto'}) async {
    try {
      String colName = 'signalsCrypto';
      if (type == 'crypto') colName = 'signalsCrypto';
      if (type == 'forex') colName = 'signalsForex';
      if (type == 'stocks') colName = 'signalsStocks';

      var ref = await FirebaseFirestore.instance.collection(colName).where('isClosed', isEqualTo: true).orderBy('timestampClosed', descending: true).get();
      print(ref.docs.length);
      return ref.docs.map((doc) => Signal.fromJson({...doc.data(), "id": doc.id})).toList();
    } catch (e) {
      print(e);
      print('ere');
      return [];
    }
  }

/* -------------------------- NOTE SUPPORT SERVICE -------------------------- */
  static Future<bool> addSupport(Support support) async {
    var ref = FirebaseFirestore.instance.collection('supports').doc();
    try {
      await ref.set(support.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
