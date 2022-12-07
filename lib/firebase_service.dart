import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

/*
  why the callback must be standalone function:
  https://firebase.google.com/docs/cloud-messaging/flutter/receive#apple_platforms_and_android
*/
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  /*
    this method is NOT the right way to deal with device token.
    It is just a demo to show how to get the device token.
    Please refer to doc: https://firebase.google.com/docs/cloud-messaging/manage-tokens#detect-invalid-token-responses-from-the-fcm-backend
  */
  static Future<String?> getDeviceToken() async =>
      await FirebaseMessaging.instance.getToken();

  // when app is in foreground
  static void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('-----');
      print('remote message received');
      if (message.notification != null) {
        print('Message contained a notification!!!');
        print('notification title: ${message.notification!.title}');
        print('notification body: ${message.notification!.body}');
      } else {
        print('Message did not contain a notification');
      }
      print('-----');
    });
  }

  // when app is in background
  static void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
