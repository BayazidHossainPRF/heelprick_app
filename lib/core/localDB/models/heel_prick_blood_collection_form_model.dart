import '../fields/heel_prick_blood_collection_form_fields.dart';

class HeelPrickBloodCollectionFormModel {
  // Metadata fields
  final String infantId;
  final String pregSl;
  final String visitType;
  final String visitDate;
  final String? syncDt;

  // Section 1: Identification
  final String? q1_a; // Site name
  final String? q1_b; // Participant ID/Infants ID
  final String? q1_c; // Child Name
  final String? q1_d; // Date of birth

  // Section 2: Consent
  final String? q2; // Has the guardian been able to sign the consent form?
  final String? q2_a; // Date of consent
  final String? q2_b; // Time of consent
  final String? q2_c; // consent no reason
  final String? q2_c_sp; // consent no reason specify

  // Section 3: Collection and processing
  final String? q3_a; // Type of visit
  final String? q3_b; // Sample collected
  final String? q3_c; // Reasons for not collection
  final String? q3_c_other; // Other reason specify
  final String? q3_d; // Sample ID
  final String? q3_e; // Date of sample collection
  final String? q3_f; // Time of sample collection
  final String? q3_g; // Place of sample collection
  final String? q3_g_other; // Other place specify
  final String? q3_h; // How many circles in Whatman card filled
  final String? q3_i; // Number of satisfactory circles
  final String? q3_j; // Number of unsatisfactory circles
  final String? q3_k; // Appropriately dried the Whatman card
  final String? q3_l; // Stored in the freezer
  final String? q3_m; // Code of the lab staff

  // Location
  final String? lat;
  final String? lng;
  final String? endDate;

  HeelPrickBloodCollectionFormModel({
    required this.infantId,
    required this.pregSl,
    required this.visitType,
    required this.visitDate,
    this.syncDt,
    // Section 1
    this.q1_a,
    this.q1_b,
    this.q1_c,
    this.q1_d,
    // Section 2
    this.q2,
    this.q2_a,
    this.q2_b,
      this.q2_c,
      this.q2_c_sp,
    // Section 3
    this.q3_a,
    this.q3_b,
    this.q3_c,
    this.q3_c_other,
    this.q3_d,
    this.q3_e,
    this.q3_f,
    this.q3_g,
    this.q3_g_other,
    this.q3_h,
    this.q3_i,
    this.q3_j,
    this.q3_k,
    this.q3_l,
    this.q3_m,
    // Location
    this.lat,
    this.lng,
      this.endDate,
  });

  factory HeelPrickBloodCollectionFormModel.fromJson(Map<String, dynamic> json) {
    return HeelPrickBloodCollectionFormModel(
      // Metadata
      infantId: json[HeelPrickBloodCollectionFormFields.infantId],
      pregSl: json[HeelPrickBloodCollectionFormFields.pregSl],
      visitType: json[HeelPrickBloodCollectionFormFields.visitType],
      visitDate: json[HeelPrickBloodCollectionFormFields.visitDate],
      syncDt: json[HeelPrickBloodCollectionFormFields.syncDt],
      // Section 1
      q1_a: json[HeelPrickBloodCollectionFormFields.q1_a],
      q1_b: json[HeelPrickBloodCollectionFormFields.q1_b],
      q1_c: json[HeelPrickBloodCollectionFormFields.q1_c],
      q1_d: json[HeelPrickBloodCollectionFormFields.q1_d],
      // Section 2
      q2: json[HeelPrickBloodCollectionFormFields.q2],
      q2_a: json[HeelPrickBloodCollectionFormFields.q2_a],
      q2_b: json[HeelPrickBloodCollectionFormFields.q2_b],
      q2_c: json[HeelPrickBloodCollectionFormFields.q2_c],
      q2_c_sp: json[HeelPrickBloodCollectionFormFields.q2_c_sp],
      // Section 3
      q3_a: json[HeelPrickBloodCollectionFormFields.q3_a],
      q3_b: json[HeelPrickBloodCollectionFormFields.q3_b],
      q3_c: json[HeelPrickBloodCollectionFormFields.q3_c],
      q3_c_other: json[HeelPrickBloodCollectionFormFields.q3_c_other],
      q3_d: json[HeelPrickBloodCollectionFormFields.q3_d],
      q3_e: json[HeelPrickBloodCollectionFormFields.q3_e],
      q3_f: json[HeelPrickBloodCollectionFormFields.q3_f],
      q3_g: json[HeelPrickBloodCollectionFormFields.q3_g],
      q3_g_other: json[HeelPrickBloodCollectionFormFields.q3_g_other],
      q3_h: json[HeelPrickBloodCollectionFormFields.q3_h],
      q3_i: json[HeelPrickBloodCollectionFormFields.q3_i],
      q3_j: json[HeelPrickBloodCollectionFormFields.q3_j],
      q3_k: json[HeelPrickBloodCollectionFormFields.q3_k],
      q3_l: json[HeelPrickBloodCollectionFormFields.q3_l],
      q3_m: json[HeelPrickBloodCollectionFormFields.q3_m],
      // Location
      lat: json[HeelPrickBloodCollectionFormFields.lat],
      lng: json[HeelPrickBloodCollectionFormFields.lng],
      endDate: json[HeelPrickBloodCollectionFormFields.endDate],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Metadata
      HeelPrickBloodCollectionFormFields.infantId: infantId,
      HeelPrickBloodCollectionFormFields.pregSl: pregSl,
      HeelPrickBloodCollectionFormFields.visitType: visitType,
      HeelPrickBloodCollectionFormFields.visitDate: visitDate,
      HeelPrickBloodCollectionFormFields.syncDt: syncDt,
      // Section 1
      HeelPrickBloodCollectionFormFields.q1_a: q1_a,
      HeelPrickBloodCollectionFormFields.q1_b: q1_b,
      HeelPrickBloodCollectionFormFields.q1_c: q1_c,
      HeelPrickBloodCollectionFormFields.q1_d: q1_d,
      // Section 2
      HeelPrickBloodCollectionFormFields.q2: q2,
      HeelPrickBloodCollectionFormFields.q2_a: q2_a,
      HeelPrickBloodCollectionFormFields.q2_b: q2_b,
      HeelPrickBloodCollectionFormFields.q2_c: q2_c,
      HeelPrickBloodCollectionFormFields.q2_c_sp: q2_c_sp,
      // Section 3
      HeelPrickBloodCollectionFormFields.q3_a: q3_a,
      HeelPrickBloodCollectionFormFields.q3_b: q3_b,
      HeelPrickBloodCollectionFormFields.q3_c: q3_c,
      HeelPrickBloodCollectionFormFields.q3_c_other: q3_c_other,
      HeelPrickBloodCollectionFormFields.q3_d: q3_d,
      HeelPrickBloodCollectionFormFields.q3_e: q3_e,
      HeelPrickBloodCollectionFormFields.q3_f: q3_f,
      HeelPrickBloodCollectionFormFields.q3_g: q3_g,
      HeelPrickBloodCollectionFormFields.q3_g_other: q3_g_other,
      HeelPrickBloodCollectionFormFields.q3_h: q3_h,
      HeelPrickBloodCollectionFormFields.q3_i: q3_i,
      HeelPrickBloodCollectionFormFields.q3_j: q3_j,
      HeelPrickBloodCollectionFormFields.q3_k: q3_k,
      HeelPrickBloodCollectionFormFields.q3_l: q3_l,
      HeelPrickBloodCollectionFormFields.q3_m: q3_m,
      // Location
      HeelPrickBloodCollectionFormFields.lat: lat,
      HeelPrickBloodCollectionFormFields.lng: lng,
      HeelPrickBloodCollectionFormFields.endDate: endDate,
    };
  }

