import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request user permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      provisional: false,
      sound: true,
    );

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    // NOTE: Send token to backend for push notifications
    // ignore: avoid_print
    print('FCM Token: $token');

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // NOTE: Show local notification
      // ignore: avoid_print
      print('Foreground message: ${message.notification?.title}');
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // NOTE: Navigate to appropriate screen
      // ignore: avoid_print
      print('Background message opened: ${message.notification?.title}');
    });
  }

  Future<void> subscribeTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> subscribeToOrderUpdates(String userId) async {
    await subscribeTopic('orders_$userId');
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
