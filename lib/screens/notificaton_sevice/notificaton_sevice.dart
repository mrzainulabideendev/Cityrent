
import 'package:car_rent/utilz/contants/export.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission");
    }
  }

  ////////////////////////////////////////  initLocalNotifications ///////////////////////////

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitLocal =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettings =
        InitializationSettings(android: androidInitLocal);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handelmasg(context, message);
    });
  }

  /////////////////////////////////////////// Firebase init ///////////////////////////

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          print(message.notification!.title.toString());
          print(message.notification!.body.toString());

     
        }

        if (Platform.isAndroid) {
          initLocalNotifications(context, message);
          showNotifications(message);
        } else {
          showNotifications(message);
        }
      },
    );
  }

  ///////////////////////////////////////// showNotifications ///////////////////////////

  Future<void> showNotifications(RemoteMessage message) async {
    String channelId = "10000000000000000";
    String channelName =
        "Your Channel Name"; 
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: "Your channel Description",
      importance: Importance.high,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: "Your channel Description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",

      // Specify the icon correctly, ensure this icon exists
      icon: "@mipmap/ic_launcher", // Ensure this icon exists
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          8,
          message.notification!.title ??
              "No Title", // Safeguard against null title
          message.notification!.body ??
              "No Body", // Safeguard against null body
          notificationDetails);
    });
  }

  /////////////////////////////////////////// Get device token /////////////////////////////

  Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  //////////////////////////////////////// Get device refresh token ///////////////////////////

   refreshToken() async {
    messaging.onTokenRefresh.listen(
      (event) {
        print("Token refreshed: $event");
      },
    );
  }
  ///////////////////////////////////////// Notifications  background and kill ///////////////////////////

  Future<void> setupInteractNotifications(BuildContext context) async {
    RemoteMessage? initialmassage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialmassage != null) {
      handelmasg(context, initialmassage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        handelmasg(context, event);
      },
    );
  }

  ///////////////////////////////////////// handel masg Notifications ///////////////////////////
  void handelmasg(BuildContext context, RemoteMessage message) {






    
  }

  ///////////////////////////////////////// showNotifications ///////////////////////////


  //////////////////////////////////////// Get device refresh token ///////////////////////////
}
