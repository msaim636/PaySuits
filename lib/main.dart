import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/theme/dark_theme.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/app_constants.dart';

import 'controller/localization_controller.dart';
import 'controller/theme_controller.dart';
import 'helper/get_di.dart' as di;
import 'helper/native_payment_webview.dart';
import 'helper/route_helper.dart';
import 'util/messages.dart';

// Main file to run the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NativePaymentWebView.initListener();
  const firebaseOptions = FirebaseOptions(
    apiKey: AppConstants.apiKey,
    appId: AppConstants.appId,
    messagingSenderId: AppConstants.messagingSenderId,
    projectId: AppConstants.projectId,
    storageBucket: AppConstants.storageBucket,
    iosBundleId: AppConstants.iosBundleId,
  );

  if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    await Firebase.initializeApp();
  }

  await di.init();
  Map<String, Map<String, String>> languages = await di.init();

  // Ensure LocalizationController is loaded before running the app
  LocalizationController localizationController =
      Get.find<LocalizationController>();
  await localizationController.loadCurrentLanguage();

  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.APP_NAME,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              theme: themeController.darkTheme ? dark : light,
              locale: localizeController.locale,
              initialRoute: RouteHelper.getInitialRoute(),
              getPages: RouteHelper.routes,
              defaultTransition: Transition.topLevel,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode!,
                AppConstants.languages[0].countryCode,
              ),
              transitionDuration: const Duration(milliseconds: 500),
              builder: (context, child) {
                return Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder: (context) => SafeArea(
                        top: false,
                        bottom: Platform.isAndroid,
                        child: child!,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
