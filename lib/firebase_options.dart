// File generated manually based on provided config files.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDVCNKn3sx3wrLUhEPQziVl80HIIRLqNqs',
    appId: '1:928201206715:web:c1f4bcfd1a8cc39de7b29e',
    messagingSenderId: '928201206715',
    projectId: 'unibite-app',
    authDomain: 'unibite-app.firebaseapp.com',
    storageBucket: 'unibite-app.firebasestorage.app',
    measurementId: 'G-WBRH446GLH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6pmDGsYTmBYRwJ1wUpdw7zYiylNDTJe8',
    appId: '1:928201206715:android:f4cf69eaad0cccdae7b29e',
    messagingSenderId: '928201206715',
    projectId: 'unibite-app',
    storageBucket: 'unibite-app.firebasestorage.app',
  );
}
