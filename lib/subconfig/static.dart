import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class StaticVarMethod {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static bool isInitLocalNotif = false;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool isDarkMode = false;
}
