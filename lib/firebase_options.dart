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
    apiKey: 'AIzaSyDB8f_eGiEPMckARcq7nNKf1BpqtcE3uAs',
    appId: '1:914446915892:web:22308325440fdf95ec6d61',
    messagingSenderId: '914446915892',
    projectId: 'wellbeingapp-328b7',
    authDomain: 'wellbeingapp-328b7.firebaseapp.com',
    storageBucket: 'wellbeingapp-328b7.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbI_166dZc2M89jRE03oBbhFAOvwM_XRo',
    appId: '1:914446915892:android:84e5ea711219a88fec6d61',
    messagingSenderId: '914446915892',
    projectId: 'wellbeingapp-328b7',
    storageBucket: 'wellbeingapp-328b7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-jomsGpQBzVgi1k5fzPDO-3O28RJm4eI',
    appId: '1:914446915892:ios:60f851502610023fec6d61',
    messagingSenderId: '914446915892',
    projectId: 'wellbeingapp-328b7',
    storageBucket: 'wellbeingapp-328b7.firebasestorage.app',
    iosBundleId: 'com.example.wellBeingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-jomsGpQBzVgi1k5fzPDO-3O28RJm4eI',
    appId: '1:914446915892:ios:60f851502610023fec6d61',
    messagingSenderId: '914446915892',
    projectId: 'wellbeingapp-328b7',
    storageBucket: 'wellbeingapp-328b7.firebasestorage.app',
    iosBundleId: 'com.example.wellBeingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDB8f_eGiEPMckARcq7nNKf1BpqtcE3uAs',
    appId: '1:914446915892:web:824ce0cbea37efc7ec6d61',
    messagingSenderId: '914446915892',
    projectId: 'wellbeingapp-328b7',
    authDomain: 'wellbeingapp-328b7.firebaseapp.com',
    storageBucket: 'wellbeingapp-328b7.firebasestorage.app',
  );
}
