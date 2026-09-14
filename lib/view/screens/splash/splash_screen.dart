import 'package:flutter_svg/svg.dart';
import 'package:paysuite/controller/auth_controller.dart';
import 'package:paysuite/controller/onboarding_controller.dart';
import 'package:paysuite/controller/permission_controller.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/view/base/custom_body_design.dart';
import 'package:paysuite/view/screens/notification/widget/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/settings_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NotificationServices _notificationServices = NotificationServices();
  @override
  void initState() {
    _notificationServices.isRefreshToken();
    _notificationServices.getDeviceToken().then((token) {
      update(token);
    });
    _navigate();

    super.initState();
  }

  // navigate to dashboard or login screen
  void _navigate() async {
    final onboardingController = Get.find<OnboardingController>();
    final bool isOnboardingComplete = await onboardingController
        .isOnboardingComplete();

    Future.delayed(const Duration(seconds: 2), () {
      if (isOnboardingComplete) {
        if (Get.find<AuthController>().isLoggedIn() &&
            Get.find<AuthController>().isKeepMeLoggedIn()) {
          Get.offNamed(RouteHelper.getNavbarRoute());
        } else {
          Get.offNamed(RouteHelper.getLoginRoute());
        }
      } else {
        Get.offNamed(RouteHelper.getOnboardingRoute());
      }
    });
    Get.find<SettingsController>().getCompanySettings();
  }

  // //create device token
  Future<void> update(String token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('deviceToken', token);
    print('Device Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    // check if user is logged in
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<PermissionController>().getPermissionInfo();
    }

    return Scaffold(
      body: CustomBody(
        mainWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: SvgPicture.asset(
                  Images.splashLogo,
                  height: 250,
                  width: 250,
                  // ignore: deprecated_member_use
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
