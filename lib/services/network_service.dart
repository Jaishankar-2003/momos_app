import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class NetworkService with ChangeNotifier {
  static const String _serviceName = 'momos_app_host';
  static const String _serviceType = '_http._tcp';

  /// 🔐 Shared secret (rotate per session in production)
  static const String _sharedKey = 'momos_secure_key_2026';

  final FlutterNsd _nsd = FlutterNsd();

  bool _isHost = false;
  bool get isHost => _isHost;

  final List<Socket> _clients = [];
  Socket? _hostSocket;
  ServerSocket? _serverSocket;

  // ---------------- SECURITY ----------------
  final encrypt.Key _key = encrypt.Key.fromUtf8(_sharedKey.padRight(32));
  final encrypt.IV _iv = encrypt.IV.fromLength(12);

  Uint8List _encrypt(String message) {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.gcm),
    );
    return encrypter.encrypt(message, iv: _iv).bytes;
  }

  String _decrypt(Uint8List data) {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.gcm),
    );
    return encrypter.decrypt(encrypt.Encrypted(data), iv: _iv);
  }

  // ---------------- WIFI CHECK ----------------
  Future<void> _ensureWifi() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    if (result != ConnectivityResult.wifi) {
      throw Exception('Wi-Fi connection required');
    }
  }

  // ---------------- HOST ----------------
  Future<void> startHost() async {
    await _ensureWifi();
    _isHost = true;

    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);

    // Note: flutter_nsd 1.6.0 only supports client discovery, not server registration
    // Server socket is created but NSD registration is not available in this package version
    // You may need to use platform-specific code or a different package for NSD server functionality

    _serverSocket!.listen((client) {
      _clients.add(client);
      client.listen(
        (data) {
          try {
            final msg = _decrypt(data);
            debugPrint('Client → Host: $msg');
            broadcast('Echo: $msg');
          } catch (e) {
            debugPrint('Error decrypting message: $e');
          }
        },
        onError: (error) {
          debugPrint('Client error: $error');
          _clients.remove(client);
        },
        onDone: () {
          _clients.remove(client);
        },
      );
    });

    notifyListeners();
  }

  // ---------------- CLIENT ----------------
  Future<void> startDiscovery() async {
    await _ensureWifi();

    _nsd.stream.listen(
      (service) async {
        if (_hostSocket != null) {
          return;
        }
        if (service.name == _serviceName &&
            service.hostname != null &&
            service.port != null) {
          try {
            _hostSocket = await Socket.connect(
              service.hostname!,
              service.port!,
            );
            _hostSocket!.listen(
              (data) {
                try {
                  final msg = _decrypt(data);
                  debugPrint('Host → Client: $msg');
                } catch (e) {
                  debugPrint('Error decrypting message: $e');
                }
              },
              onError: (error) {
                debugPrint('Socket error: $error');
                _hostSocket?.destroy();
                _hostSocket = null;
              },
              onDone: () {
                _hostSocket?.destroy();
                _hostSocket = null;
              },
            );
          } catch (e) {
            debugPrint('Error connecting to host: $e');
          }
        }
      },
      onError: (error) {
        debugPrint('Discovery error: $error');
      },
    );

    await _nsd.discoverServices(_serviceType);
  }

  // ---------------- DATA ----------------
  void broadcast(String message) {
    if (!_isHost) return;
    final data = _encrypt(message);
    for (final client in _clients) {
      client.add(data);
    }
  }

  void sendToHost(String message) {
    _hostSocket?.add(_encrypt(message));
  }

  // ---------------- CLEANUP ----------------
  Future<void> stop() async {
    for (final c in _clients) {
      try {
        c.destroy();
      } catch (e) {
        debugPrint('Error destroying client: $e');
      }
    }
    _clients.clear();
    _hostSocket?.destroy();
    _hostSocket = null;
    await _serverSocket?.close();
    _serverSocket = null;

    if (_isHost) {
      // Note: flutter_nsd 1.6.0 doesn't support unregister
      // Server cleanup is handled by closing the server socket
      _isHost = false;
    } else {
      await _nsd.stopDiscovery();
    }

    notifyListeners();
  }
}
