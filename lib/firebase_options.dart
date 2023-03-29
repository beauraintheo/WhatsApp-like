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
    apiKey: 'AIzaSyBgHOYR47FwwAdxTjhIpUJJPtRVPxxeFhU',
    appId: '1:539761306642:web:cb13136d696b6d14b0fccb',
    messagingSenderId: '539761306642',
    projectId: 'whatsapp-like-113a1',
    authDomain: 'whatsapp-like-113a1.firebaseapp.com',
    storageBucket: 'whatsapp-like-113a1.appspot.com',
    measurementId: 'G-QYVWHV8L5E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCn6t1oITkfmmNIkepBia6aToGvIlRyORY',
    appId: '1:539761306642:android:52802e564774d535b0fccb',
    messagingSenderId: '539761306642',
    projectId: 'whatsapp-like-113a1',
    storageBucket: 'whatsapp-like-113a1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5UgrPXHiiWOoaTJK3-Lj0LjiTp3ZqyoE',
    appId: '1:539761306642:ios:19c53d987d9873e1b0fccb',
    messagingSenderId: '539761306642',
    projectId: 'whatsapp-like-113a1',
    storageBucket: 'whatsapp-like-113a1.appspot.com',
    iosClientId: '539761306642-mfg9qtf9dq0lprs3uijksof9dk9ocjlc.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappLike',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5UgrPXHiiWOoaTJK3-Lj0LjiTp3ZqyoE',
    appId: '1:539761306642:ios:19c53d987d9873e1b0fccb',
    messagingSenderId: '539761306642',
    projectId: 'whatsapp-like-113a1',
    storageBucket: 'whatsapp-like-113a1.appspot.com',
    iosClientId: '539761306642-mfg9qtf9dq0lprs3uijksof9dk9ocjlc.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappLike',
  );
}