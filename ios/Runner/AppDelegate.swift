import UIKit
import Flutter
import FirebaseCore
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      // Firebase initialization
      FirebaseApp.configure()

      // Flutter Local Notifications setup
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
      }

      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

      GeneratedPluginRegistrant.register(with: self)

      // ---------------------------
      // Native Payment WebView MethodChannel
      // ---------------------------
      if let controller = window?.rootViewController as? FlutterViewController {
          let paymentChannel = FlutterMethodChannel(
              name: "com.theme29.paysuite/payment",
              binaryMessenger: controller.binaryMessenger
          )

          paymentChannel.setMethodCallHandler { [weak self] (call, result) in
              guard let self = self else { return }

              if call.method == "openWebView" {
                  if let args = call.arguments as? [String: Any],
                     let url = args["url"] as? String,
                     let name = args["name"] as? String {

                      let paymentVC = PaymentWebViewController()
                      paymentVC.urlString = url
                      paymentVC.pageTitle = name
                      paymentVC.modalPresentationStyle = .fullScreen
                      controller.present(paymentVC, animated: true)
                      result(nil)
                  } else {
                      result(FlutterError(
                          code: "INVALID_ARGUMENTS",
                          message: "URL or Name missing",
                          details: nil
                      ))
                  }
              } else {
                  result(FlutterMethodNotImplemented)
              }
          }
      }

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)

  }


override func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {

    let urlString = url.absoluteString
    print("🔁 Payment return URL: \(urlString)")

    guard let controller = window?.rootViewController as? FlutterViewController else {
        return false
    }

    let channel = FlutterMethodChannel(
        name: "com.theme29.paysuite/payment",
        binaryMessenger: controller.binaryMessenger
    )

    // 1️⃣ PayPal external redirect takes priority
    if urlString.contains("key=") || urlString.contains("PayerID=") {
        channel.invokeMethod("paymentResult", arguments: ["status": "success"])
        return true
    }
    if urlString.contains("cancel=true") || urlString.contains("paypal_cancel") {
        channel.invokeMethod("paymentResult", arguments: ["status": "cancel"])
        return true
    }

    // 2️⃣ Stripe / WebView internal redirect
    if (urlString.contains("/my-plans") && urlString.contains("success=")) ||
       (urlString.contains("/billing-history") && urlString.contains("success=")) {

        channel.invokeMethod("paymentResult", arguments: ["status": "success"])
        return true
    }

    if (urlString.contains("/my-plans") && urlString.contains("cancel=")) ||
       (urlString.contains("/billing-history") && urlString.contains("cancel=")) {

        channel.invokeMethod("paymentResult", arguments: ["status": "cancel"])
        return true
    }

    return false
}


}
