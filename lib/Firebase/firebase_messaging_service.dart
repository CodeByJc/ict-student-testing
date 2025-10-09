import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Helper/Utils.dart';
import 'notification_payload_model.dart';

bool isAppOpen = false;

configureFirebasePushNotifications() async {
  try {
    await Firebase.initializeApp();
    isAppOpen = true;
  } catch (e, s) {
    if (kDebugMode) {
      print("Error while init of firebase:\n$e\n$s");
    }
  }
  await Future.delayed(const Duration(milliseconds: 200));

  try {

    ///Store FCM
    Utils.getFCMToken();

    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    //
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   print('User granted permission');
    // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    //   print('User granted provisional permission');
    // } else {
    //   print('User declined or has not accepted permission');
    // }

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


    FirebaseMessaging.onMessage.listen((message) async {
      final payload = message.remoteData;
      if (payload != null) {
        handleFirebaseNotificationDisplay(payload);
      }
      if (kDebugMode) {
        print('Notification onMessage ${message.toMap()}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('Notification onMessageOpenedApp ${message.toMap()}');
      }

      final payload = message.remoteData;
      if (payload != null) {
        handleFirebaseNotificationDisplay(payload);
      }
    });

    // if (Platform.isAndroid) {
    //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // }
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e, s) {
    if (kDebugMode) {
      print("Error after init of firebase:\n$e\n$s");
    }
  }
}


extension RemoteMessageExtension on RemoteMessage {
  NotificationPayLoadModel? get remoteData {
    try {
      return NotificationPayLoadModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!isAppOpen) return;
  if (kDebugMode) {
    print("Handling a background message: ${message.toMap()}");
  }

  try {
    const channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification');
    const initializationSettingsIOS = DarwinInitializationSettings();

    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    } else {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    }

    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    ///Not able to stop default notification
    ///there fore when custom notification is called
    ///result is 2 notifications displayed.

    final remoteData = message.remoteData;
    if (remoteData != null) {
      final NotificationDetails notificationDetails = await createNotificationDetail(message: message, imageUrl: remoteData.image);
      try {
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          remoteData.title,
          remoteData.message,
          notificationDetails,
          payload: message.remoteData?.toString(),
        );
      } catch (e, s) {
        if (kDebugMode) {
          print("Error: $e");
        }
        if (kDebugMode) {
          print("Stack: $s");
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
  }
}

// Function to create Android Notification Detail with Image Support
Future<NotificationDetails> createNotificationDetail({required RemoteMessage message, String? imageUrl}) async {
  AndroidNotificationDetails? androidPlatformChannelSpecifics;
  DarwinNotificationDetails? iOSPlatformChannelSpecifics;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    final String imagePath = await _downloadAndSaveImage(imageUrl, imageUrl.split("/").lastOrNull ?? '');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath), // Image file for the notification
      contentTitle: message.notification?.title,
      summaryText: message.notification?.body,
    );

    if (Platform.isIOS) {
      iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        attachments: [
          DarwinNotificationAttachment(imagePath),
        ],
        subtitle: message.notification?.body,
        presentSound: true,
        presentBadge: true,
        presentAlert: true,
      );
    } else if (Platform.isAndroid) {
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'high_importance_channel', // Channel ID
        'High Importance Notifications', // Channel Name
        styleInformation: bigPictureStyleInformation,
        // Image in notification
        importance: Importance.high,
        priority: Priority.high,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.event,
      );
    }
  } else {
    if (Platform.isIOS) {
      iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        presentSound: true,
        presentBadge: true,
        presentAlert: true,
        subtitle: message.notification?.body,
      );
    } else if (Platform.isAndroid) {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'high_importance_channel', // Channel ID
        'High Importance Notifications', // Channel Name
        importance: Importance.high,
        priority: Priority.high,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.event,
      );
    }
  }

  return NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
}

// Function to download and save the image
Future<String> _downloadAndSaveImage(String url, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final response = await http.get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

@pragma('vm:entry-point')
onDidReceiveNotificationResponse(NotificationResponse response) {
  print("onDidReceiveNotificationResponse : ${response.payload}");
  final payload = NotificationPayLoadModel.fromString(response.payload);
  if (payload != null) {
    handleFirebaseNotificationDisplay(payload);
  }
}

handleFirebaseNotificationDisplay(NotificationPayLoadModel model) {
  callGeneralNotificationRequestAndNavigate(model);
}

///This fun for handling local notifications.
handlePendingMessages() async {
  final pendingMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (pendingMessage != null) {
    if (kDebugMode) {
      print('Notification pendingMessage remoteData ${pendingMessage.remoteData?.toJson()}');
    }

    final payload = pendingMessage.remoteData;
    if (payload != null) {
      handleFirebaseNotificationDisplay(payload);
    }
  } else {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    final payload = NotificationPayLoadModel.fromString(details?.notificationResponse?.payload);
    if (kDebugMode) {
      print('Local Notification pendingMessage remoteData ${payload?.toJson()}');
    }

    if (payload != null) {
      handleFirebaseNotificationDisplay(payload);
    }
  }
}

///Handled order notification
callOrderRequestDetailAPIAndNavigate(NotificationPayLoadModel model) {
  debugPrint("clicked order notification");
}

///Handled payment notification
callPaymentRequestDetailAPIAndNavigate(NotificationPayLoadModel model) {
  debugPrint("clicked payment notification");
}

///Handled general notification
callGeneralNotificationRequestAndNavigate(NotificationPayLoadModel model) {
  debugPrint("clicked general notification");
}
