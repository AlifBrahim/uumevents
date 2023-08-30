// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAsMbwg7O2qJgbzsePCrAMRSbf0-GSFRvU',
    appId: '1:95842228240:web:15e43e2cf1f2a19eab1295',
    messagingSenderId: '95842228240',
    projectId: 'toastmasters-4168d',
    authDomain: 'toastmasters-4168d.firebaseapp.com',
    storageBucket: 'toastmasters-4168d.appspot.com',
    measurementId: 'G-M51RGQBJBR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfku6r5bcS6gD8NR1umIz7Gl3dDKbLdys',
    appId: '1:95842228240:android:e7e13a57885052b0ab1295',
    messagingSenderId: '95842228240',
    projectId: 'toastmasters-4168d',
    storageBucket: 'toastmasters-4168d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfPp8jM8Km3AvsnjzsgZBx6YlUnyu_xxc',
    appId: '1:95842228240:ios:7949f89cf76e0219ab1295',
    messagingSenderId: '95842228240',
    projectId: 'toastmasters-4168d',
    storageBucket: 'toastmasters-4168d.appspot.com',
    iosBundleId: 'com.example.uumevents',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfPp8jM8Km3AvsnjzsgZBx6YlUnyu_xxc',
    appId: '1:95842228240:ios:f06755c109763539ab1295',
    messagingSenderId: '95842228240',
    projectId: 'toastmasters-4168d',
    storageBucket: 'toastmasters-4168d.appspot.com',
    iosBundleId: 'com.example.uumevents.RunnerTests',
  );
}
