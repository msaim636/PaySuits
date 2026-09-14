import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';

class NativePaymentWebView {
  static const MethodChannel _channel = MethodChannel(
    'com.theme29.paysuite/payment',
  );

  static bool _initialized = false;
  static bool _handled = false;

  static void initListener() {
    if (_initialized) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'paymentResult') {
        if (_handled) return;
        _handled = true;

        final status = call.arguments['status'];

        if (status == 'success') {
          showCustomSnackBar("Payment Success");

          Get.offAllNamed(RouteHelper.getNavbarRoute());
        }
        if (status == 'cancel') {
          showCustomSnackBar("Payment Cancel");

          Get.back();
        }
      }
    });
  }

  static Future<void> open(String url, String name) async {
    _handled = false;
    await _channel.invokeMethod('openWebView', {'url': url, 'name': name});
  }
}
