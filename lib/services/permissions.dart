import 'package:permission_handler/permission_handler.dart';

/// Request WiFi permissions required for network discovery
/// Returns true if all permissions are granted, false otherwise
Future<bool> requestWifiPermissions() async {
  final permissions = [
    Permission.nearbyWifiDevices,
    Permission.locationWhenInUse, // fallback for Android < 12
  ];

  bool allGranted = true;
  for (final p in permissions) {
    if (!await p.isGranted) {
      final status = await p.request();
      if (!status.isGranted) {
        allGranted = false;
      }
    }
  }

  return allGranted;
}
