import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysuite/theme/light_theme.dart';
import 'package:paysuite/util/dimensions.dart';
import 'package:paysuite/util/styles.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermConditionWidget extends StatelessWidget {
  const TermConditionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'agree_key'.tr,
        style: googleSansFlexRegular.copyWith(
          color: LightAppColor.cardColor,
          fontSize: Dimensions.FONT_SIZE_DEFAULT - 1,
        ),
        children: [
          TextSpan(
            text: 'terms_key'.tr,
            style: googleSansFlexMedium.copyWith(
              color: LightAppColor.lightGreen,
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
            ),

            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(
                  () => const AppWebViewScreen(
                    title: 'Terms & Conditions',
                    url:
                        'https://paysuite.theme29.com/description/terms-condition',
                  ),
                );
              },
          ),
          TextSpan(
            text: 'and_key'.tr,
            style: googleSansFlexRegular.copyWith(
              color: LightAppColor.cardColor,
              fontSize: Dimensions.FONT_SIZE_DEFAULT - 1,
            ),
          ),
          TextSpan(
            text: 'privacy_key'.tr,
            style: googleSansFlexMedium.copyWith(
              color: LightAppColor.lightGreen,
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(
                  () => const AppWebViewScreen(
                    title: 'Privacy Policy',
                    url:
                        'https://paysuite.theme29.com/description/privacy-policy',
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}

class AppWebViewScreen extends StatelessWidget {
  final String title;
  final String url;

  const AppWebViewScreen({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title, isBackButtonExist: true),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
