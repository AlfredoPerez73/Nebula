import 'package:firebase_core/firebase_core.dart';
import 'package:nebula/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationServices {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static String? token;

  static Future initializeApp() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await _firebaseMessaging.requestPermission();
    token = await _firebaseMessaging.getToken();
  }
}
