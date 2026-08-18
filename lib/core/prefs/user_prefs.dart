import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../localDB/models/user_model.dart';

enum UserEnum {
  userPrefsKey,
  userIdKey,
  passwordKey,
  visitDay,
  lastDataDownload,
}

class UserPrefs {
  static UserModel userModel = UserModel();
  static String getCluster() {
    if (userModel.userId == null || userModel.userId!.isEmpty) {
      getUser();
      return userModel.userId.toString();
    } else {
      return userModel.userId.toString();
    }
  }

  static Future<void> setUser({required Map<String, dynamic> userJson}) async {
    userModel = UserModel.fromJson(userJson);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(UserEnum.userPrefsKey.name, jsonEncode(userModel.toJson()));
  }

  static Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
  //  print('get user from prefs');
    final jsonStr = prefs.getString(UserEnum.userPrefsKey.name) ?? '';
  //  print('json str : $jsonStr');
    final userJson = jsonDecode(jsonStr);
  //  print('user json : $userJson');
    userModel = UserModel.fromJson(userJson);
    return userModel;
  }

  static Future<void> set({
    required UserEnum key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key.name, value);
  }

  static Future<String> get({required UserEnum key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.name) ?? '';
  }
}
