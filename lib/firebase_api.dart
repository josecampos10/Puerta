import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lapuerta2/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
int badgeCount = 0;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> notiStatus() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    print('🔔 iOS settings: $settings');
  }

Future<void> initNotifications(String email) async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    await initializeLocalNotifications();
    await initPushNotifications();

    // 🔁 Leer el badge real de Firestore al iniciar
    final doc = await FirebaseFirestore.instance.collection('users').doc(email).get();
    final count = doc.data()?['badgeCount'] ?? 0;
    badgeCount = count;
    if (badgeCount > 0) {
      await FlutterAppBadgeControl.updateBadgeCount(badgeCount);
    }

    // 📩 Cuando llega una nueva notificación en foreground
    FirebaseMessaging.onMessage.listen((message) async {
      final updated = await FirebaseFirestore.instance.collection('users').doc(email).get();
      final updatedCount = updated.data()?['badgeCount'] ?? 0;
      badgeCount = updatedCount;
      await FlutterAppBadgeControl.updateBadgeCount(badgeCount);
    });

    // 🧹 Cuando el usuario abre la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await resetBadge(email);
    });
  }

  Future<void> resetBadge(String email) async {
    badgeCount = 0;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'badgeCount': 0,
    });
    await FlutterAppBadgeControl.removeBadge();
  }

  Future<void> initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcer_icon');

    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Crear canal en Android (no afecta iOS)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'default_channel', // 👈 debe coincidir con el ID usado en AndroidNotificationDetails
          'General Notifications',
          description: 'Notificaciones generales de la app',
          importance: Importance.high,
        ));

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void showLocalNotification(String title, String body) {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      '/notifications_screen',
      arguments: message,
    );
  }

  Future<void> initPushNotifications() async {
    // App terminada
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // App background → foreground
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // App foreground
    FirebaseMessaging.onMessage.listen((m) {
      final notification = m.notification;
      final data = m.data;

      // 🔎 Solo mostrar notificación local si NO viene con notification
      if (notification == null && data.isNotEmpty) {
        final title = data['title'] ?? 'La Puerta';
        final body = data['body'] ?? '';

        if (Platform.isAndroid) {
          showLocalNotification(title, body);
        }
      }

      // 👇 Siempre imprimir para depurar
      print('🔔 foreground: title=${notification?.title ?? data['title']}');
    });
  }
}
