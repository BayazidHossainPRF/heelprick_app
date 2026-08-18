import 'dart:convert';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/localDB/data_db.dart';
import 'package:heel_prick_blood_collection/core/utils/snackbar.dart';
import 'package:http/http.dart' as http;
import '../core/const/app_secrets.dart';
import '../core/localDB/models/pending_infant_model.dart';
import '../core/prefs/user_prefs.dart';

class PendingInfantController extends GetxController {
  static PendingInfantController get to => Get.find();

  final RxBool _isLoading = false.obs;
  final RxList<PendingInfantModel> _infants = <PendingInfantModel>[].obs;

  bool get isLoading => _isLoading.value;
  List<PendingInfantModel> get infants => _infants;

  void toggleLoading() {
    _isLoading.value = !_isLoading.value;
  }

  Future<void> downloadPendingInfantList() async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 2));
    final url = Uri.parse('${AppSecrets.host}sync_pending_infents.php');
    // print('calling api : ${url.toString()}');
    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200) {
        _infants.clear();
        List<dynamic> jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          _infants.add(PendingInfantModel.fromJson(item));
        }
        Snackbar.show_s(message: '${jsonData.length} Pending infants found');
      } else {
        // print("Error: ${response.statusCode}");
      }
    } catch (e) {
      Snackbar.show_e(message: 'Exception: $e');
    }
    toggleLoading();
  }

  Future<void> sendRequestForEnrollment(PendingInfantModel model) async {
    toggleLoading();
    // await Future.delayed(const Duration(seconds: 2));
    final data = {
      'baby_pid': model.babyPid,
      'user_id': UserPrefs.userModel.userId,
      'infant_id': model.infantId,
    };
    print(data);
    UserPrefs.userModel.userId;
    final url = Uri.parse('${AppSecrets.host}request_for_enrollment.php');
    // print('calling api : ${url.toString()}');
    try {
      final response = await http.post(url, body: jsonEncode(data));
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          Snackbar.show_s(message: 'Request for enrollment sent successfully');
          await PendingInfantDb.instance.create(model: model);
          _infants.remove(model);
          toggleLoading();
          await Future.delayed(const Duration(seconds: 1));
          return;
        } else {
          Snackbar.show_e(message: jsonData['message']);
        }
      } else {
        // print("Error: ${response.statusCode}");
        Snackbar.show_e(message: 'Error: ${response.statusCode}');
      }
    } catch (e) {
      Snackbar.show_e(message: 'Exception: $e');
    }
    toggleLoading();
  }

  Future<void> fetchTodoEnrollmentList() async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 1));
    _infants.clear();
    final infantList = await PendingInfantDb.instance.readTodoEnrollment();
    _infants.addAll(infantList);
    toggleLoading();
  }
}
