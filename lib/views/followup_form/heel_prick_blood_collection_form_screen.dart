import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../controllers/infant_controller.dart';
import '../../core/localDB/data_db.dart';
import '../../core/localDB/models/heel_prick_blood_collection_form_model.dart';
import '../../core/localDB/models/heel_prick_blood_infent_model.dart';
import '../../core/utils/data_type/number_controller.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/section_card_widget.dart';
import '../../core/widgets/single_date_picker.dart';
import '../../core/widgets/time_picker_widget.dart';
import '../user_home/presentation/widgets/infant_card_widget.dart';
import '../user_home/presentation/widgets/question_container_widget.dart';
import 'widgets/custom_button_with_icon_widget.dart';
import 'widgets/custom_form_radio_button_widget.dart';

class HeelPrickBloodCollectionFormScreen extends StatefulWidget {
  const HeelPrickBloodCollectionFormScreen({super.key});

  @override
  State<HeelPrickBloodCollectionFormScreen> createState() =>
      _HeelPrickBloodCollectionFormScreenState();
}

class _HeelPrickBloodCollectionFormScreenState
    extends State<HeelPrickBloodCollectionFormScreen> {
  final HeelPrickBloodInfantModel infantModel =
      Get.arguments as HeelPrickBloodInfantModel;
  HeelPrickBloodCollectionFormModel? formModel;
  int activeSection = 1;
  bool isLoading = false;
  final TextStyle answerTextStyle = const TextStyle(fontSize: 17);

  // Section 1: Identification
  final TextEditingController _q1_aController =
      TextEditingController(); // Site name
  final TextEditingController _q1_bController =
      TextEditingController(); // Participant ID/Infants ID
  final TextEditingController _q1_cController =
      TextEditingController(); // Child Name
  final TextEditingController _q1_dController =
      TextEditingController(); // Date of birth

  // Section 2: Consent
  final NumberController _q2Controller = NumberController(); // Consent signed
  final NumberController _q2_cController = NumberController(); // Consent signed
  final TextEditingController _q2_c_spController =
      TextEditingController(); // Date of consent
  final TextEditingController _q2_aController =
      TextEditingController(); // Date of consent
  final TextEditingController _q2_bController = TextEditingController(
    text: DateFormat('HH:mm').format(DateTime.now()),
  ); // Time of consent

  // Section 3: Collection and processing
  final NumberController _q3_aController = NumberController(); // Type of visit
  final NumberController _q3_bController =
      NumberController(); // Sample collected
  final NumberController _q3_cController =
      NumberController(); // Reasons for not collection
  final TextEditingController _q3_c_otherController =
      TextEditingController(); // Other reason specify
  final TextEditingController _q3_dController =
      TextEditingController(); // Sample ID
  final TextEditingController _q3_eController =
      TextEditingController(); // Date of sample collection
  final TextEditingController _q3_fController =
      TextEditingController(); // Time of sample collection
  final NumberController _q3_gController =
      NumberController(); // Place of sample collection
  final TextEditingController _q3_g_otherController =
      TextEditingController(); // Other place specify
  final TextEditingController _q3_hController =
      TextEditingController(); // How many circles filled
  final TextEditingController _q3_iController =
      TextEditingController(); // Number of satisfactory circles
  final TextEditingController _q3_jController =
      TextEditingController(); // Number of unsatisfactory circles
  final NumberController _q3_kController =
      NumberController(); // Appropriately dried
  final NumberController _q3_lController =
      NumberController(); // Stored in freezer
  final TextEditingController _q3_mController =
      TextEditingController(); // Code of lab staff

  final TextEditingController _endDT = TextEditingController(
    text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
  );

  // Form keys
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  final _form3Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstInit();
  }

  @override
  void dispose() {
    _q1_aController.dispose();
    _q1_bController.dispose();
    _q1_cController.dispose();
    _q1_dController.dispose();
    _q2_aController.dispose();
    _q2_bController.dispose();
    _q2_c_spController.dispose();
    _q3_c_otherController.dispose();
    _q3_dController.dispose();
    _q3_eController.dispose();
    _q3_fController.dispose();
    _q3_g_otherController.dispose();
    _q3_hController.dispose();
    _q3_iController.dispose();
    _q3_jController.dispose();
    _q3_mController.dispose();
    _endDT.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Heel Prick Blood Collection Form for ${infantModel.visitType.toString().trim()}',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InfantCardWidget(model: infantModel),

              // Section 1: Identification
              if (activeSection == 1)
                SectionCardWidget(
                  formKey: _form1Key,
                  title: 'Section 1: Identification',
                  icon: Icons.badge_outlined,
                  child: _buildSection1(),
                ),

              // Section 2: Consent
              if (activeSection == 2)
                SectionCardWidget(
                  formKey: _form2Key,
                  title: 'Section 2: Consent',
                  icon: Icons.assignment_turned_in_outlined,
                  child: _buildSection2(),
                ),

              // Section 3: Collection and processing
              if (activeSection == 3)
                SectionCardWidget(
                  formKey: _form3Key,
                  title: 'Section 3: Collection and Processing',
                  icon: Icons.science_outlined,
                  child: _buildSection3(),
                ),

              // Navigation buttons
              _buildNavigationButtons(infantModel.visitType ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  // Section 1: Identification
  Widget _buildSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionContainerWidget(
          question: '1.a. Site name সাইটের নাম',
          answer: TextFormField(
            controller: _q1_aController,
            decoration: const InputDecoration(hintText: 'Bangladesh'),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question:
              '1.b. Participant ID/Infants ID (14 digits) অংশগ্রহণকারীর আইডি/শিশুর আইডি',
          answer: TextFormField(
            controller: _q1_bController,
            decoration: const InputDecoration(hintText: 'xx-xxxxxx-X-xx'),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: '1.c. Child Name শিশুর নাম',
          answer: TextFormField(
            controller: _q1_cController,
            decoration: const InputDecoration(hintText: 'Enter child name'),
            maxLength: 50,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: '1.d. Date of birth জন্ম তারিখ',
          answer: TextFormField(
            controller: _q1_dController,
            decoration: const InputDecoration(hintText: 'dd/mm/yyyy'),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
      ],
    );
  }

  // Section 2: Consent
  Widget _buildSection2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyFormRadoButton(
          title:
              '2. Has the guardian been able to sign the consent form? অভিভাবক কি সম্মতি ফর্মে স্বাক্ষর করতে পেরেছেন?',
          options: {1: 'Yes (হ্যাঁ)', 2: 'No (না)'},
          controller: _q2Controller,
          callback: () {
            setState(() {});
          },
          validator: (value) => (_q2Controller.value == -1) ? "Required" : null,
        ),
        if (_q2Controller.value == 1) ...[
          const SizedBox(height: 16),
          SingleDateTimePicker(
            controller: _q2_aController,
            text: '2.a. Date of consent সম্মতির তারিখ',
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Date is required' : null,
          ),
          QuestionContainerWidget(
            question: '2.b. Time of consent (24-hour format) সম্মতির সময়',
            answer: SingleTimePicker(
              controller: _q2_bController,
              text: 'Select Time',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a time';
                }
                return null;
              },
              isCleanable: true,
              isEnable: true,
              isHidden: false,
              callback: () {
              //  print('Time selected: ${_q2_bController.text}');
              },
            ),
          ),
        ],
        if (_q2Controller.value == 2) ...[
          MyFormRadoButton(
            title:
                '2.c. Why no? সম্মতি ফর্মে স্বাক্ষর না দেওয়ার কারন উল্লেখ করুন?',
            options: {
              1: 'Refuse (অস্বীকার করেছে)',
              2: 'Died (মৃত)',
              3: 'Outside the study area (গবেষণা এলাকার বাইরে)',
              4: 'Currently in hospital (বর্তমানে হাসপাতালে)',
              9: 'Other (অন্যান্য)',
            },
            controller: _q2_cController,
            specifyKey: 9,
            specifyController: _q2_c_spController,
            specifyMaxLength: 50,
            specifyValidator: (value) {
              if (_q2_cController.value == 9 &&
                  (value == null || value.isEmpty)) {
                return 'Please specify other reason';
              }
              return null;
            },
            callback: () {
              setState(() {});
            },
            validator: (value) =>
                (_q2Controller.value == -1) ? "Required" : null,
            isColumnOptions: true,
          ),

          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Text(
              'If No, skip Section 3 (Collection and processing)',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ],
    );
  }

  // Section 3: Collection and processing
  Widget _buildSection3() {
    final isSampleCollected = _q3_bController.value == 1;
    final isNotCollected = _q3_bController.value == 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyFormRadoButton(
          title: '3.a. Type of visit ভিজিটের ধরন',
          options: {
            1: 'Enrolment (নিবন্ধন)',
            2: '6 months (৬ মাস)',
            3: 'Growth faltering (বৃদ্ধিজনিত সমস্যা)',
          },
          controller: _q3_aController,
          validator: (value) =>
              (_q3_aController.value == -1) ? "Required" : null,
          isColumnOptions: true,
        ),
        const SizedBox(height: 16),
        MyFormRadoButton(
          title: '3.b. Sample collected নমুনা সংগ্রহ করা হয়েছে?',
          options: {1: 'Yes (হ্যাঁ)', 2: 'No (না)'},
          controller: _q3_bController,
          callback: () async {
            if (_q3_bController.value == 1) {
              _q3_dController.text = infantModel.sampleId ?? '';
            } else {
              _q3_dController.clear();
            }
            setState(() {});
          },
          validator: (value) =>
              (_q3_bController.value == -1) ? "Required" : null,
        ),

        // If sample NOT collected
        if (isNotCollected) ...[
          const SizedBox(height: 16),
          MyFormRadoButton(
            title: '3.c. Reasons for not collection সংগ্রহ না করার কারণ',
            options: {
              1: 'Moved out (স্থানান্তরিত)',
              2: 'Died (মৃত্যু)',
              3: 'Refused (অস্বীকৃতি)',
              4: 'Consent withdrawn (সম্মতি প্রত্যাহার)',
              5: 'Collection failure (সংগ্রহ ব্যর্থ)',
              6: 'Others (অন্যান্য)',
            },
            controller: _q3_cController,
            specifyKey: 6,
            specifyController: _q3_c_otherController,
            specifyMaxLength: 100,
            specifyValidator: (value) {
              if (_q3_cController.value == 6 &&
                  (value == null || value.isEmpty)) {
                return 'Please specify other reason';
              }
              return null;
            },
            validator: (value) =>
                (_q3_cController.value == -1) ? "Required" : null,
            isColumnOptions: true,
          ),
        ],

        // If sample collected
        if (isSampleCollected) ...[
          const SizedBox(height: 16),
          QuestionContainerWidget(
            question: '3.d. Sample ID (17 digits) নমুনা আইডি',
            answer: TextFormField(
              controller: _q3_dController,
              decoration: const InputDecoration(hintText: 'xx-xxxxxx-X-xx'),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Sample ID is required';
                if (value.length != 17) return 'Sample ID must be 17 digits';
                return null;
              },
              enabled: false,
            ),
          ),
          SingleDateTimePicker(
            controller: _q3_eController,
            text: '3.e. Date of sample collection নমুনা সংগ্রহের তারিখ',
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Date is required' : null,
          ),
          QuestionContainerWidget(
            question:
                '3.f. Time of sample collection (hh:mm) নমুনা সংগ্রহের সময়',
            answer: SingleTimePicker(
              controller: _q3_fController,
              text: 'Select Time',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a time';
                }
                return null;
              },
              isCleanable: true,
              isEnable: true,
              isHidden: false,
              callback: () {
              //  print('Time selected: ${_q3_fController.text}');
              },
            ),
          ),
          MyFormRadoButton(
            title: '3.g. Place of sample collection নমুনা সংগ্রহের স্থান',
            options: {
              1: 'Home (বাড়ি)',
              2: 'Hospital (হাসপাতাল)',
              3: 'Other (অন্যান্য)',
            },
            controller: _q3_gController,
            specifyKey: 3,
            specifyController: _q3_g_otherController,
            specifyMaxLength: 100,
            specifyValidator: (value) {
              if (_q3_gController.value == 3 &&
                  (value == null || value.isEmpty)) {
                return 'Please specify other place';
              }
              return null;
            },
            validator: (value) =>
                (_q3_gController.value == -1) ? "Required" : null,
            isColumnOptions: true,
          ),
          QuestionContainerWidget(
            question:
                '3.h. How many circles in Whatman card filled? হোয়াটম্যান কার্ডে কতটি বৃত্ত পূরণ হয়েছে?',
            answer: TextFormField(
              controller: _q3_hController,
              decoration: const InputDecoration(hintText: 'Number of circles'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                int num = int.tryParse(value) ?? 0;
                if (num < 1 || num > 12) {
                  return 'Must be between 1-12';
                }
                return null;
              },
            ),
          ),
          QuestionContainerWidget(
            question:
                '3.i. Number of satisfactory circles সন্তোষজনক বৃত্তের সংখ্যা',
            answer: TextFormField(
              controller: _q3_iController,
              decoration: const InputDecoration(hintText: 'Number'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                int num = int.tryParse(value) ?? 0;
                int total = int.tryParse(_q3_hController.text) ?? 0;
                if (num > total) {
                  return 'Cannot exceed total circles';
                }
                return null;
              },
            ),
          ),
          QuestionContainerWidget(
            question:
                '3.j. Number of unsatisfactory circles অসন্তোষজনক বৃত্তের সংখ্যা',
            answer: TextFormField(
              controller: _q3_jController,
              decoration: const InputDecoration(hintText: 'Number'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                int num = int.tryParse(value) ?? 0;
                int total = int.tryParse(_q3_hController.text) ?? 0;
                if (num > total) {
                  return 'Cannot exceed total circles';
                }
                return null;
              },
            ),
          ),
          MyFormRadoButton(
            title:
                '3.k. Appropriately dried the Whatman card হোয়াটম্যান কার্ড কি যথাযথভাবে শুকানো হয়েছে?',
            options: {1: 'Yes (হ্যাঁ)', 2: 'No (না)'},
            controller: _q3_kController,
            validator: (value) =>
                (_q3_kController.value == -1) ? "Required" : null,
          ),
          MyFormRadoButton(
            title: '3.l. Stored in the freezer ফ্রিজারে সংরক্ষিত?',
            options: {1: 'Yes (হ্যাঁ)', 2: 'No (না)'},
            controller: _q3_lController,
            validator: (value) =>
                (_q3_lController.value == -1) ? "Required" : null,
          ),
        ],

        const SizedBox(height: 16),
        QuestionContainerWidget(
          question: '3.m. Code of the lab staff ল্যাব স্টাফের কোড',
          answer: TextFormField(
            controller: _q3_mController,
            decoration: const InputDecoration(hintText: '3 digits'),
            maxLength: 3,
            keyboardType: TextInputType.number,
            validator: Validators.requiredValidator,
          ),
        ),
      ],
    );
  }

  // Navigation buttons
  Widget _buildNavigationButtons(String listType) {
    final isConsentSkipped = _q2Controller.value == 2;
    final maxSection = isConsentSkipped ? 2 : 3;

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
                  if (activeSection == maxSection) {
                    _showCompletionDialog(listType);
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
              text: activeSection == maxSection ? 'Save & Complete' : 'Next',
              isLoading: isLoading,
              icon: activeSection == maxSection
                  ? Icons.save
                  : Icons.arrow_forward_ios,
              backgroundColor: activeSection == maxSection
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
      case 3:
        return _form3Key.currentState?.validate() ?? false;
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
    // Set autofilled fields
    _q1_aController.text = 'Bangladesh';
    _q1_bController.text = infantModel.infantId ?? '';
    _q1_cController.text = infantModel.childName ?? '';
    _q1_dController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.parse(infantModel.dob ?? '1900-01-01'));

    // Check if form already exists for this visit type
    // We'll need to determine which visit type we're collecting for
    // For now, default to Enrolment (1)

    formModel = await HeelPrickBloodCollectionFormDb.instance
        .createOrIgnoreForm(
          model: HeelPrickBloodCollectionFormModel(
            infantId: infantModel.infantId.toString().trim(),
            visitDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            visitType: infantModel.visitType.toString().trim(),
            q1_a: _q1_aController.text,
            q1_b: _q1_bController.text,
            q1_c: _q1_cController.text,
            q1_d: _q1_dController.text,
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
  //  print(formModel!.toJson());

    _loadExistingData();
  }

  void _loadExistingData() {
    if (formModel == null) return;

    // Section 1
    _q1_aController.text = formModel!.q1_a ?? 'Bangladesh';
    _q1_bController.text = formModel!.q1_b ?? '';
    _q1_cController.text = formModel!.q1_c ?? '';
    _q1_dController.text = formModel!.q1_d ?? '';

    // Section 2
    _q2Controller.value = int.tryParse(formModel!.q2 ?? '-1') ?? -1;
    _q2_aController.text = formModel!.q2_a ?? '';
    _q2_bController.text =
        formModel!.q2_b ?? DateFormat('HH:mm').format(DateTime.now());
    _q2_cController.value = int.tryParse(formModel!.q2_c ?? '-1') ?? -1;
    _q2_c_spController.text = formModel!.q2_c_sp ?? '';

    // Section 3
    _q3_aController.value = int.tryParse(formModel!.q3_a ?? '-1') ?? -1;
    _q3_bController.value = int.tryParse(formModel!.q3_b ?? '-1') ?? -1;
    _q3_cController.value = int.tryParse(formModel!.q3_c ?? '-1') ?? -1;
    _q3_c_otherController.text = formModel!.q3_c_other ?? '';
    _q3_dController.text = formModel!.q3_d ?? '';
    _q3_eController.text = formModel!.q3_e ?? '';
    _q3_fController.text = formModel!.q3_f ?? '';
    _q3_gController.value = int.tryParse(formModel!.q3_g ?? '-1') ?? -1;
    _q3_g_otherController.text = formModel!.q3_g_other ?? '';
    _q3_hController.text = formModel!.q3_h ?? '';
    _q3_iController.text = formModel!.q3_i ?? '';
    _q3_jController.text = formModel!.q3_j ?? '';
    _q3_kController.value = int.tryParse(formModel!.q3_k ?? '-1') ?? -1;
    _q3_lController.value = int.tryParse(formModel!.q3_l ?? '-1') ?? -1;
    _q3_mController.text = formModel!.q3_m ?? '';

    setState(() {});
  }

  Future<void> _saveForm() async {
    if (formModel == null) return;

    final isSampleCollected = _q3_bController.value == 1;
    final isConsentSkipped = _q2Controller.value == 2;
    final maxSection = isConsentSkipped ? 2 : 3;
    if (activeSection == maxSection) {
      formModel = formModel!.copyWith(
        endDate: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      );
    }

    formModel = formModel!.copyWith(
      // Section 1
      q1_a: _q1_aController.text.trim(),
      q1_b: _q1_bController.text.trim(),
      q1_c: _q1_cController.text.trim(),
      q1_d: _q1_dController.text.trim(),

      // Section 2
      q2: _q2Controller.value == -1 ? null : _q2Controller.value.toString(),
      q2_a: _q2_aController.text.trim(),
      q2_b: _q2_bController.text.trim(),
      q2_c: _q2_cController.value == -1
          ? null
          : _q2_cController.value.toString(),
      q2_c_sp: _q2_c_spController.text.trim(),

      // Section 3
      q3_a: _q3_aController.value == -1
          ? null
          : _q3_aController.value.toString(),
      q3_b: _q3_bController.value == -1
          ? null
          : _q3_bController.value.toString(),
      q3_c: _q3_cController.value == -1
          ? null
          : _q3_cController.value.toString(),
      q3_c_other: _q3_c_otherController.text.trim(),
      q3_d: isSampleCollected ? _q3_dController.text.trim() : null,
      q3_e: isSampleCollected ? _q3_eController.text.trim() : null,
      q3_f: isSampleCollected ? _q3_fController.text.trim() : null,
      q3_g: _q3_gController.value == -1
          ? null
          : _q3_gController.value.toString(),
      q3_g_other: _q3_g_otherController.text.trim(),
      q3_h: isSampleCollected ? _q3_hController.text.trim() : null,
      q3_i: isSampleCollected ? _q3_iController.text.trim() : null,
      q3_j: isSampleCollected ? _q3_jController.text.trim() : null,
      q3_k: _q3_kController.value == -1
          ? null
          : _q3_kController.value.toString(),
      q3_l: _q3_lController.value == -1
          ? null
          : _q3_lController.value.toString(),
      q3_m: _q3_mController.text.trim(),

      visitType: _q3_aController.value == 1
          ? 'Enrollment'
          : _q3_aController.value == 2
          ? 'Six_Month'
          : _q3_aController.value == 3
          ? 'GF'
          : null,
      syncDt: null,
    );

    // if (_endDT.text.trim().isNotEmpty) {
    //   Position? position = await LocationService.getCurrentLocation();
    //   if (position == null) {
    //     // Snackbar.show_e(message: 'Location Data Not Found');
    //     // return;
    //   } else {
    //     formModel = formModel!.copyWith(
    //       lat: position.latitude.toStringAsFixed(6),
    //       lng: position.longitude.toStringAsFixed(6),
    //     );
    //   }
    // }
  //  print('Saving form: ${formModel!.toJson()}');

    await HeelPrickBloodCollectionFormDb.instance.updateForm(formModel!);
  }

  void _showCompletionDialog(String listType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Completed'),
        content: const Text(
          'Thank you for completing the Heel Prick Blood Collection form.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              InfantController.to.fetchTodoInfants(listType);
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
