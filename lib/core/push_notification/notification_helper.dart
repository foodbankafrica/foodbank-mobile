import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationHelper({
    required this.flutterLocalNotificationsPlugin,
  }) {
    _initPlugin();
  }

  Future<void> _initPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
        ],
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
    );

    _requestPermission();
    debugPrint('notification initialized');
  }

  void onSelectNotification(String? payload) {}

  // void _initTimeZone() {
  //   tz.initializeTimeZones();
  //   tz.setLocalLocation(tz.getLocation('Africa/Lagos'));
  // }

  Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return;
    }
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      return;
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails? androidPlatformChannelSpecifics;
    DarwinNotificationDetails? iosNotificationDetailsSpecifics;

    if (Platform.isAndroid) {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "Expressbites",
        "Expressbites",
        channelDescription: 'Expressbites user',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        // styleInformation: InboxStyleInformation(lines)
        icon: '@mipmap/ic_launcher',
      );
    }
    if (Platform.isIOS) {
      iosNotificationDetailsSpecifics = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: 'subtitle',
        threadIdentifier: 'threadIdentifier',
        categoryIdentifier: darwinNotificationCategoryPlain,
      );
    }

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosNotificationDetailsSpecifics,
      macOS: iosNotificationDetailsSpecifics,
    );
    try {
      await flutterLocalNotificationsPlugin.show(
        math.Random().nextInt(1000),
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      log('error: ${e.toString()}');
      // log(s.toString());
    }
  }

  void onDidReceiveLocalNotification(NotificationResponse details) {}
}
