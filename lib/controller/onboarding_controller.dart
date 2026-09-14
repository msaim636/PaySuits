import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController implements GetxService {
  final PageController pageController = PageController();
  var currentIndex = 0.obs;

  // next page method
  void nextPage() {
    if (currentIndex.value < 6) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  // skip method
  void skip() {
    pageController.animateToPage(
      6,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  // set current index
  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  // mark onboarding as complete
  Future<void> markOnboardingAsComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  // check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingComplete') ?? false;
  }

  // dispose
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
