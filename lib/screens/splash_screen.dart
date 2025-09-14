import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:selavu/utils/app_colours.dart';
import 'package:selavu/utils/app_images.dart';
import 'package:sizer/sizer.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  routeToHome() async {
    await Hive.initFlutter();
    Timer(const Duration(seconds: 2), () async {
      context.push("/bottomMenu");
    });
  }

  // Future<void> _showNotificationOnAppOpen() async {
  //   const AndroidNotificationDetails androidDetails =
  //   AndroidNotificationDetails('app_open_channel', 'App Open Notifications',
  //       importance: Importance.high, priority: Priority.high);
  //
  //   const NotificationDetails platformDetails =
  //   NotificationDetails(android: androidDetails);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Welcome Back!',
  //     'Track your expenses and stay on top of your budget.',
  //     platformDetails,
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _showNotificationOnAppOpen();
    routeToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashBgColour,
      body: Center(
        child: Image.asset(AppImages.imageSplashLogo, fit: BoxFit.cover, width: 40.w,),
      ),
    );
  }
}
