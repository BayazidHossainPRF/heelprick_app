import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/controllers/pending_infant_controller.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/enrollment_form_model.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/pending_infant_model.dart';
import 'package:heel_prick_blood_collection/core/prefs/user_prefs.dart';
import 'package:heel_prick_blood_collection/core/routes/app_routes.dart';
import 'package:heel_prick_blood_collection/core/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../core/localDB/data_db.dart';
import '../../core/utils/data_type/number_controller.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/snackbar.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/section_card_widget.dart';
import '../followup_form/widgets/custom_button_with_icon_widget.dart';
import '../followup_form/widgets/custom_form_radio_button_widget.dart';
import '../user_home/presentation/widgets/question_container_widget.dart';

class EnrollmentFormScreen extends StatefulWidget {
  const EnrollmentFormScreen({super.key});

  @override
  State<EnrollmentFormScreen> createState() => _EnrollmentFormScreenState();
}

class _EnrollmentFormScreenState extends State<EnrollmentFormScreen> {
  final PendingInfantModel infantModel = Get.arguments as PendingInfantModel;
  EnrollmentFormModel? formModel;
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
  final TextEditingController _q202aController = TextEditingController();
  final TextEditingController _q202bController = TextEditingController();
  final TextEditingController _q202cController = TextEditingController();
  final NumberController _q202dController = NumberController();
  final NumberController _q301Controller = NumberController();
  final TextEditingController _q302Controller = TextEditingController();

  // Section 3: Collection and processing
  final NumberController _q401Controller = NumberController(); // Type of visit
  final NumberController _q402Controller = NumberController(); // Type of visit
  final NumberController _q403Controller = NumberController(); // Type of visit
  final NumberController _q404Controller = NumberController(); // Type of visit
  final NumberController _q405Controller = NumberController(); // Type of visit
  final NumberController _q406Controller = NumberController(); // Type of visit
  final NumberController _q407Controller = NumberController(); // Type of visit
  final NumberController _q408Controller = NumberController(); // Type of visit
  final TextEditingController _q409Controller = TextEditingController();
  final NumberController _q410Controller = NumberController(); // Type of visit
  final NumberController _q411Controller = NumberController(); // Type of visit
  final NumberController _q412Controller = NumberController(); // Type of visit
  final NumberController _q413Controller = NumberController(); // Type of visit
  final NumberController _q501Controller = NumberController(); // Type of visit
  final TextEditingController _q502aController = TextEditingController();
  final TextEditingController _q502bController = TextEditingController();
  final NumberController _q601Controller = NumberController();
  final TextEditingController _q602Controller = TextEditingController();
  final TextEditingController _endDT = TextEditingController();

  // Form keys
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  final _form3Key = GlobalKey<FormState>();
  final _form4Key = GlobalKey<FormState>();
  final _form5Key = GlobalKey<FormState>();
  final _form6Key = GlobalKey<FormState>();

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
    _q302Controller.dispose();

