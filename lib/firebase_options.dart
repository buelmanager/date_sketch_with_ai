// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Platform  Firebase App Id
// web       1:934589307904:web:e4658e585f036ef0b94ce5
// android   1:934589307904:android:921e585ca69fa188b94ce5
// ios       1:934589307904:ios:92f3d13a94af4b87b94ce5
// macos     1:934589307904:ios:ebfda74d34dcbbf8b94ce5
// windows   1:934589307904:web:609239a73d5b4661b94ce5
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
    apiKey: 'AIzaSyA-1j_Q42O_DXjOwdcwXzz5rcyslxi6QbI',
    appId: '1:934589307904:web:e4658e585f036ef0b94ce5',
    messagingSenderId: '934589307904',
    projectId: 'date-sketch',
    authDomain: 'date-sketch.firebaseapp.com',
    storageBucket: 'date-sketch.firebasestorage.app',
    measurementId: 'G-3DM3NEDZRP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsxuGH_oU_4JAnDpdD09fjxXbymPlSRAs',
    appId: '1:934589307904:android:921e585ca69fa188b94ce5',
    messagingSenderId: '934589307904',
    projectId: 'date-sketch',
    storageBucket: 'date-sketch.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCna3eDXd_jj05oyed7EjNp-dhnhcKjN48',
    appId: '1:934589307904:ios:92f3d13a94af4b87b94ce5',
    messagingSenderId: '934589307904',
    projectId: 'date-sketch',
    storageBucket: 'date-sketch.firebasestorage.app',
    iosClientId: '934589307904-4oq4k7cg5l81ab0h69ncjrulos26t4le.apps.googleusercontent.com',
    iosBundleId: 'com.buelmanager.DateSketch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCna3eDXd_jj05oyed7EjNp-dhnhcKjN48',
    appId: '1:934589307904:ios:ebfda74d34dcbbf8b94ce5',
    messagingSenderId: '934589307904',
    projectId: 'date-sketch',
    storageBucket: 'date-sketch.firebasestorage.app',
    iosClientId: '934589307904-fg3emqms9uvj6k1bjd8lq5m86s06c2gf.apps.googleusercontent.com',
    iosBundleId: 'com.example.myDManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-1j_Q42O_DXjOwdcwXzz5rcyslxi6QbI',
    appId: '1:934589307904:web:609239a73d5b4661b94ce5',
    messagingSenderId: '934589307904',
    projectId: 'date-sketch',
    authDomain: 'date-sketch.firebaseapp.com',
    storageBucket: 'date-sketch.firebasestorage.app',
    measurementId: 'G-D9LFJ4198B',
  );

}