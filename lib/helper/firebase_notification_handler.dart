import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_management_system/network/Constant.dart';

import 'Utils.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseCloudMessagingListeners(context);
  }

  void _firebaseCloudMessagingListeners(BuildContext context) {
    if (Platform.isIOS) _iosPermission();

    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: " + token);
    });

    _firebaseMessaging.subscribeToTopic(Constant.FCM_TOPIC);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        if (Platform.isIOS)
          Utils.showToastNotification(message["aps"]["alert"]["title"]);
        else
          Utils.showToastNotification(message["notification"]["title"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void _iosPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
