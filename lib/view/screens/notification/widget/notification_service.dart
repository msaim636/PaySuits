// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:io';

import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/util/app_constants.dart';
import 'package:paysuite/view/screens/trensaction/transactions_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

// Top-level function for handling background notifications
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background message received: ${message.data}');
  await NotificationServices().showNotification(message);
}

class NotificationServices {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Get fcm token
  Future<String> getDeviceToken() async {
    // TODO : IOS Device Token for simulator
    String? token = Platform.isIOS
        ? await _messaging.getAPNSToken()
        : await _messaging.getToken();

    // String? token = await _messaging.getToken();
    if (kDebugMode) {
      print("ios Device Token: $token");
    }
    return token ?? "***No Device Token Found***";
  }

  void isRefreshToken() async {
    _messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('Token Refereshed');
      }
    });
  }

  //part 1 requestNotificationPermission step
  void requestNotificationPermisions() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    }

    NotificationSettings notificationSettings = await _messaging
        .requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: true,
          criticalAlert: true,
          provisional: true,
          sound: true,
        );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('user is already granted permisions');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user is already granted provisional permisions');
    } else {
      print('User has denied permission');
    }

    await forgroundMessage();
  }

  // For IoS
  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  //part 4 notification add or not add is showing
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      print("Notification title: ${notification!.title}");
      print("Notification body: ${notification.body}");
      print("Data: ${message.data.toString()}");

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      } else if (Platform.isIOS) {
        forgroundMessage();
        initLocalNotification(context, message);
        showNotification(message);
      } else {
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }

  //part 5
  void initLocalNotification(
    BuildContext context,
    RemoteMessage message,
  ) async {
    AndroidInitializationSettings androidSetting =
        const AndroidInitializationSettings("@mipmap/launcher_icon");
    DarwinInitializationSettings iosSetting = DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
      defaultPresentSound: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializationSetting = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleMassage(context, message);
        handleBackgroundMessage(message);
      },
    );
  }

  //part 5 notification show fun
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
          message.notification!.android!.channelId.toString(),
          message.notification!.android!.channelId.toString(),
          importance: Importance.max,
          showBadge: true,
          playSound: true,
        );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          androidNotificationChannel.id.toString(),
          androidNotificationChannel.name.toString(),
          channelDescription: "${AppConstants.APP_NAME}'s Notification",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
          sound: androidNotificationChannel.sound,
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  void handleMassage(BuildContext context, RemoteMessage message) {
    if (message.data['url'] == 'payment') {
      Get.to(() => TransactionsScreen());
    } else if (message.data['url'] == 'invoice') {
      Get.toNamed(RouteHelper.getInvoiceRoute());
    } else if (message.data['url'] == 'estimate') {
      Get.toNamed(RouteHelper.getEstimateRoute());
    } else {
      print('handleMassage 4 ${message.data}');
    }
  }

  //app is kill
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      handleMassage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMassage(context, event);
    });
  }
}
