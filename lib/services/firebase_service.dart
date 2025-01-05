import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  static Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
