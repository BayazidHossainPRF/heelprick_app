import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/pending_infant_model.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../core/localDB/data_db.dart';
import '../../core/localDB/models/asset_model.dart';
import '../../core/prefs/user_prefs.dart';
import '../../core/utils/data_type/number_controller.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/snackbar.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/section_card_widget.dart';
import '../followup_form/widgets/custom_button_with_icon_widget.dart';
import '../user_home/presentation/widgets/question_container_widget.dart';
import 'widgets/custom_form_radio_button_widget.dart';

class AssetFormScreen extends StatefulWidget {
  const AssetFormScreen({super.key});

  @override
  State<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends State<AssetFormScreen> {
  final PendingInfantModel infantModel = Get.arguments as PendingInfantModel;
  AssetModel? formModel;
  int activeSection = 1;
  bool isLoading = false;
  final TextStyle answerTextStyle = const TextStyle(fontSize: 17);

  // Section 1: ID and visit details
  final TextEditingController _q101Controller =
      TextEditingController(); // Study ID
  final TextEditingController _q102Controller = TextEditingController(); // PID
  final TextEditingController _q103Controller = TextEditingController(); // CID
  final TextEditingController _q104Controller =
      TextEditingController(); // Name of Pregnant woman
  final TextEditingController _q105Controller =
      TextEditingController(); // Husband's name
  final TextEditingController _q106Controller =
      TextEditingController(); // Field work area code
  final TextEditingController _q107Controller =
      TextEditingController(); // Date of data collection
  final TextEditingController _q108Controller =
      TextEditingController(); // Time of data collection
  final TextEditingController _q109Controller =
      TextEditingController(); // CHW's code

  // Section 2: Asset list
  final NumberController _q201Controller = NumberController(); // Water source
  final TextEditingController _q202Controller =
      TextEditingController(); // Water source other specify
  final NumberController _q203Controller =
      NumberController(); // Toilet facility
  final TextEditingController _q204Controller =
      TextEditingController(); // Toilet other specify
  final TextEditingController _q205Controller =
      TextEditingController(); // Number of people sleeping
  final TextEditingController _q206Controller =
      TextEditingController(); // Number of sleeping rooms
  final NumberController _q207Controller = NumberController(); // Floor material
  final TextEditingController _q208Controller =
      TextEditingController(); // Floor other specify
  final NumberController _q209Controller = NumberController(); // Wall material
  final TextEditingController _q210Controller =
      TextEditingController(); // Wall other specify
  final NumberController _q211Controller = NumberController(); // Roof material
  final TextEditingController _q212Controller =
      TextEditingController(); // Roof other specify
  final NumberController _q213Controller =
      NumberController(); // Agricultural land
  final NumberController _q215Controller = NumberController(); // Pressure cooker
  final NumberController _q216Controller = NumberController(); // Television
  final NumberController _q217Controller = NumberController(); // Internet
  final NumberController _q218Controller = NumberController(); // Refrigerator
  final NumberController _q219Controller = NumberController(); // Wristwatch
  final NumberController _q220Controller = NumberController(); // Motorcycle
  final NumberController _q221Controller = NumberController(); // Water pump
  final NumberController _q222Controller = NumberController(); // Solar plant
  final NumberController _q223Controller = NumberController(); // Cabinet
  final NumberController _q224Controller = NumberController(); // Sofa
  final NumberController _q225Controller = NumberController(); // Divider
  final TextEditingController _entryDateController = TextEditingController();

  // Form keys
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Asset Form'),
        backgroundColor: AppPallete.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Section 1: ID and visit details
              if (activeSection == 1)
                SectionCardWidget(
                  formKey: _form1Key,
                  title: 'Section 1: ID and Visit Details',
                  icon: Icons.badge_outlined,
                  child: _buildSection1(),
                ),

              // Section 2: Asset list
              if (activeSection == 2)
                SectionCardWidget(
                  formKey: _form2Key,
                  title: 'Section 2: Household Assets',
                  icon: Icons.house_outlined,
                  child: _buildSection2(),
                ),

              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Section 1: ID and visit details
  Widget _buildSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionContainerWidget(
          question: 'Q1. Baby PID(autofill)',
          answer: TextFormField(
            controller: _q101Controller,
            decoration: const InputDecoration(hintText: '3 digits (001-999)'),
            
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Study ID is required';
              return null;
            },
            enabled: false,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q2. Child PID (11 digits)',
          answer: Text(_q102Controller.text, style: answerTextStyle),
        ),
        QuestionContainerWidget(
          question: 'Q3. Mother PID (11 digits)',
          answer: Text(_q103Controller.text, style: answerTextStyle),
        ),
        QuestionContainerWidget(
          question: 'Q4. Child Name',
          answer: Text(_q104Controller.text, style: answerTextStyle),
        ),
        QuestionContainerWidget(
          question: 'Q5. Father Name',
          answer: Text(_q105Controller.text, style: answerTextStyle),
        ),
        QuestionContainerWidget(
          question: 'Q6. Field work area code',
          answer: Text(_q106Controller.text, style: answerTextStyle),
        ),
        QuestionContainerWidget(
          question: 'Q7. Date of data collection (তথ্য সংগ্রহের তারিখ)',
          answer: Text(_q107Controller.text, style: answerTextStyle),
        ),
        QuestionContainerWidget(
          question: 'Q8. Time of data collection (তথ্য সংগ্রহের সময়)',
          answer: Text(_q108Controller.text, style: answerTextStyle),
        ),
        QuestionContainerWidget(
          question: 'Q9. CHW\'s code (কমিউনিটি হেলথ ওয়ার্কারের কোড)',
          answer: TextFormField(
            controller: _q109Controller,
            decoration: const InputDecoration(hintText: '3 digits'),
            maxLength: 3,
            keyboardType: TextInputType.number,
            validator: Validators.requiredValidator,
            enabled: false,
          ),
        ),
      ],
    );
  }

  // Section 2: Asset list
  Widget _buildSection2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Water source
        MyFormRadoButton(
          title:
              'Q201. What is the main source of drinking water for members of the household? \nপরিবারের সদস্যদের প্রধান পানীয় পানির উৎস কী?',
          options: {
            11: 'Piped water (পাইপযুক্ত পানি)',
            12: 'Tube well (টিউবওয়েল)',
            13: 'Rainwater (বৃষ্টির পানি)',
            14: 'Surface water (river/dam/lake/pond/stream/canal) (ভূপৃষ্ঠের জল)',
            15: 'Other (অন্যান্য)',
          },
          controller: _q201Controller,
          specifyKey: 15,
          specifyController: _q202Controller,
          specifyMaxLength: 50,
          spLabel: 'অন্যান্য উৎস হলে, উল্লেখ করুন',
          specifyValidator: (value) {
            if (_q201Controller.value == 15 &&
                (value == null || value.isEmpty)) {
              return 'অন্যান্য উৎস হলে, উল্লেখ করুন';
            }
            return null;
          },
          validator: (value) =>
              (_q201Controller.value == -1) ? "Q201 is required" : null,
          isColumnOptions: true,
        ),

        const SizedBox(height: 16),

        // Toilet facility
        MyFormRadoButton(
          title:
              'Q203. What kind of toilet facility does the woman usually use? \nমহিলারা সাধারণত কোন ধরনের টয়লেট সুবিধা ব্যবহার করেন?',
          options: {
            11: 'Flush or pour flush toilet (ফ্লাশ বা পোর ফ্লাশ টয়লেট)',
            12: 'Pit latrine (পিট ল্যাট্রিন)',
            13: 'No toilet facility/open space (কোনো টয়লেট সুবিধা নেই/খোলা জায়গা)',
            14: 'Other (অন্যান্য)',
          },
          controller: _q203Controller,
          specifyKey: 14,
          specifyController: _q204Controller,
          specifyMaxLength: 50,
          spLabel: 'অন্যান্য টয়লেট সুবিধা হলে, উল্লেখ করুন',
          specifyValidator: (value) {
            if (_q203Controller.value == 14 &&
                (value == null || value.isEmpty)) {
              return 'অন্যান্য টয়লেট সুবিধা হলে, উল্লেখ করুন';
            }
            return null;
          },
          validator: (value) =>
              (_q203Controller.value == -1) ? "Q203 is required" : null,
          isColumnOptions: true,
        ),

        const SizedBox(height: 16),

        // Number of people sleeping
        QuestionContainerWidget(
          question:
              'Q205. How many people usually sleep in the house on a normal night? \nএকটি বাড়িতে রাতে সাধারণত কতজন লোক ঘুমায়?(88=DK)',
          answer: TextFormField(
            controller: _q205Controller,
            decoration: const InputDecoration(hintText: 'Number of people'),
            maxLength: 2,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              int num = int.tryParse(value) ?? 0;
              if (num == 88) return null; // DK allowed
              if (num < 1) return 'Must be at least 1';
              return null;
            },
          ),
        ),

        // Number of sleeping rooms
        QuestionContainerWidget(
          question:
              'Q206. How many rooms in the household are used for sleeping? \nবাড়িতে কতগুলো ঘর ঘুমানোর জন্য ব্যবহৃত হয়?(88=DK)',
          answer: TextFormField(
            controller: _q206Controller,
            decoration: const InputDecoration(hintText: 'Number of rooms'),
            maxLength: 2,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              int num = int.tryParse(value) ?? 0;
              if (num == 88) return null; // DK allowed
              if (num < 1) return 'Must be at least 1';
              return null;
            },
          ),
        ),

        const SizedBox(height: 16),

        // Floor material
        MyFormRadoButton(
          title: 'Q207. Main material of the floor? \nমেঝের প্রধান উপাদান কি?',
          options: {
            11: 'Mud/clay/earth (কাদা/মাটি)',
            12: 'Cement (সিমেন্ট)',
            13: 'Other (অন্যান্য)',
          },
          controller: _q207Controller,
          specifyKey: 13,
          specifyController: _q208Controller,
          specifyMaxLength: 50,
          spLabel: 'মেঝের উপাদান হলে, অন্যান্য উল্লেখ করুন',
          specifyValidator: (value) {
            if (_q207Controller.value == 13 &&
                (value == null || value.isEmpty)) {
              return 'অন্যান্য হলে, উল্লেখ করুন';
            }
            return null;
          },
          validator: (value) =>
              (_q207Controller.value == -1) ? "Q207 is required" : null,
          isColumnOptions: true,
        ),

        const SizedBox(height: 16),

        // Wall material
        MyFormRadoButton(
          title:
              'Q209. Main material of the walls? \nদেয়ালের প্রধান উপাদান কি?',
          options: {
            11: 'Tin (টিন)',
            12: 'Cement/concrete (সিমেন্ট/কংক্রিট)',
            13: 'Burnt bricks (পোড়া ইট)',
            14: 'Galvanized Iron/Metal/asbestos (গ্যালভানাইজড আয়রন/ধাতু/অ্যাসবেস্টস)',
            15: 'Rudimentary walls (bamboo/stone with mud, cardboard, plywood) (প্রাথমিক দেয়াল)',
            16: 'Other (অন্যান্য)',
          },
          controller: _q209Controller,
          specifyKey: 16,
          specifyController: _q210Controller,
          specifyMaxLength: 50,
          spLabel: 'বাইরের দেয়ালের উপাদান  অন্যান্য হলে, উল্লেখ করুন',
          specifyValidator: (value) {
            if (_q209Controller.value == 16 &&
                (value == null || value.isEmpty)) {
              return 'বাইরের দেয়ালের উপাদান  অন্যান্য হলে, উল্লেখ করুন';
            }
            return null;
          },
          validator: (value) =>
              (_q209Controller.value == -1) ? "Q209 is required" : null,
          isColumnOptions: true,
        ),

        const SizedBox(height: 16),

        // Roof material
        MyFormRadoButton(
          title: 'Q211. Main material of the roof? \nছাদের প্রধান উপাদান কি?',
          options: {
            11: 'Tin/Metal (টিন/ধাতু)',
            12: 'Cement (সিমেন্ট)',
            13: 'Rudiment roofing (Plastic/polythene) (প্রাথমিক ছাদ (প্লাস্টিক/পলিথিন))',
            14: 'Others (অন্যান্য)',
          },
          controller: _q211Controller,
          specifyKey: 14,
          specifyController: _q212Controller,
          specifyMaxLength: 50,
          spLabel: 'ছাদের উপাদান অন্যান্য হলে, উল্লেখ করুন',
          specifyValidator: (value) {
            if (_q211Controller.value == 14 &&
                (value == null || value.isEmpty)) {
              return 'ছাদের উপাদান অন্যান্য হলে, উল্লেখ করুন';
            }
            return null;
          },
          validator: (value) =>
              (_q211Controller.value == -1) ? "Q2011 is required" : null,
          isColumnOptions: true,
        ),

        const SizedBox(height: 16),

        // Agricultural land
        MyFormRadoButton(
          title:
              'Q213. Does anyone in the household own agricultural land? \nপরিবারের কারো কি কৃষি জমি আছে?',
          options: {1: 'Yes (হ্যাঁ)', 2: 'No (না)', 8: 'Don\'t know (জানি না)'},
          controller: _q213Controller,
          validator: (value) =>
              (_q213Controller.value == -1) ? "Q2013 is required" : null,
        ),

        const SizedBox(height: 16),

        const Text(
          'Now I would like to ask you about and see your home\'s assets. Do you have...?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          'এখন আমি আপনার বাড়ির সম্পদ সম্পর্কে জিজ্ঞাসা করতে চাই। আপনার কি আছে...?',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 8),

        // Assets list
        _buildAssetRow(
          'Q215. Pressure cooker / mitad (njira maker) \nপ্রেসার কুকার/মিতাদ',
          _q215Controller,
        ),
        _buildAssetRow(
          'Q216. Color / flat screen television (even not working one) \nরঙিন/ফ্ল্যাট স্ক্রিন টেলিভিশন',
          _q216Controller,
        ),
        _buildAssetRow(
          'Q217. Internet connection (mobile 3G/4G/5G or home connection) \nইন্টারনেট সংযোগ',
          _q217Controller,
        ),
        _buildAssetRow(
          'Q218. Refrigerator (even not working one) \nরেফ্রিজারেটর',
          _q218Controller,
        ),
        _buildAssetRow(
          'Q219. Wristwatch or clock (even not working one) \nহাত ঘড়ি বা ঘড়ি',
          _q219Controller,
        ),
        _buildAssetRow(
          'Q220. Motorcycle or scooter (even not working one) \nমোটরসাইকেল বা স্কুটার',
          _q220Controller,
        ),
        _buildAssetRow(
          'Q221. Water pump that is only for the use of this household (even not working one) \nজল পাম্প (শুধুমাত্র এই পরিবারের ব্যবহারের জন্য)',
          _q221Controller,
        ),
        _buildAssetRow(
          'Q222. Solar plant / solar electricity \nসৌর বিদ্যুৎ কেন্দ্র/সৌর বিদ্যুৎ',
          _q222Controller,
        ),
        _buildAssetRow(
          'Q223. Cabinet / Almirah / Wardrobe \nক্যাবিনেট/আলমিরা/ওয়ারড্রোব',
          _q223Controller,
        ),
        _buildAssetRow('Q224. Sofa \nসোফা', _q224Controller),
        _buildAssetRow(
          'Q225. Divider / piece of wood / cardboard / metal to divide a room into different parts/sections \nএকটি ঘরকে বিভিন্ন অংশে বিভক্ত করার জন্য ডিভাইডার/কাঠের টুকরা/কার্ডবোর্ড/ধাতু বিদ্যমান',
          _q225Controller,
        ),
      ],
    );
  }

  Widget _buildAssetRow(String title, NumberController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MyFormRadoButton(
        title: title,
        options: {1: 'Yes (হ্যাঁ)', 2: 'No (না)', 8: 'Don\'t know (জানি না)'},
        controller: controller,
        validator: (value) =>
            (controller.value == -1) ? "$title is required" : null,
        isColumn: false,
      ),
    );
  }

  // Navigation buttons
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        spacing: 16,
        children: [
          if (activeSection > 1)
            Expanded(
              child: CustomSubmitButtonWithIcon(
                onPressed: () async {
                  await _saveCurrentSection();
                  setState(() {
                    activeSection--;
                  });
                  _loadSectionData(activeSection);
                },
                text: 'Previous',
                isLoading: isLoading,
                icon: Icons.arrow_back_ios,
                backgroundColor: Colors.grey,
              ),
            ),
          Expanded(
            child: CustomSubmitButtonWithIcon(
              onPressed: () async {
                if (_validateCurrentSection()) {
                  await _saveCurrentSection();
                  if (activeSection == 2) {
                    _entryDateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(DateTime.now());
                    await _saveCurrentSection();
                    _showCompletionDialog();
                  } else {
                    setState(() {
                      activeSection++;
                    });
                    _loadSectionData(activeSection);
                  }
                } else {
                  Get.showSnackbar(
                    GetSnackBar(
                      title: 'Warning',
                      message: 'All required fields must be filled.',
                      duration: const Duration(seconds: 3),
                      backgroundColor: AppPallete.warningColor,
                    ),
                  );
                }
              },
              text: activeSection == 2 ? 'Save & Complete' : 'Next',
              isLoading: isLoading,
              icon: activeSection == 2 ? Icons.save : Icons.arrow_forward_ios,
              backgroundColor: activeSection == 2
                  ? Colors.green
                  : AppPallete.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Validation methods
  bool _validateCurrentSection() {
    switch (activeSection) {
      case 1:
        return _form1Key.currentState?.validate() ?? false;
      case 2:
        return _form2Key.currentState?.validate() ?? false;
      default:
        return true;
    }
  }

  Future<void> _saveCurrentSection() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    await _saveForm();

    setState(() {
      isLoading = false;
    });
  }

  void _loadSectionData(int section) {
    // Load data when navigating back
  }

  // Initialization
  Future<void> _firstInit() async {
    _q101Controller.text = infantModel.babyPid??'';
    _q102Controller.text = infantModel.childPid ?? '';
    _q103Controller.text = infantModel.siteWomanId ?? '';
    _q104Controller.text = infantModel.childName ?? '';
    _q105Controller.text = infantModel.fatherName ?? '';
    _q106Controller.text = infantModel.cluster??'';

    _q107Controller.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _q108Controller.text = DateFormat('HH:mm').format(DateTime.now());
    _q109Controller.text = UserPrefs.userModel.userId ?? '';

    formModel = await AssetDb.instance.createOrIgnoreForm(
      model: AssetModel(
        infantId: infantModel.infantId,
        q101: _q101Controller.text.trim(),
        q102: _q102Controller.text,
        q103: _q103Controller.text,
        q104: _q104Controller.text,
        q105: _q105Controller.text,
        q106: _q106Controller.text,
        q107: _q107Controller.text,
        q108: _q108Controller.text,
        q109: _q109Controller.text,
        entryUserId: UserPrefs.userModel.userId ?? '',
        syncDt: null,
      ),
    );

    if (formModel == null) {
      Get.snackbar(
        'Error',
        'This form cannot be started.',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 10),
      );
      return;
    }

    _loadExistingData();
  }

  void _loadExistingData() {
    if (formModel == null) return;

    // Section 1
    _q101Controller.text = formModel!.q101 ?? '';
    _q102Controller.text = formModel!.q102 ?? '';
    _q103Controller.text = formModel!.q103 ?? '';
    _q104Controller.text = formModel!.q104 ?? '';
    _q105Controller.text = formModel!.q105 ?? '';
    _q106Controller.text = formModel!.q106 ?? '';
    _q107Controller.text = formModel!.q107 ?? '';
    _q108Controller.text = formModel!.q108 ?? '';
    _q109Controller.text = formModel!.q109 ?? '';

    // Section 2
    _q201Controller.value = int.tryParse(formModel!.q201 ?? '-1') ?? -1;
    _q202Controller.text = formModel!.q202 ?? '';
    _q203Controller.value = int.tryParse(formModel!.q203 ?? '-1') ?? -1;
    _q204Controller.text = formModel!.q204 ?? '';
    _q205Controller.text = formModel!.q205 ?? '';
    _q206Controller.text = formModel!.q206 ?? '';
    _q207Controller.value = int.tryParse(formModel!.q207 ?? '-1') ?? -1;
    _q208Controller.text = formModel!.q208 ?? '';
    _q209Controller.value = int.tryParse(formModel!.q209 ?? '-1') ?? -1;
    _q210Controller.text = formModel!.q210 ?? '';
    _q211Controller.value = int.tryParse(formModel!.q211 ?? '-1') ?? -1;
    _q212Controller.text = formModel!.q212 ?? '';
    _q213Controller.value = int.tryParse(formModel!.q213 ?? '-1') ?? -1;
    _q215Controller.value = int.tryParse(formModel!.q215 ?? '-1') ?? -1;
    _q216Controller.value = int.tryParse(formModel!.q216 ?? '-1') ?? -1;
    _q217Controller.value = int.tryParse(formModel!.q217 ?? '-1') ?? -1;
    _q218Controller.value = int.tryParse(formModel!.q218 ?? '-1') ?? -1;
    _q219Controller.value = int.tryParse(formModel!.q219 ?? '-1') ?? -1;
    _q220Controller.value = int.tryParse(formModel!.q220 ?? '-1') ?? -1;
    _q221Controller.value = int.tryParse(formModel!.q221 ?? '-1') ?? -1;
    _q222Controller.value = int.tryParse(formModel!.q222 ?? '-1') ?? -1;
    _q223Controller.value = int.tryParse(formModel!.q223 ?? '-1') ?? -1;
    _q224Controller.value = int.tryParse(formModel!.q224 ?? '-1') ?? -1;
    _q225Controller.value = int.tryParse(formModel!.q225 ?? '-1') ?? -1;

    setState(() {});
  }

  Future<void> _saveForm() async {
    if (formModel == null) return;
    Position? position;
    if(_entryDateController.text.isNotEmpty){
      position = await LocationService.getCurrentLocation();
      if (position == null) {
        Snackbar.show_e(message: 'Location Data Not Found');
        // return;
      }
    }

    formModel = formModel!.copyWith(
      // Section 1
      q101: _q101Controller.text.trim(),
      q102: _q102Controller.text.trim(),
      q103: _q103Controller.text.trim(),
      q104: _q104Controller.text.trim(),
      q105: _q105Controller.text.trim(),
      q106: _q106Controller.text.trim(),
      q107: _q107Controller.text.trim(),
      q108: _q108Controller.text.trim(),
      q109: _q109Controller.text.trim(),

      // Section 2
      q201: _q201Controller.getValue(),
      q202: _q202Controller.text.trim(),
      q203: _q203Controller.getValue(),
      q204: _q204Controller.text.trim(),
      q205: _q205Controller.text.trim(),
      q206: _q206Controller.text.trim(),
      q207: _q207Controller.getValue(),
      q208: _q208Controller.text.trim(),
      q209: _q209Controller.getValue(),
      q210: _q210Controller.text.trim(),
      q211: _q211Controller.getValue(),
      q212: _q212Controller.text.trim(),
      q213: _q213Controller.getValue(),
      q215: _q215Controller.getValue(),
      q216: _q216Controller.getValue(),
      q217: _q217Controller.getValue(),
      q218: _q218Controller.getValue(),
      q219: _q219Controller.getValue(),
      q220: _q220Controller.getValue(),
      q221: _q221Controller.getValue(),
      q222: _q222Controller.getValue(),
      q223: _q223Controller.getValue(),
      q224: _q224Controller.getValue(),
      q225: _q225Controller.getValue(),

      entryDate: _entryDateController.text.trim(),
      syncDt: null,
      endDT: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),

      lat: position?.latitude.toStringAsFixed(6),
      lng: position?.longitude.toStringAsFixed(6),
    );

    await AssetDb.instance.updateForm(formModel!);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Completed'),
        content: const Text(
          'Thank you for completing the Household Asset form.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // AssetController.to.fetchTodoInfants();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
