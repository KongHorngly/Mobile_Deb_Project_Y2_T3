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
    apiKey: 'AIzaSyA611YVlL6b2zbudb2tBm8f5uhaXIS4rnU',
    appId: '1:1048079203615:web:06c742b7f975162ce4c42a',
    messagingSenderId: '1048079203615',
    projectId: 'mydata-8be4a',
    authDomain: 'mydata-8be4a.firebaseapp.com',
    databaseURL: 'https://mydata-8be4a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mydata-8be4a.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADBL030oCHx8C__B2HL1nevlzP-c1TPMM',
    appId: '1:1048079203615:android:6e9a141e8c8007cfe4c42a',
    messagingSenderId: '1048079203615',
    projectId: 'mydata-8be4a',
    databaseURL: 'https://mydata-8be4a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mydata-8be4a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBD3O9D3iKEje0zYdWntzvY5x_gdSyl4A',
    appId: '1:1048079203615:ios:ccc0947e78583c31e4c42a',
    messagingSenderId: '1048079203615',
    projectId: 'mydata-8be4a',
    databaseURL: 'https://mydata-8be4a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mydata-8be4a.firebasestorage.app',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDBD3O9D3iKEje0zYdWntzvY5x_gdSyl4A',
    appId: '1:1048079203615:ios:ccc0947e78583c31e4c42a',
    messagingSenderId: '1048079203615',
    projectId: 'mydata-8be4a',
    databaseURL: 'https://mydata-8be4a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mydata-8be4a.firebasestorage.app',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA611YVlL6b2zbudb2tBm8f5uhaXIS4rnU',
    appId: '1:1048079203615:web:40a76a4b0737112ee4c42a',
    messagingSenderId: '1048079203615',
    projectId: 'mydata-8be4a',
    authDomain: 'mydata-8be4a.firebaseapp.com',
    databaseURL: 'https://mydata-8be4a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mydata-8be4a.firebasestorage.app',
  );
}
