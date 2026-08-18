import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/const/app_secrets.dart';
import '../core/localDB/data_db.dart';
import '../core/localDB/models/heel_prick_blood_infent_model.dart';
import '../core/localDB/models/user_model.dart';
import '../core/prefs/user_prefs.dart';
import '../core/theme/app_pallete.dart';
import '../core/utils/snackbar.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  // Observable lists
  // final RxList<MemberModel> _members = <MemberModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool _isChildDownloading = false.obs;
  final RxBool _isExporting = false.obs;
  final RxBool _isMerging = false.obs;
  final RxBool _isDataUploading = false.obs;
  final RxBool _newQuery = false.obs;
  final RxString _lastDownloadDate = ''.obs;
  final RxInt _totalChild = (-1).obs;
  final RxInt _todoChild = (-1).obs;
  // Statistics observables
  final RxString _totalCompleted = ''.obs;
  final RxString _totalMothers = ''.obs;
  final RxString _totalChildren = ''.obs;
  final RxInt _totalVillages = 0.obs;
  final RxInt _pendingUpdates = 0.obs;
  final RxString _appVersion = ''.obs;
  UserModel _currentUser = UserModel();
  final RxString _totalEn = ''.obs;
  final RxString _syncEn = ''.obs;
  final RxString _totalAs = ''.obs;
  final RxString _syncAs = ''.obs;
  final RxString _totalGf = ''.obs;
  final RxString _syncGf = ''.obs;

  // Getter methods
  String get totalCompleted => _totalCompleted.value;
  String get totalMothers => _totalMothers.value;
  String get totalChildren => _totalChildren.value;
  int get totalVillages => _totalVillages.value;
  int get pendingUpdates => _pendingUpdates.value;
  bool get isExporting => _isExporting.value;
  bool get isMerging => _isMerging.value;
  bool get isDataUploading => _isDataUploading.value;
  bool get newQuery => _newQuery.value;

  bool get isChildDownloading => _isChildDownloading.value;
  UserModel get currentUser => _currentUser;
  String get lastDownloadDate => _lastDownloadDate.value;
  int get totalChild => _totalChild.value;
  int get todoChild => _todoChild.value;
  String get appVersion => _appVersion.value;
  String get totalEn => _totalEn.value;
  String get syncEn => _syncEn.value;
  String get totalAs => _totalAs.value;
  String get syncAs => _syncAs.value;
  String get totalGf => _totalGf.value;
  String get syncGf => _syncGf.value;

  // Initialize with sample data (replace with actual data loading)
  @override
  void onInit() {
    super.onInit();
    calculateStatistics();
    getUser();
    getAppVersion();
    fetchSummary();
  }

  void getUser() async {
    isLoading.value = true;
    _currentUser = (await UserPrefs.getUser());
    isLoading.value = false;
  }

  Future<void> downloadScreeningList() async {
    _isChildDownloading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    // final  = await UserPrefs.get(key: UserEnum.userIdKey);
    final url = Uri.parse('${AppSecrets.host}sync_heel_prick_infent_data.php');
    // print('calling api : ${url.toString()}');

    try {
      final response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        for (var item in jsonData) {
          HeelPrickBloodInfantModel heelPrickBloodInfantModel =
              HeelPrickBloodInfantModel.fromJson(item);
          heelPrickBloodInfantModel = heelPrickBloodInfantModel.copyWith(
            infantId: heelPrickBloodInfantModel.infantId,
            syncDt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          );
          try {
            await HeelPrickBloodInfantDb.instance.createNewFormWithReplace(
              model: heelPrickBloodInfantModel,
            );
          } catch (e) {
            Snackbar.show_e(
              message:
                  'Error inserting infant enrollment with ID ${heelPrickBloodInfantModel.infantId}: $e',
              durationInSecond: 2,
            );
            // print(
            //   'Error inserting infant enrollment with ID ${heelPrickBloodInfantModel.infantId}: $e',
            // );
          }
        }
        await UserPrefs.set(
          key: UserEnum.lastDataDownload,
          value: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );
        calculateStatistics();
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
    }
    _isChildDownloading.value = false;
  }

  void exportDbFile() async {
    _isExporting.value = true;
    Get.snackbar(
      'Export',
      'Exporting data to db file...',
      snackPosition: SnackPosition.BOTTOM,
      // dismissDirection: ,
      backgroundColor: AppPallete.primaryLight,
    );
    try {
      await Future.delayed(const Duration(seconds: 2));
      final path = await DataDb.instance.exportDb();
      Get.showSnackbar(
        GetSnackBar(
          title: 'Data Exported',
          message: 'Data exported to $path',
          duration: Duration(seconds: 3),
          backgroundColor: AppPallete.acceptColor,
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Data Exported Failed',
          message: 'Exception : $e',
          duration: Duration(seconds: 3),
          backgroundColor: AppPallete.dangerColor,
        ),
      );
    }
    _isExporting.value = false;
  }

  void mergeDbFile() async {
    _isExporting.value = true;
    Get.snackbar(
      'Merge',
      'Merging data to db file...',
      snackPosition: SnackPosition.BOTTOM,
      // dismissDirection: ,
      backgroundColor: AppPallete.primaryLight,
    );
    try {
      await Future.delayed(const Duration(seconds: 2));
      await DataDb.instance.restoreDatabase();
      Get.showSnackbar(
        GetSnackBar(
          title: 'Data replaced',
          message: 'Data replaced successfull',
          duration: Duration(seconds: 3),
          backgroundColor: AppPallete.acceptColor,
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Data replaced Failed',
          message: 'Exception : $e',
          duration: Duration(seconds: 3),
          backgroundColor: AppPallete.dangerColor,
        ),
      );
    }
    _isExporting.value = false;
  }

  void calculateStatistics() async {
    // _totalCompleted.value = await LinkageLogDb.instance.countLinkageLogs();
    // _totalMothers.value = await LinkageLogDb.instance.countValidMotherLogs();
    _totalChild.value = await HeelPrickBloodInfantDb.instance.countForms();
    _todoChild.value = await HeelPrickBloodInfantDb.instance.todoCountForms();
    // // await InfantEnrollmentDb.instance.countTodoChild() ?? 0;

    // _lastDownloadDate.value = await UserPrefs.get(
    //   key: UserEnum.lastDataDownload,
    // );

    // print('Total child: ${_totalChild.value}');

    // // Calculate total children
    // _totalChildren.value = _children.length;

    // // Calculate total members (mothers + children)
    // _totalMembers.value = _totalMothers.value + _totalChildren.value;

    // // Calculate completed mothers (example: mothers with complete data)
    // // You can define your own completion criteria
    // _completedMothers.value = _mothers.where((mother) {
    //   return mother.phoneNumber != null &&
    //          mother.phoneNumber!.isNotEmpty &&
    //          mother.children.isNotEmpty;
    // }).length;

    // // Calculate unique villages
    // final villages = _mothers.map((m) => m.villageName).whereType<String>().toSet();
    // _totalVillages.value = villages.length;

    // // Calculate pending updates (example)
    // _pendingUpdates.value = _mothers.length - _completedMothers.value;
  }

  // Refresh data
  Future<void> refreshData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    calculateStatistics();
    update();
  }

  Future<void> uploadFollowupToServer() async {
    _isDataUploading.value = true;
    final newFollowups = await HeelPrickBloodCollectionFormDb.instance
        .readAllNew();
    final Uri url = Uri.parse(
      '${AppSecrets.host}upload_heel_prick_blood_collection_data.php',
    );
    // final header = getHeader();
    try {
      for (final newFollowup in newFollowups) {
        // print('Uploading form with ID: ${newFollowup.endDate}');
        final response = await http.post(
          url,
          body: json.encode(newFollowup.toJson()),
        );
        // print(response.body);
        final resData = json.decode(response.body);
        if (resData['status'] == 'success') {
          Snackbar.show_s(
            message: resData['message'].toString(),
            durationInSecond: 2,
          );
          final upFF = newFollowup.copyWith(
            syncDt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          );
          await HeelPrickBloodCollectionFormDb.instance.updateForm(upFF);
        } else {
          Snackbar.show_e(
            message: resData['message'].toString(),
            durationInSecond: 1,
          );
        }
      }
      Snackbar.show_s(
        message: '${newFollowups.length} form data upload completed',
        durationInSecond: 2,
      );
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      // print('Error fetching products: $e');
    } finally {
      _isDataUploading.value = false;
    }
  }

  Future<void> getNewQuery() async {
    _newQuery.value = true;
    try {
      await DataDb.instance.executeRawQuery(
        query: '''
            alter TABLE tbl_12_month_follow_up add COLUMN q1202bSP TEXT null;
            alter TABLE tbl_12_month_follow_up add COLUMN lat TEXT null;
            alter TABLE tbl_12_month_follow_up add COLUMN lng TEXT null;
            alter TABLE tbl_admission_details add COLUMN q804a TEXT null;
            alter TABLE tbl_infant_enrollment add COLUMN Mobile TEXT null;
          ''',
      );
      // print('New Query run success');
    } catch (e) {
      // print('New query Exception');
      // print(e.toString());
    }
    _newQuery.value = false;
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion.value = packageInfo.version;
  }

  Future<String?> checkAppVersion() async {
    final Uri url = Uri.parse('${AppSecrets.host}check_update.php');
    // final header = getHeader();
    try {
      final response = await http.get(url);
      // print(response.body);
      final resData = json.decode(response.body);
      if (resData['version'] == _appVersion.value) {
        Snackbar.show_s(
          message: 'Your app is already updated',
          durationInSecond: 2,
        );
        return null;
      } else {
        return resData['apk_url'];
      } // checkNewCount();
    } catch (e) {
      // print('Error fetching products: $e');
      Snackbar.show_e(message: 'Ex: $e', durationInSecond: 2);
    }
    return null;
  }

  Future<void> downloadAndInstallApk(String url) async {
    try {
      // print('calling download apk');
      final response = await http.get(Uri.parse(url));
      // print('res find');
      if (response.statusCode == 200) {
        // final dir = await getExternalStorageDirectory();
        Directory downloadsDir = Directory("/storage/emulated/0/Download");
        final file = File('${downloadsDir.path}/update.apk');
        await file.writeAsBytes(response.bodyBytes);
        Snackbar.show_s(
          message: 'অ্যাপ ডাউনলোড করা হয়েছে',
          durationInSecond: 2,
        );

        // await Future.delayed(const Duration(seconds: 2));
        // print('going to open file');
        await OpenFile.open(file.path);
        // print('after file open');
      } else {
        throw Exception();
      }
    } catch (e) {
      Snackbar.show_e(message: 'অ্যাপ ডাউনলোড করা যায়নি', durationInSecond: 2);
    }
  }

  void fetchSummary() async {
    final data = await EnrollmentFormDb.instance.getSyncStatistic();
    _totalEn.value = data[0]['total'].toString();
    _syncEn.value = data[0]['sync'].toString();
    _totalAs.value = data[1]['total'].toString();
    _syncAs.value = data[1]['sync'].toString();
    _totalGf.value = data[2]['total'].toString();
    _syncGf.value = data[2]['sync'].toString();
  }
}
