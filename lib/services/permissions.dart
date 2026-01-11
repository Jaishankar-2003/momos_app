import 'package:permission_handler/permission_handler.dart';

Future<void> requestWifiPermissions() async {
  final permissions = [
    Permission.nearbyWifiDevices,
    Permission.locationWhenInUse, // fallback for Android < 12
  ];

  for (final p in permissions) {
    if (!await p.isGranted) {
      await p.request();
    }
  }
}
