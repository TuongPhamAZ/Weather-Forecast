// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAqshOPz2zMJARuoEEPMiWAlrVS4aBVaJ8',
    appId: '1:722367885499:web:3c3e79f97f7cefd99f799e',
    messagingSenderId: '722367885499',
    projectId: 'weatherforecast-16d8e',
    authDomain: 'weatherforecast-16d8e.firebaseapp.com',
    storageBucket: 'weatherforecast-16d8e.firebasestorage.app',
    measurementId: 'G-SEJJ86ZYFN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGrr3s7Gp6_tezs9VKfU40oo9PMJ8OHHE',
    appId: '1:722367885499:android:7aeb9c545b9552759f799e',
    messagingSenderId: '722367885499',
    projectId: 'weatherforecast-16d8e',
    storageBucket: 'weatherforecast-16d8e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfn10iHUIgvGf021Y2DOnAP5St2jNdEdo',
    appId: '1:722367885499:ios:422601a999a1b33f9f799e',
    messagingSenderId: '722367885499',
    projectId: 'weatherforecast-16d8e',
    storageBucket: 'weatherforecast-16d8e.firebasestorage.app',
    iosBundleId: 'com.example.skycast',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfn10iHUIgvGf021Y2DOnAP5St2jNdEdo',
    appId: '1:722367885499:ios:422601a999a1b33f9f799e',
    messagingSenderId: '722367885499',
    projectId: 'weatherforecast-16d8e',
    storageBucket: 'weatherforecast-16d8e.firebasestorage.app',
    iosBundleId: 'com.example.skycast',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAqshOPz2zMJARuoEEPMiWAlrVS4aBVaJ8',
    appId: '1:722367885499:web:134897f0ce072bfb9f799e',
    messagingSenderId: '722367885499',
    projectId: 'weatherforecast-16d8e',
    authDomain: 'weatherforecast-16d8e.firebaseapp.com',
    storageBucket: 'weatherforecast-16d8e.firebasestorage.app',
    measurementId: 'G-9BYEK1DK2E',
  );
}
