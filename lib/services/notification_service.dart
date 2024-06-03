import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:online_chat/pages/write_message_page.dart';
import '../model/m_user.dart';

class NotificationService {
  static NotificationService _notificationService =
      NotificationService._internal();

  static NotificationService get notificationService => _notificationService;

  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'mesajlasma', // id
    'mesajlasma', // title
    'Mesajlasma', // description
    importance: Importance.high,
  );
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(
      {required BuildContext context, required sessionOwner}) async {
    print("Init islemi basarili");

    /// Varsayilan olarak burdaki icon geliyor. Degistirmek icin drawable icinde degisiklik yapmamiz gerekiyor.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        MUser receiverUser = MUser.fromJson(jsonDecode(payload!));
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => WriteMessagePage(
                sessionOwner: sessionOwner, receiverUser: receiverUser),
          ),
        );
        print("onSelectNotification Calisti");
      },

    );
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("On Messge calisti");
        AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          "mesajlasma",
          "mesajlasma",
          "Mesajlasma",
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        );
        NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
        );
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title,
            message.notification?.body,
            notificationDetails,
            payload: jsonEncode(message.data["data"]));
      });
    } catch (e, s) {
      print(s);
    }
  }

  /// Bu metotu Main icinde ve Background metot icinde cagircam.
  Future<void> setUpFlutterNotifications() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print("Set up islemi basarili yapildi");
  }
}
