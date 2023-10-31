import 'dart:ui';

import 'package:android_studyjams/locator.dart';
import 'package:android_studyjams/utils/localization.g.dart';
import 'package:android_studyjams/utils/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initDependencies();
  await locator<FirebaseAnalytics>().logAppOpen();

  usePathUrlStrategy();
  runApp(const MyApp());

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: AppRoutes.onGenerateTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      unknownRoute: AppRoutes.fallback,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.home,
      translations: Localization(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
    );
  }
}
