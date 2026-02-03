import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.fuchsia:
      // TODO: Handle this case.
      case TargetPlatform.linux:
      // TODO: Handle this case.
      case TargetPlatform.windows:
      // TODO: Handle this case.
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCqFjCV_9CZmYeIvcK9FVy4drmKUlSaIWY',
    appId: '1:963656261848:web:7219f7fca5fc70afb237ad',
    messagingSenderId: '963656261848',
    projectId: 'flutterfire-ui-codelab',
    authDomain: 'flutterfire-ui-codelab.firebaseapp.com',
    storageBucket: 'flutterfire-ui-codelab.firebasestorage.app',
    measurementId: 'G-DGF0CP099H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDconZaCQpkxIJ5KQBF-3tEU0rxYsLkIe8',
    appId: '1:963656261848:android:c939ccc86ab2dcdbb237ad',
    messagingSenderId: '963656261848',
    projectId: 'flutterfire-ui-codelab',
    storageBucket: 'flutterfire-ui-codelab.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqLWsqFjYAdGyihKTahMRDQMo0N6NVjAs',
    appId: '1:963656261848:ios:d9e01cfe8b675dfcb237ad',
    messagingSenderId: '963656261848',
    projectId: 'flutterfire-ui-codelab',
    storageBucket: 'flutterfire-ui-codelab.firebasestorage.app',
    iosClientId: '963656261848-v7r3vq1v6haupv0l1mdrmsf56ktnua60.apps.googleusercontent.com',
    iosBundleId: 'com.example.complete',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqLWsqFjYAdGyihKTahMRDQMo0N6NVjAs',
    appId: '1:963656261848:ios:d9e01cfe8b675dfcb237ad',
    messagingSenderId: '963656261848',
    projectId: 'flutterfire-ui-codelab',
    storageBucket: 'flutterfire-ui-codelab.firebasestorage.app',
    iosClientId: '963656261848-v7r3vq1v6haupv0l1mdrmsf56ktnua60.apps.googleusercontent.com',
    iosBundleId: 'com.example.complete',
  );
}

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyBhaV5lAZec-MxdtBGK0nBRvSl2EfhKl1k",
  authDomain: "capital-signals.firebaseapp.com",
  projectId: "capital-signals",
  storageBucket: "capital-signals.firebasestorage.app",
  messagingSenderId: "264168183063",
  appId: "1:264168183063:web:a32cbb961f175e993b1352",
  measurementId: "G-KQ5Y7LK138"
);


const firebaseConfigs = FirebaseOptions(
    apiKey: "AIzaSyDxQIIWI3cXsXyQtOhfTZ5NfnE-rIXPqNI",
    authDomain: "quick-bee-app.firebaseapp.com",
    projectId: "quick-bee-app",
    storageBucket: "quick-bee-app.firebasestorage.app",
    messagingSenderId: "699843477834",
    appId: "1:699843477834:web:b68340aee753561e76c1b3",
    measurementId: "G-GFR3NV7859"
);

