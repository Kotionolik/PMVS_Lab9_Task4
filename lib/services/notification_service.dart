import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import
'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../core/platform/platform_utils.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
      const s = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      );
      await _plugin.initialize(s);
    }
  }
  static Future<void> show({required String title, required String body, BuildContext? context,}) async {
    try {
    if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
      const d = NotificationDetails(
      android: AndroidNotificationDetails('city_parking', 'CityParking', importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
      );
      await _plugin.show(0, title, body, d);
    } else if (kIsWeb && context != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title: $body')),
    );
    } else {
      await Fluttertoast.showToast(msg: '$title: $body');
    }
    } catch (e, s) {
      print('NotificationService: $e\n$s');
    }
  }
}