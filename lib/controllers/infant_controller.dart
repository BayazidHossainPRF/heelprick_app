import 'package:get/get.dart';
import '../core/localDB/data_db.dart';
import '../core/localDB/models/heel_prick_blood_infent_model.dart';

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
}
