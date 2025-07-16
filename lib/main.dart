import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lapuerta2/auth.dart';
import 'package:lapuerta2/firebase_api.dart';
import 'package:lapuerta2/mainwrapper.dart';
import 'package:lapuerta2/onboarding.dart';
import 'package:lapuerta2/theme.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default_channel',
  'General Notifications',
  description: 'Canal para notificaciones generales',
  importance: Importance.high,
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final title = message.data['title'] ?? 'La Puerta';
  final body = message.data['body'] ?? 'Nuevo contenido disponible';

  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    ),
    iOS: DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    notificationDetails,
  );
}


Future<void> main() async {
  tz.initializeTimeZones();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Registrar handler en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Inicializar notificaciones locales
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ Presentación para notificaciones en iOS foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseApi().initNotifications();
  //Stripe.publishableKey = "pk_test_51RBIWtRtC705svstNUXRchCHHCdhkTiYrhGRKaDoP7upv0XhIkoJUmY8Gb3Nj8i2bCMACY0mMnEKOw6eB5dDwFe600Z60ceaGG";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //statusBarIconBrightness: Brightness.dark,
    ));
    FlutterNativeSplash.remove();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(
      initialRoute: 'initial',
      themeAnimationDuration: Duration.zero,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      darkTheme: darkMode,
      //home: OnboardingPage(),
      navigatorKey: navigatorKey,
      routes: {
        'initial': (context) => StreamBuilder(
              stream: Auth().authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.email.toString() !=
                      'admin@lapuertawaco.com') {
                    return const Mainwrapper();
                  }
                  return const OnboardingPage();
                } else {
                  return const OnboardingPage();
                }
              },
            ),
      },
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
