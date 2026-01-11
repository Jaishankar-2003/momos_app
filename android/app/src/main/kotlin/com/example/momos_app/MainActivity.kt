package com.example.momos_app

import android.content.Context
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null

    override fun onResume() {
        super.onResume()
        val wifi =
            applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        multicastLock = wifi.createMulticastLock("momos_multicast")
        multicastLock?.setReferenceCounted(true)
        multicastLock?.acquire()
    }

    override fun onPause() {
        multicastLock?.release()
        super.onPause()
    }
}
