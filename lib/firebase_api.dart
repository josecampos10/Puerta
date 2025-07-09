import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lapuerta2/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseApi {
  //create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  Future<void> notiStatus() async {
    await _firebaseMessaging.getNotificationSettings();
    print(_firebaseMessaging.getNotificationSettings());
  }
  //Function to initialize notifications
  Future<void> initNotifications() async {
    
    //request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission(badge: false);


    //fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    //print the token (normally you would send this to your server)
    print('token: $fCMToken');
   

    //initialize further settings for push noti
    initPushNotifications();
  }

  //function to handel received messages
  void handleMessage(RemoteMessage? message) {
    //if the message is null, do nothing
    if (message == null) return;

    //navigate to new screen when messages is received and user tags notification
    navigatorKey.currentState?.pushNamed(
      '/notifications_screen',
      arguments: message,
    );
  }

  //function to initialize background settings
  Future initPushNotifications() async {
    //handle notification if the app was terminated and new opened
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //attach event listeners for when a notification opens the app
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

}