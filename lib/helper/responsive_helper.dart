// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ResponsiveHelper {
  // Mobile or Web
  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  // Web
  static bool isWeb() {
    return kIsWeb;
  }

  // Mobile
  static bool isMobile(context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  // Tab
  static bool isTab(context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 1300 && size >= 650) {
      return true;
    } else {
      return false;
    }
  }

  // Desktop
  static bool isDesktop(context) {
    final size = MediaQuery.of(context).size.width;
    if (size >= 1300) {
      return true;
    } else {
      return false;
    }
  }
}
