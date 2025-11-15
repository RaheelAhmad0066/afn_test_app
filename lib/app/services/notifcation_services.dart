//get token
// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class NotificationService {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //send notificartion request
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
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

//Fetch FCM Token
  Future<String> getDeviceToken() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Wait a bit for APNS token to be available (especially on iOS)
      await Future.delayed(const Duration(milliseconds: 500));
      
      String? token = await messaging.getToken();
      
      if (token == null || token.isEmpty) {
        // Retry once after a delay
        await Future.delayed(const Duration(seconds: 2));
        token = await messaging.getToken();
      }
      
      if (token == null || token.isEmpty) {
        throw Exception('FCM token is null or empty');
      }
      
      print("token=> $token");
      return token;
    } catch (e) {
      print("Error getting FCM token: $e");
      rethrow;
    }
  }

  // Initialize local notifications plugin (should be called once at app startup)
  Future<void> initializeLocalNotifications() async {
    // Create Android notification channel
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap when app is in foreground
        if (kDebugMode) {
          print('📬 Notification tapped: ${response.payload}');
        }
        // You can navigate here based on payload
      },
    );
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(RemoteMessage message) async {
    // Check if already initialized
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (response) {
      // handle interaction when app is active for android
      handleMessage(message);
    });
  }

//
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(message);
        showNotification(message);
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage() async {
    // // when app is terminated
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();

    // if (initialMessage != null) {
    //   handleMessage(context, initialMessage);
    // }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });

    // Handle terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(message);
      }
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: channel.sound
            //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
            //  icon: largeIconPath
            );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: 'my_data',
      );
    });
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Handle notification message based on user role and notification type
  Future<void> handleMessage(RemoteMessage message) async {
    try {
      final data = message.data;
      final notificationType = data['type'] ?? '';
      final role = data['role'] ?? '';
      
      if (kDebugMode) {
        print('📬 Notification received - Type: $notificationType, Role: $role');
        print('📬 Notification data: $data');
      }

      // Handle navigation based on notification type and role
      // This will be implemented based on your app's navigation structure
      // Example:
      // if (notificationType == 'booking') {
      //   Get.toNamed(AppRoutes.bookingDetail, arguments: {'id': data['bookingId']});
      // } else if (notificationType == 'message') {
      //   Get.toNamed(AppRoutes.chatScreen, arguments: {'conversationId': data['conversationId']});
      // }
      
      // For now, just log the message
      if (kDebugMode) {
        print('📬 Handling notification: ${message.notification?.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error handling notification: $e');
      }
    }
  }
}