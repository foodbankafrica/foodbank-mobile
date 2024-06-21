import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_options.dart';
import './injections.dart';

class App {
  static Future<void> init() async {
    await _initFirebase();

    await initInjection(
      [
        AuthInjection(),
        ProfileInjection(),
        HomeInjection(),
        BagInjection(),
        CheckoutInjection(),
      ],
    );
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then(
      (token) {
        print("FCM Token: $token");
      },
    );
  }
}
