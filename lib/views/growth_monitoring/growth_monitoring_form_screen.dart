import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/enrollment_form_model.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/growth_and_outcome_form_model.dart';
import 'package:heel_prick_blood_collection/core/prefs/user_prefs.dart';
import 'package:heel_prick_blood_collection/core/widgets/measurment_widget.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../controllers/infant_controller.dart';
import '../../core/localDB/data_db.dart';
import '../../core/utils/data_type/number_controller.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/section_card_widget.dart';
import '../../core/widgets/single_date_picker.dart';
import '../followup_form/widgets/custom_button_with_icon_widget.dart';
import '../followup_form/widgets/custom_form_radio_button_widget.dart';
import '../user_home/presentation/widgets/question_container_widget.dart';

class GrowthMonitoringFormScreen extends StatefulWidget {
  const GrowthMonitoringFormScreen({super.key});

  @override
  State<GrowthMonitoringFormScreen> createState() =>
      _GrowthMonitoringFormScreenState();
}

class _GrowthMonitoringFormScreenState
    extends State<GrowthMonitoringFormScreen> {
  final EnrollmentFormModel infantModel = Get.arguments as EnrollmentFormModel;
  GrowthAndOutcomeFormModel? formModel;
  int activeSection = 1;
  bool isLoading = false;
  final TextStyle answerTextStyle = const TextStyle(fontSize: 17);

  // Section 1: Identification
  final TextEditingController _q101Controller =
      TextEditingController(); // Site name
  final TextEditingController _q102Controller =
      TextEditingController(); // Participant ID/Infants ID
  final TextEditingController _q103Controller =
      TextEditingController(); // Child Name
  final TextEditingController _q104Controller =
      TextEditingController(); // Date of birth
  final TextEditingController _q105Controller = TextEditingController();

  // Section 2: Consent
  final TextEditingController _q201Controller = TextEditingController();
  final TextEditingController _q201aController = TextEditingController();
  final TextEditingController _q201bController = TextEditingController();
  final NumberController _q201cController =
      NumberController(); // Consent signed
  final NumberController _q201cOController =
      NumberController(); // Consent signed
  final TextEditingController _q201dController =
      TextEditingController(); // Consent signed
  final TextEditingController _q201eController =
      TextEditingController(); // Consent signed

  // Section 3: Collection and processing
  final NumberController _q301Controller = NumberController(); // Type of visit
  final TextEditingController _q302Controller =
      TextEditingController(); // Consent signed
  final NumberController _q303Controller = NumberController();
  final TextEditingController _q304Controller = TextEditingController();
  // Secttion 4: Anthropometry of Baby
  final TextEditingController _q401aController = TextEditingController();
  final TextEditingController _q401bController = TextEditingController();
  final TextEditingController _q401Controller = TextEditingController();
  final TextEditingController _q402aController = TextEditingController();
  final TextEditingController _q402bController = TextEditingController();
  final TextEditingController _q402Controller = TextEditingController();
  final TextEditingController _q403aController = TextEditingController();
  final TextEditingController _q403bController = TextEditingController();
  final TextEditingController _q403Controller = TextEditingController();
  final TextEditingController _q404aController = TextEditingController();
  final TextEditingController _q404bController = TextEditingController();
  final TextEditingController _q404Controller = TextEditingController();

  final TextEditingController _endDT = TextEditingController();

  // Form keys
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  final _form3Key = GlobalKey<FormState>();
  final _form4Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstInit();
  }

  @override
  void dispose() {
    _q101Controller.dispose();
    _q102Controller.dispose();
    _q103Controller.dispose();
    _q104Controller.dispose();
    _q105Controller.dispose();
    _q201Controller.dispose();
    _q201aController.dispose();
    _q201bController.dispose();
    _q201dController.dispose();
    _q201eController.dispose();
    _q302Controller.dispose();
    _q304Controller.dispose();
    _q401Controller.dispose();
    _q402Controller.dispose();
    _q403Controller.dispose();
    _q404Controller.dispose();

    _endDT.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          infantModel.visitWeek == '02'
              ? 'Baseline Anthro Form'
              : 'Growth and outcome form of Week ${infantModel.visitWeek}',
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
              // InfantCardWidget(model: infantModel),

              // Section 1: Identification
              if (activeSection == 1)
                SectionCardWidget(
                  formKey: _form1Key,
                  title: 'Section 1: ID Details',
                  icon: Icons.badge_outlined,
                  child: _buildSection1(),
                ),

              // Section 2: Consent
              if (activeSection == 2)
                SectionCardWidget(
                  formKey: _form2Key,
                  title: 'Section 2: Visits',
                  icon: Icons.assignment_turned_in_outlined,
                  child: _buildSection2(),
                ),

              // Section 3: Collection and processing
              if (activeSection == 3)
                SectionCardWidget(
                  formKey: _form3Key,
                  title: 'Section 3: Respondent',
                  icon: Icons.science_outlined,
                  child: _buildSection3(),
                ),

              if (activeSection == 4)
                SectionCardWidget(
                  formKey: _form4Key,
                  title: 'Section 4: Anthropometry of baby',
                  icon: Icons.science_outlined,
                  child: _buildSection4(),
                ),

              // Navigation buttons
              _buildNavigationButtons(''),
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
          question: 'Q101. ParticipantID(autofilled)',
          answer: TextFormField(
            controller: _q101Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q102. Mother name (autofilled)',
          answer: TextFormField(
            controller: _q102Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q103. Infant name (autofilled)',
          answer: TextFormField(
            controller: _q103Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q104. HouseholdID (autofilled)',
          answer: TextFormField(
            controller: _q104Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q105. Field work area code (autofilled)',
          answer: TextFormField(
            controller: _q105Controller,
            decoration: const InputDecoration(hintText: ''),
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
        QuestionContainerWidget(
          question: 'Q201. Visit number (autofilled)',
          answer: TextFormField(
            controller: _q201Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q201A. Date Of Visit (autofilled)',
          answer: TextFormField(
            controller: _q201aController,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q201B. Time Of Visit (autofilled)',
          answer: TextFormField(
            controller: _q201bController,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),

        MyFormRadoButton(
          title: 'Q201C. Status Of Infant',
          options: {
            11: 'Present',
            12: 'Currently in hospital',
            13: 'Moved out',
            14: 'Died',
            15: 'Refused',
            16: 'Withdrawn',
          },
          controller: _q201cController,
          callback: () {
            if (_q201cController.value != 11) {
              _endDT.text = DateFormat(
                'yyyy-MM-dd HH:mm',
              ).format(DateTime.now());
            } else {
              _endDT.clear();
            }
            setState(() {});
          },
          validator: (value) =>
              (_q201cController.value == -1) ? "Required" : null,
        ),
        if (_q201cController.value == 14) ...[
          const SizedBox(height: 16),
          MyFormRadoButton(
            title: 'Q201D. Date of death',
            options: {1: 'DOD known', 2: 'Not Applicable', 3: 'Not Known'},
            controller: _q201cOController,
            callback: () {
              if (_q201cOController.value == 2) {
                _q201dController.text = '1909-09-09';
              } else if (_q201cOController.value == 3) {
                _q201dController.text = '1808-08-08';
              }
              setState(() {});
            },
            validator: (value) =>
                (_q201cOController.value == -1) ? "Required" : null,
          ),
          if (_q201cOController.value == 1) ...[
            SingleDateTimePicker(
              controller: _q201dController,
              text: 'Q201D. Date of death Specify',
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Date is required' : null,
            ),
          ],
        ],
        QuestionContainerWidget(
          question: 'Q201E. Fieldworker Code (autofilled)',
          answer: TextFormField(
            controller: _q201eController,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
      ],
    );
  }

  // Section 3: Collection and processing
  Widget _buildSection3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyFormRadoButton(
          title: 'Q301. Who is the respondent ',
          options: {11: 'Mother of the Baby', 12: 'Other'},
          controller: _q301Controller,
          validator: (value) =>
              (_q301Controller.value == -1) ? "Required" : null,
          specifyKey: 12,
          specifyController: _q302Controller,
          specifyValidator: Validators.requiredValidator,
          isColumnOptions: true,
          callback: () {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        if (_q301Controller.value == 12) ...[
          MyFormRadoButton(
            title: 'Q303. 3	If the respondent is not the mother , why?',
            options: {
              11: 'Mother died',
              12: 'Mother not available for another reason',
            },
            controller: _q303Controller,
            callback: () async {
              setState(() {});
            },
            validator: (value) =>
                (_q303Controller.value == -1) ? "Required" : null,
          ),
          if (_q303Controller.value == 11) ...[
            SingleDateTimePicker(
              controller: _q304Controller,
              text: 'Q304. If mother died, date of death',
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Date is required' : null,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildSection4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MeasurmentWidget(
          title: 'Q401. Weight at each visit',
          hintText: 'Enter weight',
          maxLength: 4,
          differenceLimit: 10.0,
          reading1Controller: _q401aController,
          reading2Controller: _q401bController,
          finalController: _q401Controller,
          isDouble: false,
          onChanged: () {
            _endDT.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
          },
        ),
        const SizedBox(height: 16),
        // ---
        if (infantModel.visitWeek == '02' || infantModel.visitWeek == '27') ...[
          MeasurmentWidget(
            title: 'Q402. Length',
            hintText: 'Enter length',
            maxLength: 4,
            differenceLimit: 0.5,
            isDouble: true,
            reading1Controller: _q402aController,
            reading2Controller: _q402bController,
            finalController: _q402Controller,
          ),
          if (infantModel.visitWeek != '02')
            MeasurmentWidget(
              title: 'Q403. MUAC',
              hintText: 'Enter MUAC',
              maxLength: 4,
              differenceLimit: 0.5,
              isDouble: true,
              reading1Controller: _q403aController,
              reading2Controller: _q403bController,
              finalController: _q403Controller,
            ),

          MeasurmentWidget(
            title: 'Q404. Head Circumference',
            hintText: 'Enter head circumference',
            maxLength: 4,
            differenceLimit: 0.5,
            isDouble: true,
            reading1Controller: _q404aController,
            reading2Controller: _q404bController,
            finalController: _q404Controller,
          ),
        ],
      ],
    );
  }

  // Navigation buttons
  Widget _buildNavigationButtons(String listType) {
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
                  if (activeSection == 4 || _endDT.text.isNotEmpty) {
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
              text: (activeSection == 4 || _endDT.text.isNotEmpty)
                  ? 'Save & Complete'
                  : 'Next',
              isLoading: isLoading,
              icon: (activeSection == 4 || _endDT.text.isNotEmpty)
                  ? Icons.save
                  : Icons.arrow_forward_ios,
              backgroundColor: (activeSection == 4 || _endDT.text.isNotEmpty)
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
      case 4:
        return _form4Key.currentState?.validate() ?? false;
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
    // // Set autofilled fields
    _q101Controller.text = infantModel.q602 ?? '';
    _q102Controller.text = infantModel.q103 ?? '';
    _q103Controller.text = infantModel.q104 ?? '';
    _q104Controller.text = infantModel.q101 ?? '';
    _q105Controller.text = infantModel.q102.toString().substring(0, 3);
    _q201Controller.text = infantModel.visitWeek ?? '';
    _q201eController.text = UserPrefs.userModel.userId ?? '';

    formModel = await GrowthAndOutcomeFormDb.instance.createOrIgnoreForm(
      model: GrowthAndOutcomeFormModel(
        infantId: infantModel.infantId.toString().trim(),
        q101: _q101Controller.text.toString().trim(),
        q105: _q105Controller.text.toString().trim(),
        q201: infantModel.visitWeek,
        q201e: _q201eController.text.toString().trim(),
        startDt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        userId: _q105Controller.text.toString().trim(),
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
    print(formModel!.toJson());

    _loadExistingData();
  }

  void _loadExistingData() {
    if (formModel == null) return;
    _q201aController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _q201bController.text = DateFormat('HH:mm').format(DateTime.now());
    _q201cController.set(value: formModel!.q201c);
    _q201dController.text = formModel!.q201d ?? '';
    _q301Controller.set(value: formModel!.q301);
    _q302Controller.text = formModel!.q302 ?? '';
    _q303Controller.set(value: formModel!.q303);
    _q304Controller.text = formModel!.q304 ?? '';
    _q401Controller.text = formModel!.q401 ?? '';
    _q401aController.text = formModel!.q401a ?? '';
    _q401bController.text = formModel!.q401b ?? '';
    _q402Controller.text = formModel!.q402 ?? '';
    _q402aController.text = formModel!.q402a ?? '';
    _q402bController.text = formModel!.q402b ?? '';
    _q403Controller.text = formModel!.q403 ?? '';
    _q403aController.text = formModel!.q403a ?? '';
    _q403bController.text = formModel!.q403b ?? '';
    _q404Controller.text = formModel!.q404 ?? '';
    _q404aController.text = formModel!.q404a ?? '';
    _q404bController.text = formModel!.q404b ?? '';
    setState(() {});
  }

  Future<void> _saveForm() async {
    if (formModel == null) return;

    formModel = formModel!.copyWith(
      q201a: _q201aController.text.toString().trim(),

      q201b: _q201bController.text.toString().trim(),
      q201c: _q201cController.getValue(),
      q201d: _q201dController.text.toString().trim(),
      q301: _q301Controller.getValue(),
      q302: _q302Controller.text.toString().trim(),
      q303: _q303Controller.getValue(),
      q304: _q304Controller.text.toString().trim(),
      q401: _q401Controller.text.toString().trim(),
      q401a: _q401aController.text.toString().trim(),
      q401b: _q401bController.text.toString().trim(),
      q402: _q402Controller.text.toString().trim(),
      q402a: _q402aController.text.toString().trim(),
      q402b: _q402bController.text.toString().trim(),
      q403: _q403Controller.text.toString().trim(),
      q403a: _q403aController.text.toString().trim(),
      q403b: _q403bController.text.toString().trim(),
      q404: _q404Controller.text.toString().trim(),
      q404a: _q404aController.text.toString().trim(),
      q404b: _q404bController.text.toString().trim(),
      enDt: _endDT.text.toString().trim(),
      syncDt: null,
    );

    if (_endDT.text.trim().isNotEmpty) {
      Position? position = await LocationService.getCurrentLocation();
      if (position == null) {
        // Snackbar.show_e(message: 'Location Data Not Found');
        // return;
      } else {
        formModel = formModel!.copyWith(
          lat: position.latitude.toStringAsFixed(6),
          lng: position.longitude.toStringAsFixed(6),
          syncDt: null,
        );
      }
    }
    print('Saving form: ${formModel!.toJson()}');

    await GrowthAndOutcomeFormDb.instance.updateForm(formModel!);
  }

  void _showCompletionDialog(String listType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Completed'),
        content: const Text(
          'Thank you for completing the Growth And Outcome form.',
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
