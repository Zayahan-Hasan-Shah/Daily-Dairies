import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get_navigation/get_navigation.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  log('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  //Android Setup
  final _androidchannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigatorkey.currentState?.pushNamed(argument);
  }

  Future initLocalNotification() async {
    const android = AndroidInitializationSettings('@drawable/background');
    const setting = InitializationSettings(
      android: android,
    );

    await _localNotifications.initialize(
      setting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
          handleMessage(message);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidchannel);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidchannel.id, _androidchannel.name,
                channelDescription: _androidchannel.description,
                icon: '@drawable/background'),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCToken = await _firebaseMessaging.getToken();
    print('Token: $fCToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotification();
    initLocalNotification();
  }
}
//################################# Push Notifier Foreground and background done END ############################################

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vn:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.instance.setupFlutterNotifications();
//   await NotificationService.instance.showFlutterNotifications(message);
// }

// class NotificationService {
//   // ._  makes it private
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();

//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLocalNotificationsInitialized = false;

//   Future<void> initialize() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     //request permission
//     await _requestPermission();

//     //setup message handlers
//     await _setupMessageHandler();

//     final token = await _messaging.getToken();
//     print('FCM Token: $token');
//   }

//   Future<void> _requestPermission() async {
//     final settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//       announcement: false,
//       carPlay: false,
//       criticalAlert: false,
//     );
//     print('User granted permission status: ${settings.authorizationStatus}');
//   }

//   Future<void> setupFlutterNotifications() async {
//     if (_isFlutterLocalNotificationsInitialized) {
//       return;
//     }

//     //Android Setup
//     const channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     const intializationSettingsAndroid =
//         AndroidInitializationSettings('@miomap/ic_launcher');

//     // iOS Setup
//     final initializationSettingsDarwin = DarwinInitializationSettings();

//     final initializationSettings = InitializationSettings(
//         android: intializationSettingsAndroid,
//         iOS: initializationSettingsDarwin);

//     //flutter notification setup
//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         print('onDidReceiveNotificationResponse: $details');
//       },
//     );

//     _isFlutterLocalNotificationsInitialized = true;
//   }

//   Future<void> showFlutterNotifications(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel', // id
//             'High Importance Notifications',
//             channelDescription:
//                 'This channel is used for importantn notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: '@drawable/background.png',
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentSound: true,
//             presentAlert: true,
//             presentBadge: true,
//           ),
//         ),
//         payload: message.data.toString(),
//       );
//     }
//   }

//   Future<void> _setupMessageHandler() async {
//     //foreground message
//     FirebaseMessaging.onMessage.listen((message) {
//       showFlutterNotifications(message);
//     });

//     //background message
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

//     //opened app
//     final initalMessage = await _messaging.getInitialMessage();
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//     if (message.data['type'] == 'chat') {
//       //open chat screen
//     }
//   }
// }
