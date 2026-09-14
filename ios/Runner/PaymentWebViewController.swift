import UIKit
import WebKit
import Flutter

final class PaymentWebViewController: UIViewController, WKNavigationDelegate {

    var urlString: String?
    var pageTitle: String?

    private var webView: WKWebView!
    private var paymentSent = false
    private var paymentChannel: FlutterMethodChannel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupChannel()
        setupUI()
        startPayment()
    }

    private func setupChannel() {
        if let flutterVC = UIApplication.shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
            .first as? FlutterViewController {

            paymentChannel = FlutterMethodChannel(
                name: "com.theme29.paysuite/payment",
                binaryMessenger: flutterVC.binaryMessenger
            )
        }
    }

    private func setupUI() {
        // ---------------- Toolbar ----------------
        let toolbar = UIView()
        toolbar.backgroundColor = .white
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)

        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 56)
        ])

        let titleLabel = UILabel()
        titleLabel.text = pageTitle ?? "Payment"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toolbar.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor)
        ])

        let closeBtn = UIButton(type: .system)
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        toolbar.addSubview(closeBtn)
        NSLayoutConstraint.activate([
            closeBtn.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 16),
            closeBtn.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            closeBtn.widthAnchor.constraint(equalToConstant: 36),
            closeBtn.heightAnchor.constraint(equalToConstant: 36)
        ])

        // ---------------- WebView ----------------
        createWebView()
    }

    private func createWebView() {
        paymentSent = false 

        // Clear cookies before creating new WebView
        WKWebsiteDataStore.default().removeData(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
            modifiedSince: Date(timeIntervalSince1970: 0)
        ) { [weak self] in
            guard let self = self else { return }

            let config = WKWebViewConfiguration()
            config.websiteDataStore = .nonPersistent()
            config.preferences.javaScriptEnabled = true

            self.webView?.removeFromSuperview()
            self.webView = WKWebView(frame: .zero, configuration: config)
            self.webView.navigationDelegate = self
            self.webView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.webView)

            NSLayoutConstraint.activate([
                self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 56),
                self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])

            // Load URL after WebView is fresh
            self.startPayment()
        }
    }

private func startPayment() {
    paymentSent = false   // reset

    guard let urlStr = urlString,
          let url = URL(string: urlStr) else {
        print("❌ Payment URL is invalid")
        return
    }

    guard let webView = self.webView else {
        print("❌ WebView is nil")
        return
    }

    DispatchQueue.main.async {
        webView.load(URLRequest(url: url))
    }
}



    @objc private func closeWebView() {
        sendResultOnce(status: "cancel")
        dismiss(animated: true)
    }

    // ---------------- Navigation Delegate ----------------
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let currentUrl = webView.url?.absoluteString else { return }
        if paymentSent { return }

        // ---------------- Stripe / Internal success ----------------
        if (currentUrl.contains("/my-plans") && currentUrl.contains("success=")) ||
           (currentUrl.contains("/billing-history") && currentUrl.contains("success=")) {

            sendResultOnce(status: "success")
            return
        }

        // ---------------- Stripe / Internal cancel ----------------
        if (currentUrl.contains("/my-plans") && currentUrl.contains("cancel=")) ||
           (currentUrl.contains("/billing-history") && currentUrl.contains("cancel=")) {

            sendResultOnce(status: "cancel")
            return
        }

        // ---------------- PayPal success ----------------
        if currentUrl.contains("key=") || currentUrl.contains("PayerID=") {
            sendResultOnce(status: "success")
            return
        }

        // ---------------- PayPal cancel ----------------
        if currentUrl.contains("cancel=true") || currentUrl.contains("paypal_cancel") {
            sendResultOnce(status: "cancel")
            return
        }
    }

    // ---------------- Support for _blank links (Stripe 3DS / PayPal) ----------------
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

    // ---------------- Helper ----------------
    private func sendResultOnce(status: String) {
        if paymentSent { return }
        paymentSent = true
        paymentChannel?.invokeMethod("paymentResult", arguments: ["status": status])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)
        }
    }
}
