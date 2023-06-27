package com.lifesparktech.walk
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.Manifest
import android.content.pm.PackageManager
import android.os.Handler
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
//   private val scanblechannel = "com.lifespark.walk";
//   private lateinit var channel:MethodChannel


//   @RequiresApi(VERSION_CODES.M)
//   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//     super.configureFlutterEngine(flutterEngine)
//     channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, scanblechannel)
//     channel.setMethodCallHandler({call,result ->
//       if(call.method == "scanForDevices")
//     {
//       scanLeDevice()
//     }
//     else {
//       result.notImplemented()
//     }
//     })
//   }
//   private fun requestPermissions() {
//     val bluetoothPermission = android.Manifest.permission.BLUETOOTH
//     val bluetoothAdminPermission = android.Manifest.permission.BLUETOOTH_ADMIN
//     val locationPermission = android.Manifest.permission.ACCESS_FINE_LOCATION

//     val permissions = arrayOf(bluetoothPermission, bluetoothAdminPermission, locationPermission)

//     ActivityCompat.requestPermissions(this, permissions, 1)
//   }

//   @RequiresApi(VERSION_CODES.M)
//   override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
//     if (requestCode == 1) {
//       var allPermissionsGranted = true

//       for (result in grantResults) {
//         if (result != PackageManager.PERMISSION_GRANTED) {
//           allPermissionsGranted = false
//           break
//         }
//       }
//       if (allPermissionsGranted) {
//         scanLeDevice()

//       } else {
//         requestPermissions()

//       }
//     }
//   }
//   @RequiresApi(VERSION_CODES.M)
//   private fun scanLeDevice() {

//     val bluetoothManager: BluetoothManager = getSystemService(BluetoothManager::class.java)

//     val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.getAdapter()

//      val bluetoothLeScanner = bluetoothAdapter?.bluetoothLeScanner
//      var scanning = false
//      val handler = Handler()
//      val SCAN_PERIOD: Long = 10000

//     val permissions = arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION , android.Manifest.permission.BLUETOOTH ,android.Manifest.permission.BLUETOOTH_ADMIN , android.Manifest.permission.BLUETOOTH_SCAN)

//     if(
//       checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
//     )
//     {
//       ActivityCompat.requestPermissions(this, permissions, 1);
//     }
//     else
//     {
//       if (!scanning) { // Stops scanning after a pre-defined scan period.
//         handler.postDelayed({
//           scanning = false

//           bluetoothLeScanner?.stopScan(leScanCallback)
//         }, SCAN_PERIOD)
//         scanning = true
//         bluetoothLeScanner?.startScan(leScanCallback)
//       } else {
//         scanning = false
//         bluetoothLeScanner?.stopScan(leScanCallback)
//       }

//     }

//   }
// //  private val leDeviceListAdapter = LeDeviceListAdapter()
//   private var deviceNameList = arrayOf<String>()
//   // Device scan callback.
//   private val leScanCallback: ScanCallback = @RequiresApi(VERSION_CODES.LOLLIPOP)
//   object : ScanCallback() {
//     override fun onScanResult(callbackType: Int, result: ScanResult) {
//       super.onScanResult(callbackType, result)
//       print("Scanning via native")
//     }
//   }

}