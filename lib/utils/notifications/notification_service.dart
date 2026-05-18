import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/user_repository.dart';

class NotificationService extends GetxService {
  static NotificationService get instance => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Request permission for push notifications
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Get FCM Token for this device
      String? token = await _messaging.getToken();
      print('DEBUG: FCM Token fetched: $token');
      if (token != null) {
        await saveTokenToSupabase(token);
      }

      // Listen for token refreshes
      _messaging.onTokenRefresh.listen(saveTokenToSupabase);

      // Initialize local notifications for foreground alerts
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      await _localNotifications.initialize(settings: initializationSettings);

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
      });
    }
  }

  /// Save or Update token in Supabase 'profiles' table
  Future<void> saveTokenToSupabase(String token) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      print('DEBUG: Saving FCM Token for User: $userId');
      if (userId != null) {
        await UserRepository.instance.updateSingleField({'fcm_token': token});
        print('DEBUG: FCM Token saved successfully');
      } else {
        print('DEBUG: No user logged in, token not saved');
      }
    } catch (e) {
      print('DEBUG: Error saving FCM token: $e');
    }
  }

  /// Logic to show notification when app is in foreground
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }
}
