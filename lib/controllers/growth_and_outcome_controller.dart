import 'dart:convert';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/localDB/data_db.dart';
import 'package:heel_prick_blood_collection/core/localDB/fields/asset_fields.dart';
import 'package:heel_prick_blood_collection/core/localDB/fields/enrollment_form_field.dart';
import 'package:heel_prick_blood_collection/core/localDB/fields/growth_and_outcome_form_field.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/asset_model.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/enrollment_form_model.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/growth_and_outcome_form_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../core/const/app_secrets.dart';
import '../core/prefs/user_prefs.dart';
import '../core/utils/snackbar.dart';

class GrowthAndOutcomeController extends GetxController {
  static GrowthAndOutcomeController get to => Get.find();

  final RxBool _isLoading = false.obs;
  final RxList<EnrollmentFormModel> _infants = <EnrollmentFormModel>[].obs;

  bool get isLoading => _isLoading.value;
  List<EnrollmentFormModel> get infants => _infants;

  void toggleLoading() {
    _isLoading.value = !_isLoading.value;
  }

  // Future<void> downloadPendingInfantList() async {
  //   toggleLoading();
  //   await Future.delayed(const Duration(seconds: 2));
  //   final url = Uri.parse('${AppSecrets.host}sync_pending_infents.php');
  //   // print('calling api : ${url.toString()}');
  //   try {
  //     final response = await http.get(url);
  //     // print(response.body);
  //     if (response.statusCode == 200) {
  //       _infants.clear();
  //       List<dynamic> jsonData = jsonDecode(response.body);
  //       for (var item in jsonData) {
  //         _infants.add(PendingInfantModel.fromJson(item));
  //       }
  //       Snackbar.show_s(message: '${jsonData.length} Pending infants found');
  //     } else {
  //       // print("Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     Snackbar.show_e(message: 'Exception: $e');
  //   }
  //   toggleLoading();
  // }

  Future<void> backupEnrollmentData() async {
    toggleLoading();
    final enList = await EnrollmentFormDb.instance.readAllNew();
    print('EN : ${enList.length}');
    final url = Uri.parse('${AppSecrets.host}backup_enrollment_form.php');
    try {
      for (EnrollmentFormModel model in enList) {
        final data = model.toJson();
        data.remove(EnrollmentFormField.syncDt);
        final response = await http.post(url, body: jsonEncode(data));
        print(response.body);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 'success') {
            Snackbar.show_s(message: jsonData['message']);
            model = model.copyWith(
              syncDt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            );
            EnrollmentFormDb.instance.updateForm(model);
            await Future.delayed(const Duration(seconds: 1));
          } else {
            Snackbar.show_e(message: jsonData['message']);
          }
        } else {
          // print("Error: ${response.statusCode}");
          Snackbar.show_e(message: 'Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      Snackbar.show_e(message: 'Exception: $e');
    }
    toggleLoading();
  }

  Future<void> backupGrowthData() async {
    toggleLoading();
    final gwList = await GrowthAndOutcomeFormDb.instance.readAllNew();
    print('GW : ${gwList.length}');
    final url = Uri.parse(
      '${AppSecrets.host}backup_growth_and_outcome_form.php',
    );
    try {
      for (GrowthAndOutcomeFormModel model in gwList) {
        final data = model.toJson();
        data.remove(GrowthAndOutcomeFormField.syncDt);
        print('Sending Data: ${data}');
        final response = await http.post(url, body: jsonEncode(data));
        print(response.body);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 'success') {
            Snackbar.show_s(message: jsonData['message']);
            model = model.copyWith(
              syncDt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            );
            GrowthAndOutcomeFormDb.instance.updateForm(model);
            await Future.delayed(const Duration(seconds: 1));
          } else {
            Snackbar.show_e(message: jsonData['message']);
          }
        } else {
          // print("Error: ${response.statusCode}");
          Snackbar.show_e(message: 'Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      Snackbar.show_e(message: 'Exception: $e');
    }
    toggleLoading();
  }

  Future<void> backupSESData() async {
    toggleLoading();
    final assetList = await AssetDb.instance.readAllNew();
    print('Asset : ${assetList.length}');
    final url = Uri.parse(
      '${AppSecrets.host}backup_ses_form.php',
    );
    try {
      for (AssetModel model in assetList) {
        final data = model.toJson();
        data.remove(AssetFields.syncDt);
        // print('Sending Data: ${data}');
        final response = await http.post(url, body: jsonEncode(data));
        // print(response.body);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 'success') {
            Snackbar.show_s(message: jsonData['message']);
            model = model.copyWith(
              syncDt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            );
            AssetDb.instance.updateForm(model);
            await Future.delayed(const Duration(seconds: 1));
          } else {
            Snackbar.show_e(message: jsonData['message']);
          }
        } else {
          // print("Error: ${response.statusCode}");
          Snackbar.show_e(message: 'Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      Snackbar.show_e(message: 'Exception: $e');
    }
    toggleLoading();
  }

  Future<void> fetchTodoGrowthAndOutcome() async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 1));
    print('GF enndata');
    _infants.clear();
    final infantList = await EnrollmentFormDb.instance
        .readAllTodoGrowthAndOutcome();
    print('EN data found : ${infantList.length}');
    _infants.addAll(infantList);
    toggleLoading();
  }

  Future<void> downloadGrowthLastVisit() async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 1));
    final url = Uri.parse(
      '${AppSecrets.host}sync_last_growth_visit.php?tab_code=${UserPrefs.userModel.teamId}',
    );
    print('calling api : ${url.toString()}');
    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          GrowthAndOutcomeFormDb.instance.createNewFormWithReplace(
            model: GrowthAndOutcomeFormModel.fromJson(item),
          );
        }
        Snackbar.show_s(message: '${jsonData.length} Growth and Outcome visit downloaded');
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
