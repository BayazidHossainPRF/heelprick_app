import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  
  // Get unique device identifier
  static Future<String> getDeviceId() async {
    try {
      if (kIsWeb) {
        return await _getWebDeviceId();
      } else if (Platform.isAndroid) {
        return await _getAndroidDeviceId();
      } else if (Platform.isIOS) {
        return await _getIosDeviceId();
      } else if (Platform.isWindows) {
        return await _getWindowsDeviceId();
      } else if (Platform.isMacOS) {
        return await _getMacOSDeviceId();
      } else if (Platform.isLinux) {
        return await _getLinuxDeviceId();
      }
      return 'unknown-platform';
    } catch (e) {
      return 'error-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  static Future<String> _getAndroidDeviceId() async {
    final androidInfo = await deviceInfo.androidInfo;
    
    // For Android 8.0+ (API 26+), use ANDROID_ID
    // It persists across app reinstalls but resets on factory reset
    return androidInfo.id;
  }

  static Future<String> _getIosDeviceId() async {
    final iosInfo = await deviceInfo.iosInfo;
    
    // identifierForVendor is unique per app/vendor
    // Persists across app reinstalls
    return iosInfo.identifierForVendor ?? 
           'ios-${DateTime.now().millisecondsSinceEpoch}';
  }

  static Future<String> _getWebDeviceId() async {
    // For web, we need to generate/store our own ID
    return await _getOrCreateLocalId('web_device_id');
  }

  static Future<String> _getWindowsDeviceId() async {
    final windowsInfo = await deviceInfo.windowsInfo;
    return windowsInfo.deviceId;
  }

  static Future<String> _getMacOSDeviceId() async {
    // macOS doesn't provide a direct device ID
    return await _getOrCreateLocalId('macos_device_id');
  }

  static Future<String> _getLinuxDeviceId() async {
    // Linux doesn't provide a direct device ID
    return await _getOrCreateLocalId('linux_device_id');
  }

  // Generate and store a local ID
  static Future<String> _getOrCreateLocalId(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedId = prefs.getString(key);
    
    if (storedId == null) {
      storedId = 'generated-${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(key, storedId);
    }
    
    return storedId;
  }
}