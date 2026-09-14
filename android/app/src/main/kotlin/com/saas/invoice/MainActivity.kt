package com.theme29.paysuite

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.theme29.paysuite/payment"
    private val ENGINE_ID = "my_engine"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ CACHE ENGINE (THIS WAS MISSING)
        FlutterEngineCache
            .getInstance()
            .put(ENGINE_ID, flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "openWebView") {

                val url = call.argument<String>("url") ?: ""
                val name = call.argument<String>("name") ?: "Payment"

                val intent = Intent(this, PaymentWebViewActivity::class.java)
                intent.putExtra(PaymentWebViewActivity.EXTRA_URL, url)
                intent.putExtra(PaymentWebViewActivity.EXTRA_NAME, name)

                startActivity(intent)
                result.success(null)

            } else {
                result.notImplemented()
            }
        }
    }
}
