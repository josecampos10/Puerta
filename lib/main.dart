import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lapuerta2/auth.dart';
import 'package:lapuerta2/firebase_api.dart';
import 'package:lapuerta2/mainwrapper.dart';
import 'package:lapuerta2/onboarding.dart';
import 'package:lapuerta2/theme.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  tz.initializeTimeZones();
  //NotiService().initNotification();
  //NotificationService().init();
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      //navigatorKey: navigatorKey,
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
