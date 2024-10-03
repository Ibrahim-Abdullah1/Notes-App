import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nafees_admin_app/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print("Subscribed to $topic");
  }

  Future<void> playNotificationSoundTwice() async {
    await _audioPlayer.play(AssetSource('bell_sound.mp3'));
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("Background Called");

    if (message.notification != null) {
      print("message: ${message.data}");
      await playNotificationSoundTwice();
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              sound: const RawResourceAndroidNotificationSound('bell_sound'),
              playSound: false,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: false,
              sound: 'bell_sound.wav',
            )),
      );
    }
  }

  void setupForegroundNotificationListener() {
    print(" 777777777777777    7Foreground Messages Called");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        playNotificationSoundTwice();
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              sound:
                  const RawResourceAndroidNotificationSound('bell_sound.mp3'),
              playSound: false,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: false,
              sound: 'bell_sound.mp3',
            ),
          ),
        );
      }
    });
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCToken = await _firebaseMessaging.getToken();
    print("Token $fCToken");

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    setupForegroundNotificationListener();
  }
}
