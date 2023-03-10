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
    apiKey: 'AIzaSyDMII_-WK8yxsNtvexGs8YLq-VHMWuovDM',
    appId: '1:278351431249:web:c107f92f7e01e25d261a70',
    messagingSenderId: '278351431249',
    projectId: 'notification--test',
    authDomain: 'notification--test.firebaseapp.com',
    storageBucket: 'notification--test.appspot.com',
    measurementId: 'G-43QJ920CZF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbZLTF1JdP5fv8rUauocZSNzChZasG3gw',
    appId: '1:278351431249:android:40403f4e4a40bcdd261a70',
    messagingSenderId: '278351431249',
    projectId: 'notification--test',
    storageBucket: 'notification--test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-2kcUFA2AOW-Xd5NReFZYhDJC7h1XVB4',
    appId: '1:278351431249:ios:e9b07d52d4df482d261a70',
    messagingSenderId: '278351431249',
    projectId: 'notification--test',
    storageBucket: 'notification--test.appspot.com',
    androidClientId: '278351431249-27ftn0jocsqql3avkvrsn8k6agf7mbno.apps.googleusercontent.com',
    iosClientId: '278351431249-3bm4i4aalqh3o865t8a1sl4ut33iq2pv.apps.googleusercontent.com',
    iosBundleId: 'com.example.aisDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-2kcUFA2AOW-Xd5NReFZYhDJC7h1XVB4',
    appId: '1:278351431249:ios:e9b07d52d4df482d261a70',
    messagingSenderId: '278351431249',
    projectId: 'notification--test',
    storageBucket: 'notification--test.appspot.com',
    androidClientId: '278351431249-27ftn0jocsqql3avkvrsn8k6agf7mbno.apps.googleusercontent.com',
    iosClientId: '278351431249-3bm4i4aalqh3o865t8a1sl4ut33iq2pv.apps.googleusercontent.com',
    iosBundleId: 'com.example.aisDemo',
  );
}