  HeelPrickBloodCollectionFormModel copyWith({
    // Metadata
    String? infantId,
    String? pregSl,
    String? visitType,
    String? visitDate,
    String? syncDt,
    // Section 1
    String? q1_a,
    String? q1_b,
    String? q1_c,
    String? q1_d,
    // Section 2
    String? q2,
    String? q2_a,
    String? q2_b,
    String? q2_c,
    String? q2_c_sp,
    // Section 3
    String? q3_a,
    String? q3_b,
    String? q3_c,
    String? q3_c_other,
    String? q3_d,
    String? q3_e,
    String? q3_f,
    String? q3_g,
    String? q3_g_other,
    String? q3_h,
    String? q3_i,
    String? q3_j,
    String? q3_k,
    String? q3_l,
    String? q3_m,
    // Location
    String? lat,
    String? lng,
    String? endDate,
  }) {
    return HeelPrickBloodCollectionFormModel(
      // Metadata
      infantId: infantId ?? this.infantId,
      pregSl: pregSl??this.pregSl,
      visitType: visitType ?? this.visitType,
      visitDate: visitDate ?? this.visitDate,
      syncDt: syncDt ?? this.syncDt,
      // Section 1
      q1_a: q1_a ?? this.q1_a,
      q1_b: q1_b ?? this.q1_b,
      q1_c: q1_c ?? this.q1_c,
      q1_d: q1_d ?? this.q1_d,
      // Section 2
      q2: q2 ?? this.q2,
      q2_a: q2_a ?? this.q2_a,
      q2_b: q2_b ?? this.q2_b,
      q2_c: q2_c ?? this.q2_c,
      q2_c_sp: q2_c_sp ?? this.q2_c_sp,
      // Section 3
      q3_a: q3_a ?? this.q3_a,
      q3_b: q3_b ?? this.q3_b,
      q3_c: q3_c ?? this.q3_c,
      q3_c_other: q3_c_other ?? this.q3_c_other,
      q3_d: q3_d ?? this.q3_d,
      q3_e: q3_e ?? this.q3_e,
      q3_f: q3_f ?? this.q3_f,
      q3_g: q3_g ?? this.q3_g,
      q3_g_other: q3_g_other ?? this.q3_g_other,
      q3_h: q3_h ?? this.q3_h,
      q3_i: q3_i ?? this.q3_i,
      q3_j: q3_j ?? this.q3_j,
      q3_k: q3_k ?? this.q3_k,
      q3_l: q3_l ?? this.q3_l,
      q3_m: q3_m ?? this.q3_m,
      // Location
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      endDate: endDate ?? this.endDate,
    );
  }
}