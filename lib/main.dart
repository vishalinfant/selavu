import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:selavu/models/category_model.dart';
import 'package:selavu/core/constants/app_colours.dart';
import 'package:selavu/core/routes/app_routes.dart';
import 'package:selavu/core/theme/app_theme.dart';
import 'package:selavu/services/notification_service.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';

import 'models/expense_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: blackColour, // 👈 your custom color
      statusBarIconBrightness: Brightness.light, // light or dark icons
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoryAdapter());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, screenType) {
          return Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return SafeArea(
                  child: UpgradeAlert(
                    dialogStyle: UpgradeDialogStyle.material,
                    upgrader: Upgrader(
                      debugLogging: true,
                      minAppVersion: "1.0.2",
                      debugDisplayAlways: true, // show always (dev only)
                      debugDisplayOnce: false,   // show only once (dev only)
                    ),
                    child: MaterialApp.router(
                      title: 'Selavu - Expense Tracker',
                      debugShowCheckedModeBanner: false,
                      routerConfig: appRouter,
                      theme: themeNotifier.appTheme,
                      themeMode: themeNotifier.themeMode,
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}
