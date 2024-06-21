import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  final ValueChanged<RemoteMessage>? onMessage;
  final ValueChanged<String>? onTokenChanged;

  PushNotificationService(this._fcm, {this.onMessage, this.onTokenChanged});

  Future<void> init() async {
    // request permission
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      toast("We need notification permission to show notifications");
      return;
    }

    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      return;
    }

    print("FirebaseMessaging token: $fcmToken");

    onTokenChanged?.call(fcmToken);

    _handleInitialMessage();
    _listenToTokenChanges();
  }

  Future<void> _handleInitialMessage() async {
    final message = await _fcm.getInitialMessage();

    if (message != null) {
      handleNewMessage(message);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleNewMessage);
  }

  void handleNewMessage(RemoteMessage message) {
    onMessage?.call(message);
  }

  void _listenToTokenChanges() {
    _fcm.onTokenRefresh.listen((event) {
      onTokenChanged?.call(event);
    });
  }
}
