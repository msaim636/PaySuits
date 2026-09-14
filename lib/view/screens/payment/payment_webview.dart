import 'package:flutter/material.dart';
import 'package:paysuite/helper/route_helper.dart';
import 'package:paysuite/view/base/custom_app_bar.dart';
import 'package:paysuite/view/base/custom_snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class PaymentWebView extends StatefulWidget {
  final String checkoutUrl;
  final String name;

  const PaymentWebView({
    super.key,
    required this.checkoutUrl,
    required this.name,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (navReq) {
            final url = navReq.url;
            print('WebView URL: $url');

            // Detect success URL
            if (url.contains('/my-plans') && url.contains('success=') ||
                url.contains('/billing-history') && url.contains('success=')) {
              // Payment successful → navigate home
              showCustomSnackBar('Payment completed successfully');

              // Close WebView
              Get.offAllNamed(RouteHelper.getNavbarRoute());
              return NavigationDecision.prevent;
            }

            // Detect cancel URL if any
            if (url.contains('/my-plans') && url.contains('cancel=') ||
                url.contains('/billing-history') && url.contains('cancel=')) {
              showCustomSnackBar(isError: true, 'Payment cancelled');
              Get.back(); // just close WebView
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.name} Checkout',
        isBackButtonExist: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
