// File generated to support Firebase configuration
// This file connects your Flutter app to your Firebase project: smartpump-38295

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBtDThp0svur5MEVFwF_ykdCKKps8BKuN4',
    appId: '1:69282659258:web:your-web-app-id', // Update this when configuring web
    messagingSenderId: '69282659258',
    projectId: 'smartpump-38295',
    authDomain: 'smartpump-38295.firebaseapp.com',
    storageBucket: 'smartpump-38295.firebasestorage.app',
    databaseURL: 'https://smartpump-38295-default-rtdb.europe-west1.firebasedatabase.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtDThp0svur5MEVFwF_ykdCKKps8BKuN4',
    appId: '1:69282659258:android:9aa076b06210c16b09bb83',
    messagingSenderId: '69282659258',
    projectId: 'smartpump-38295',
    storageBucket: 'smartpump-38295.firebasestorage.app',
    databaseURL: 'https://smartpump-38295-default-rtdb.europe-west1.firebasedatabase.app',
  );

  // Note: iOS configuration would go here when configured
  // static const FirebaseOptions ios = FirebaseOptions(...);
}

