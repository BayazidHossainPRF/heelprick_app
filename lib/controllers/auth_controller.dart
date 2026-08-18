import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/const/app_secrets.dart';
import '../core/localDB/data_db.dart';
import '../core/localDB/models/user_model.dart';
import '../core/prefs/user_prefs.dart';
import '../core/theme/app_pallete.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  // Observable variables
  final RxString _userId = ''.obs;
  final RxString _password = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _rememberMe = false.obs;
  final RxBool _isPasswordVisible = false.obs;

  // Getters
  String get userId => _userId.value;
  String get password => _password.value;
  bool get isLoading => _isLoading.value;
  bool get rememberMe => _rememberMe.value;
  bool get isPasswordVisible => _isPasswordVisible.value;

  // Setters with update
  set userId(String value) {
    _userId.value = value;
  }

  set password(String value) {
    _password.value = value;
  }

  void toggleLoading() {
    _isLoading.value = !_isLoading.value;
  }

  void toggleRememberMe() {
    _rememberMe.value = !_rememberMe.value;
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  // Validation methods
  bool get isUserIdValid {
    return _userId.value.isNotEmpty;
  }

  bool get isPasswordValid {
    return _password.value.length >= 3;
  }

  bool get isFormValid {
    return isUserIdValid && isPasswordValid;
  }

  // Login method
  Future<void> login() async {
    if (userId.isEmpty) {
      _userId.value = await UserPrefs.get(key: UserEnum.userIdKey);
      _password.value = await UserPrefs.get(key: UserEnum.passwordKey);
    }
    if (!isFormValid) {
      Get.snackbar(
        'Validation Error',
        'Please enter valid User Id and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      toggleLoading();
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      final res = await UserDb.instance.checkUser(
        userId: userId,
        password: password,
      );

      if (res) {
        Get.offAllNamed('/home');
        UserPrefs.set(key: UserEnum.userIdKey, value: userId);
        UserPrefs.set(key: UserEnum.passwordKey, value: password);
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid userId or password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during login: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      toggleLoading();
    }
  }

  // Reset password method
  Future<void> resetPassword() async {
    Get.snackbar(
      'Error',
      'This feature is not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  Future<void> downloadUsers() async {
    toggleLoading();
    final url = Uri.parse('${AppSecrets.host}get_all_staff.php');

    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        for (var item in jsonData) {
          UserModel userModel = UserModel.fromJson(item);

          try {
            await UserDb.instance.createNewUserWithReplace(model: userModel);
          } catch (e) {
            // print('Error inserting user with ID ${userModel.userId}: $e');
          }
        }
        Get.showSnackbar(
          GetSnackBar(
            title: 'Child data download successfully',
            message:
                '${jsonData.length} child data download and inserted to the local database',
            duration: Duration(seconds: 3),
            backgroundColor: AppPallete.acceptColor,
          ),
        );
        // print("Data saved successfully!");
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: 'Child data download failed',
            message:
                'Child data download failed. Status code : ${response.statusCode}',
            duration: Duration(seconds: 3),
            backgroundColor: AppPallete.dangerColor,
          ),
        );
        // print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // print("Exception: $e");
      Get.showSnackbar(
        GetSnackBar(
          title: 'Child data download failed',
          message: 'Exception : $e',
          duration: Duration(seconds: 3),
          backgroundColor: AppPallete.dangerColor,
        ),
      );
    } finally {
      toggleLoading();
    }
  }
}