    _endDT.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screening and Enrollment Form')),
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
                  title: 'Section 3: Respondant',
                  icon: Icons.science_outlined,
                  child: _buildSection3(),
                ),

              if (activeSection == 4)
                SectionCardWidget(
                  formKey: _form4Key,
                  title: 'Section 4: Details Inclusion Criteria',
                  icon: Icons.science_outlined,
                  child: _buildSection4(),
                ),
              if (activeSection == 5)
                SectionCardWidget(
                  formKey: _form5Key,
                  title: 'Section 5: Consent',
                  icon: Icons.science_outlined,
                  child: _buildSection5(),
                ),

              if (activeSection == 6)
                SectionCardWidget(
                  formKey: _form6Key,
                  title: 'Section 6: Randomisation',
                  icon: Icons.science_outlined,
                  child: _buildSection6(),
                ),

              // Navigation buttons
              _buildNavigationButtons(),
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
          question: 'Q101. HouseholdID (autofilled)',
          answer: TextFormField(
            controller: _q101Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q102. BRANCHwomanID (autofilled) ',
          answer: TextFormField(
            controller: _q102Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q103. 3	Woman name (site specific process to autofill)',
          answer: TextFormField(
            controller: _q103Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q104. Infant name (site specific process to autofill)',
          answer: TextFormField(
            controller: _q104Controller,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q105. Infant screening id (autofilled)',
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
          question: 'Q202a. Date of Visit (autofilled)',
          answer: TextFormField(
            controller: _q202aController,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q202b. Time of Visit (autofilled)',
          answer: TextFormField(
            controller: _q202bController,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        QuestionContainerWidget(
          question: 'Q202c. Field Worker Code (autofilled)',
          answer: TextFormField(
            controller: _q202cController,
            decoration: const InputDecoration(hintText: ''),
            enabled: false,
            validator: Validators.requiredValidator,
          ),
        ),
        MyFormRadoButton(
          title: 'Q202d. Status of Infant',
          options: {
            11: 'Present',
            12: 'Currently in hospital',
            13: 'Moved out',
            14: 'Died',
            15: 'Refused',
            16: 'Withdrawn',
          },
          controller: _q202dController,
          validator: (value) =>
              (_q202dController.value == -1) ? "Required" : null,
          callback: () {
            if (_q202dController.value != 11) {
              _endDT.text = DateFormat(
                'yyyy-MM-dd HH:mm',
              ).format(DateTime.now());
              setState(() {});
            }
          },
          isColumnOptions: true,
        ),
      ],
    );
  }

  Widget _buildSection3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyFormRadoButton(
          title: 'Q301. Who is the respondent ',
          options: {11: 'Biological Mother of the Baby', 12: 'Other'},
          controller: _q301Controller,
          validator: (value) =>
              (_q301Controller.value == -1) ? "Required" : null,
          specifyKey: 12,
          specifyController: _q302Controller,
          specifyValidator: Validators.requiredValidator,
          isColumnOptions: true,
        ),
      ],
    );
  }

  Widget _buildSection4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyFormRadoButton(
          title: 'Q401. Is the baby alive now? (field worker to ask)',
          options: {1: 'Yes', 2: 'No'},
          controller: _q401Controller,
          callback: checkEligibility,
          validator: (value) =>
              (_q401Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title: 'Q402.	Is the age of baby > = 7 and < 14 days (autofilled)',
          options: {1: 'Yes', 2: 'No'},
          isEnable: false,
          controller: _q402Controller,
          validator: (value) =>
              (_q402Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title:
              'Q403. Was the ultrasound-based gestational age done before 20 wks of gestation? (auto-filled)',
          options: {1: 'Yes', 2: 'No'},
          isEnable: false,
          controller: _q403Controller,
          validator: (value) =>
              (_q403Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title: 'Q404. Baby is 28 weeks gestation or more (autofilled)',
          options: {1: 'Yes', 2: 'No'},
          isEnable: false,
          controller: _q404Controller,
          validator: (value) =>
              (_q404Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title:
              'Q405. Was baby\'s birth weight taken within 72 hours after birth (autofilled)',
          options: {1: 'Yes', 2: 'No'},
          isEnable: false,
          controller: _q405Controller,
          validator: (value) =>
              (_q405Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title:
              'Q406. Has the baby been fed breastmilk at any time since birth (field worker to ask)',
          options: {1: 'Yes', 2: 'No', 9: 'N/A'},
          controller: _q406Controller,
          callback: checkEligibility,
          validator: (value) =>
              (_q406Controller.value == -1) ? "Required" : null,
        ),

        MyFormRadoButton(
          title: 'Q407. Is the biological mother alive  (field worker to ask)',
          options: {1: 'Yes', 2: 'No', 9: 'N/A'},
          controller: _q407Controller,
          callback: checkEligibility,
          validator: (value) =>
              (_q407Controller.value == -1) ? "Required" : null,
        ),
        const SizedBox(height: 20),
        Text(
          'Exclusion Criteria',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        MyFormRadoButton(
          title:
              'Q408. Does the baby have a major congenital abnormality (e.g. severe cleft palate ) or a major illness (e.g. severe asphyxia, HIE, severe RDS, need for mechanical ventilation, severe NEC, major surgery)  which is impairing feeding or nutrition (field worker to ask)',
          options: {1: 'Yes', 2: 'No', 9: 'N/A'},
          controller: _q408Controller,
          callback: checkEligibility,
          validator: (value) =>
              (_q408Controller.value == -1) ? "Required" : null,
          specifyKey: 1,
          specifyController: _q409Controller,
          specifyValidator: Validators.requiredValidator,
          specifyMaxLength: 100,
        ),
        MyFormRadoButton(
          title:
              'Q410. Does the family intend to move from the study area in the next 6 months? (field worker to ask)',
          options: {1: 'Yes', 2: 'No', 9: 'N/A'},
          controller: _q410Controller,
          callback: checkEligibility,
          validator: (value) =>
              (_q410Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title:
              'Q411. Has the mother has given birth to three or more babies (autofilled)',
          options: {1: 'Yes', 2: 'No', 9: 'N/A'},
          isEnable: false,
          controller: _q411Controller,
          validator: (value) =>
              (_q411Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title:
              'Q412. Has a baby has already been recruited from the same household and is under surveillance? (autofilled)',
          options: {1: 'Yes', 2: 'No', 9: 'N/A'},
          isEnable: false,
          controller: _q412Controller,
          validator: (value) =>
              (_q412Controller.value == -1) ? "Required" : null,
        ),
        MyFormRadoButton(
          title:
              'Q413. Is the baby eligible for enrolment? (q4.1 to 4.7 = Yes, q4.8 to q4.12=No) (autofilled)',
          options: {1: 'Yes', 2: 'No'},
          isEnable: false,
          controller: _q413Controller,
          validator: (value) =>
              (_q413Controller.value == -1) ? "Required" : null,
        ),
      ],
    );
  }

  // Section 3: Collection and processing

  Widget _buildSection5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ensure that the  guardian understands the information sheet by reading it or allowing them  time to read it Then ask for written consent using the procedures in SOP 1',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        MyFormRadoButton(
          title: 'Q501. 1	Has the guardian been able to sign the consent form?',
          options: {1: 'Yes', 2: 'No'},
          controller: _q501Controller,
          callback: () {
            if (_q501Controller.value == 1) {
              _q502aController.text = DateFormat(
                'yyyy-MM-dd',
              ).format(DateTime.now());
              _q502bController.text = DateFormat(
                'HH:mm',
              ).format(DateTime.now());
              _endDT.clear();
            } else {
              _q502aController.clear();
              _q502bController.clear();
              _endDT.text = DateFormat(
                'yyyy-MM-dd HH:mm',
              ).format(DateTime.now());
            }
            setState(() {});
          },
          validator: (value) =>
              (_q501Controller.value == -1) ? "Required" : null,
        ),
        QuestionContainerWidget(
          question: 'Q502a. Date of consent (autofilled)',
          answer: Text(_q502aController.text),
        ),
        QuestionContainerWidget(
          question: 'Q502b. Time of consent (autofilled)',
          answer: Text(_q502bController.text),
        ),
      ],
    );
  }

  Widget _buildSection6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyFormRadoButton(
          title:
              'Q601. Do you want to randomize the participant into the study?',
          options: {1: 'Yes', 2: 'No'},
          controller: _q601Controller,
          callback: () {
            _endDT.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
            if (_q601Controller.value == 1) {
              _q602Controller.text = '${infantModel.babyPid}';
            } else {
              _q602Controller.clear();
            }
            setState(() {});
          },
          validator: (value) =>
              (_q601Controller.value == -1) ? "Required" : null,
        ),

        if (_q601Controller.value == 1) ...[
          QuestionContainerWidget(
            question: 'Q602. Participant ID (autofilled)',
            answer: Text(_q602Controller.text),
          ),
          const SizedBox(height: 32),
          Center(
            child: CustomButton(
              text: 'Open SES Form',
              onPressed: () {
                Get.toNamed(AppRoutes.ASSETFORMSCREEN, arguments: infantModel);
              },
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
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
                final isAssetFilled = await AssetDb.instance.checkFormExists(
                  infantModel.infantId ?? '',
                );
                if (activeSection == 6 &&
                    !isAssetFilled &&
                    _q601Controller.value == 1) {
                  Snackbar.show_e(
                    message: 'Please complete the asset form first',
                  );
                  return;
                }
                if (_validateCurrentSection()) {
                  await _saveCurrentSection();
                  if (activeSection == 6 || _endDT.text.isNotEmpty) {
                    _showCompletionDialog();
                  } else {
                    setState(() {
                      activeSection++;
                    });
                    _loadSectionData(activeSection);
                  }
                  if (activeSection == 4) {
                    _q402Controller.value = 1;
                    _q403Controller.value = 1;
                    _q404Controller.value = 1;
                    _q405Controller.value = 1;
                    _q411Controller.value = 2;
                    _q412Controller.value = 2;
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
              text: (activeSection == 6 || _endDT.text.isNotEmpty)
                  ? 'Save & Complete'
                  : 'Next',
              isLoading: isLoading,
              icon: (activeSection == 6 || _endDT.text.isNotEmpty)
                  ? Icons.save
                  : Icons.arrow_forward_ios,
              backgroundColor: (activeSection == 6 || _endDT.text.isNotEmpty)
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
      case 5:
        return _form5Key.currentState?.validate() ?? false;
      case 6:
        return _form6Key.currentState?.validate() ?? false;
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
    final userId = UserPrefs.userModel.userId;
    if (userId == null) {
      return;
    }
    _q101Controller.text = infantModel.householdId ?? '';
    _q102Controller.text = infantModel.siteWomanId ?? '';
    _q103Controller.text = infantModel.womanName ?? '';
    _q104Controller.text = infantModel.childName ?? '';
    _q105Controller.text = infantModel.infantId ?? '';

    _q202aController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _q202bController.text = DateFormat('HH:mm').format(DateTime.now());
    _q202cController.text = userId;

    formModel = await EnrollmentFormDb.instance.createOrIgnoreForm(
      model: EnrollmentFormModel(
        infantId: infantModel.infantId.toString().trim(),
        startDt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        q101: _q101Controller.text,
        q102: _q102Controller.text,
        q103: _q103Controller.text,
        q104: _q104Controller.text,
        q105: _q105Controller.text,

        q202a: _q202aController.text,
        q202b: _q202bController.text,
        q202c: _q202cController.text,
        father: infantModel.fatherName ?? '',
        phone: infantModel.phone ?? '',
        dob: infantModel.dob,
        userId: userId,
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
    // print(formModel!.toJson());

    _loadExistingData();
  }

  void _loadExistingData() async {
    if (formModel == null) return;

    _q202dController.set(value: formModel!.q202d);
    _q301Controller.set(value: formModel!.q301);
    _q302Controller.text = formModel!.q302 ?? '';

    _q401Controller.set(value: formModel!.q401);
    _q402Controller.set(value: formModel!.q402);
    _q403Controller.set(value: formModel!.q403);
    _q404Controller.set(value: formModel!.q404);
    _q405Controller.set(value: formModel!.q405);
    _q406Controller.set(value: formModel!.q406);
    _q407Controller.set(value: formModel!.q407);
    _q408Controller.set(value: formModel!.q408);
    _q409Controller.text = formModel!.q409 ?? '';
    _q410Controller.set(value: formModel!.q410);
    _q411Controller.set(value: formModel!.q411);
    _q412Controller.set(value: formModel!.q412);
    _q413Controller.set(value: formModel!.q413);

    _q501Controller.set(value: formModel!.q501);
    _q502aController.text = formModel!.q502a ?? '';
    _q502bController.text = formModel!.q502b ?? '';

    // _q601Controller.set(value: formModel!.q601);

    if (!mounted) {
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {});
  }

  Future<void> _saveForm() async {
    if (formModel == null) return;

    formModel = formModel!.copyWith(
      q202d: _q202dController.getValue(),
      q301: _q301Controller.getValue(),
      q302: _q302Controller.text.trim(),
      q401: _q401Controller.getValue(),
      q402: _q402Controller.getValue(),
      q403: _q403Controller.getValue(),
      q404: _q404Controller.getValue(),
      q405: _q405Controller.getValue(),
      q406: _q406Controller.getValue(),
      q407: _q407Controller.getValue(),
      q408: _q408Controller.getValue(),
      q409: _q409Controller.text.trim(),
      q410: _q410Controller.getValue(),
      q411: _q411Controller.getValue(),
      q412: _q412Controller.getValue(),
      q413: _q413Controller.getValue(),

      q501: _q501Controller.getValue(),
      q502a: _q502aController.text.trim(),
      q502b: _q502bController.text.trim(),

      q601: _q601Controller.getValue(),
      q602: _q602Controller.text.trim(),
      enDt: _endDT.text.trim(),
      syncDt: null,
    );

    if (_endDT.text.trim().isNotEmpty) {
      Position? position = await LocationService.getCurrentLocation();
      if (position == null) {
        Snackbar.show_e(message: 'Location Data Not Found');
        // return;
      } else {
        formModel = formModel!.copyWith(
          lat: position.latitude.toStringAsFixed(6),
          lng: position.longitude.toStringAsFixed(6),
          syncDt: null,
        );
      }
    }
    // print('Saving form: ${formModel!.toJson()}');

    await EnrollmentFormDb.instance.updateForm(formModel!);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Completed'),
        content: const Text('Thank you for completing the Enrollment form.'),
        actions: [
          TextButton(
            onPressed: () async {
              PendingInfantController.to.fetchTodoEnrollmentList();
              Navigator.pop(context);
              Navigator.pop(context);
              formModel = formModel!.copyWith(visitWeek: '02', syncDt: null);
              if (_q602Controller.text.isNotEmpty) {
                Get.toNamed(
                  AppRoutes.GROWTHMONITORINGFORM,
                  arguments: formModel,
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void checkEligibility() async {
    print('--checking eligibility');

    if (_q401Controller.value == 1 &&
        _q402Controller.value == 1 &&
        _q403Controller.value == 1 &&
        _q404Controller.value == 1 &&
        _q405Controller.value == 1 &&
        _q406Controller.value == 1 &&
        _q407Controller.value == 1 &&
        _q408Controller.value == 2 &&
        _q410Controller.value == 2 &&
        _q411Controller.value == 2 &&
        _q412Controller.value == 2) {
      _q413Controller.value = 1;
      _endDT.clear();
    } else if (_q401Controller.value != -1 &&
        _q402Controller.value != -1 &&
        _q403Controller.value != -1 &&
        _q404Controller.value != -1 &&
        _q405Controller.value != -1 &&
        _q406Controller.value != -1 &&
        _q407Controller.value != -1 &&
        _q408Controller.value != -1 &&
        _q410Controller.value != -1 &&
        _q411Controller.value != -1 &&
        _q412Controller.value != -1) {
      _q413Controller.value = 2;
      _endDT.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    }
    print(_q413Controller.value);
    setState(() {});
  }
}
