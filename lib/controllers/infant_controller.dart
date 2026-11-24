import 'dart:convert';

import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/asset_model.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/enrollment_form_model.dart';
import 'package:http/http.dart' as http;
import '../core/const/app_secrets.dart';
import '../core/localDB/data_db.dart';
import '../core/localDB/models/heel_prick_blood_infent_model.dart';
import '../core/prefs/user_prefs.dart';
import '../core/utils/snackbar.dart';

class InfantController extends GetxController {
  static InfantController get to => Get.find();

  final RxBool _isLoading = false.obs;
  final RxList<HeelPrickBloodInfantModel> _screenings =
      <HeelPrickBloodInfantModel>[].obs;

  bool get isLoading => _isLoading.value;
  List<HeelPrickBloodInfantModel> get screenings => _screenings;

  void toggleLoading() {
    _isLoading.value = !_isLoading.value;
  }

  void fetchTodoInfants(String listType) async {
    toggleLoading();
    screenings.clear();
    final List<HeelPrickBloodInfantModel> infantList =
        await HeelPrickBloodInfantDb.instance.readTodoFormsByVisitType(
          listType: listType,
        );
    _screenings.assignAll(infantList);
    // print('decoded list : ${infantList.length}');
    toggleLoading();
  }

  void fetchDoneInfants() async {
    toggleLoading();
    screenings.clear();
    final List<HeelPrickBloodInfantModel> infantList =
        await HeelPrickBloodInfantDb.instance.readDoneForms();
    _screenings.assignAll(infantList);
    toggleLoading();
  }

  void fetchRefusedInfants() async {
    toggleLoading();
    screenings.clear();
    final List<HeelPrickBloodInfantModel> infantList =
        await HeelPrickBloodInfantDb.instance.readRefusedForms();
    _screenings.assignAll(infantList);
    toggleLoading();
  }

  Future<void> downloadEnrollmentData() async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 1));
    final url = Uri.parse(
      '${AppSecrets.host}sync_enrollment_data.php?tab_code=${UserPrefs.userModel.teamId}',
    );
    // print('calling api : ${url.toString()}');
    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          EnrollmentFormDb.instance.createNewFormWithReplace(
            model: EnrollmentFormModel.fromJson(item),
          );
        }
        Snackbar.show_s(message: '${jsonData.length} Enrollment infants downloaded');
      } else {
        // print("Error: ${response.statusCode}");
        Snackbar.show_e(message: 'Error: ${response.statusCode}');
      }
    } catch (e) {
      Snackbar.show_e(message: 'Exception: $e');
    }
    toggleLoading();
  }


  Future<void> downloadSESData() async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 1));
    final url = Uri.parse(
      '${AppSecrets.host}sync_ses_data.php?tab_code=${UserPrefs.userModel.teamId}',
    );
    // print('calling api : ${url.toString()}');
    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          AssetDb.instance.createNewFormWithReplace(
            model: AssetModel.fromJson(item),
          );
        }
        Snackbar.show_s(message: '${jsonData.length} Asset form downloaded');
      } else {
        // print("Error: ${response.statusCode}");
        Snackbar.show_e(message: 'Error: ${response.statusCode}');
      }
    } catch (e) {
      Snackbar.show_e(message: 'Exception: $e');
    }
    toggleLoading();
  }
}
