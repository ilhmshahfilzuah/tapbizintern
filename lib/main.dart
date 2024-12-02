import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'mainMaterialApp.dart';


/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );


  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

// ----- END FCM ----- //

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/subgoogle_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets/subgoogle_fonts'], license);
  });

  // this function makes application always run in portrait mode
  // WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      name: "mlf.techworq.tapbiz",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // _initializeFirebase();
    runApp(FcmContainerWidget());
  });
}


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

// void main() => runApp(const App());

class FcmContainerWidget extends StatefulWidget {
  const FcmContainerWidget({super.key});

  @override
  State<FcmContainerWidget> createState() => _FcmContainerWidgetState();
}

class _FcmContainerWidgetState extends State<FcmContainerWidget> {
  @override
  void initState() {
    setupFcm();
    super.initState();
  }

  Future<void> setupFcm() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    messaging.getInitialMessage().then(
          // (value) => setState(
          //   () {
          //     _resolved = true;
          //     initialMessage = value?.data.toString();
          //   },
          // ),
          (value) {}
        );


    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        // PushNotification notification = PushNotification(
        //   title: message.notification?.title,
        //   body: message.notification?.body,
        // );

        // setState(() {
        //   _notificationInfo = notification;
        //   _totalNotifications++;
        // });
      });

      final fcmToken = await messaging.getToken();
      
      _saveFcmToken(fcmToken ?? "");

      FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          _saveFcmToken(fcmToken);
        })
        .onError((err) {
          // Error getting token.
        });

    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  void _saveFcmToken(String fcmToken) async {
    if (fcmToken.isNotEmpty) {
      final SharedPreferences _pref = await SharedPreferences.getInstance();
      await _pref.setString('fcmToken', fcmToken);
      print("FCM-Token: " + fcmToken);
    } else {
      final SharedPreferences _pref = await SharedPreferences.getInstance();
      await _pref.remove("fcmToken");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    return MainMaterialApp();
  }
}

