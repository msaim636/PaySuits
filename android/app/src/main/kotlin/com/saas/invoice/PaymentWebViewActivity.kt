package com.theme29.paysuite

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngineCache

class PaymentWebViewActivity : AppCompatActivity() {

    companion object {
        const val EXTRA_URL = "extra_url"
        const val EXTRA_NAME = "extra_name"
        const val CHANNEL = "com.theme29.paysuite/payment"
    }

    private var paymentChannel: MethodChannel? = null
    private var paymentSent = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // FlutterEngine
        val flutterEngine = FlutterEngineCache.getInstance().get("my_engine")
        if (flutterEngine != null) {
            paymentChannel =
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        }

        // Root Layout
        val container = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            fitsSystemWindows = true
        }

        // Toolbar
        val toolbar = Toolbar(this).apply {
            setBackgroundColor(Color.WHITE)
            elevation = 0f
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            toolbar.setOnApplyWindowInsetsListener { v, insets ->
                v.setPadding(
                    v.paddingLeft,
                    insets.systemWindowInsetTop,
                    v.paddingRight,
                    v.paddingBottom
                )
                insets
            }
        }

        val title = intent.getStringExtra(EXTRA_NAME) ?: "Payment"
        val titleView = TextView(this).apply {
            text = title
            setTextColor(Color.BLACK)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 18f)
            gravity = Gravity.CENTER
            layoutParams = Toolbar.LayoutParams(
                Toolbar.LayoutParams.WRAP_CONTENT,
                Toolbar.LayoutParams.WRAP_CONTENT,
                Gravity.CENTER
            )
        }

        toolbar.addView(titleView)
        toolbar.setNavigationIcon(android.R.drawable.ic_menu_close_clear_cancel)
        toolbar.setNavigationOnClickListener {
            if (!paymentSent) {
                sendResult("cancel")
            }
            finish()
        }

        container.addView(toolbar)

        // WebView
        val webView = WebView(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                0,
                1f
            )
            settings.javaScriptEnabled = true
            settings.domStorageEnabled = true

            webViewClient = object : WebViewClient() {
                override fun onPageFinished(view: WebView?, url: String?) {
                    super.onPageFinished(view, url)
                    if (paymentSent || url == null) return

                    // -------------------------
                    // STRIPE SUCCESS / CANCEL
                    // -------------------------
                    if (
                        (url.contains("/my-plans") && url.contains("success=")) ||
                        (url.contains("/billing-history") && url.contains("success="))
                    ) {
                        sendResult("success")
                        finish()
                        return
                    }

                    if (
                        (url.contains("/my-plans") && url.contains("cancel=")) ||
                        (url.contains("/billing-history") && url.contains("cancel="))
                    ) {
                        sendResult("cancel")
                        finish()
                        return
                    }

                    // -------------------------
                    // PAYPAL SUCCESS
                    // -------------------------
                    if (
                        url.contains("PayerID=") ||
                        url.contains("key=")
                    ) {
                        sendResult("success")
                        finish()
                        return
                    }

                    // -------------------------
                    // PAYPAL CANCEL
                    // -------------------------
                    if (
                        url.contains("cancel=true") ||
                        url.contains("paypal_cancel")
                    ) {
                        sendResult("cancel")
                        finish()
                    }
                }
            }
        }

        container.addView(webView)
        setContentView(container)

        val url = intent.getStringExtra(EXTRA_URL) ?: ""
        webView.loadUrl(url)
    }

    private fun sendResult(status: String) {
        if (paymentSent) return
        paymentSent = true

        paymentChannel?.invokeMethod(
            "paymentResult",
            mapOf("status" to status)
        )
    }
}
