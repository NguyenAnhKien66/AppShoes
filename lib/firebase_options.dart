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
    apiKey: 'AIzaSyDNs0M4sYvly10qoql9tOqSFEHx99EpCzQ',
    appId: '1:410112227234:web:9481118cf046bb80ed24fb',
    messagingSenderId: '410112227234',
    projectId: 'shoes-7c297',
    authDomain: 'shoes-7c297.firebaseapp.com',
    storageBucket: 'shoes-7c297.appspot.com',
    measurementId: 'G-G2FXC25BVF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBg2w0ZHItKQ1P_aODkd0aZFOEIigtQ6-E',
    appId: '1:410112227234:android:39e7209a6a2c1780ed24fb',
    messagingSenderId: '410112227234',
    projectId: 'shoes-7c297',
    storageBucket: 'shoes-7c297.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4k5_4cp5i3Ymb5e_JegIVrNQSOcVpUcI',
    appId: '1:410112227234:ios:9d66b04bbff03eabed24fb',
    messagingSenderId: '410112227234',
    projectId: 'shoes-7c297',
    storageBucket: 'shoes-7c297.appspot.com',
    iosBundleId: 'com.example.shoesapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4k5_4cp5i3Ymb5e_JegIVrNQSOcVpUcI',
    appId: '1:410112227234:ios:9d66b04bbff03eabed24fb',
    messagingSenderId: '410112227234',
    projectId: 'shoes-7c297',
    storageBucket: 'shoes-7c297.appspot.com',
    iosBundleId: 'com.example.shoesapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDNs0M4sYvly10qoql9tOqSFEHx99EpCzQ',
    appId: '1:410112227234:web:8900f43904bbe1f1ed24fb',
    messagingSenderId: '410112227234',
    projectId: 'shoes-7c297',
    authDomain: 'shoes-7c297.firebaseapp.com',
    storageBucket: 'shoes-7c297.appspot.com',
    measurementId: 'G-SXGGJ4BRG0',
  );

}