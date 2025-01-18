import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:joke_app/main.dart';
import '../pages/random_joke.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background Notification: ${message.notification?.title}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    print("Notification clicked. Navigating to RandomJokeScreen...");
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(RandomJokeScreen.route);
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');
    initPushNotifications();
  }
}
