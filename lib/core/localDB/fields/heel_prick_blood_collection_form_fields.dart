class HeelPrickBloodCollectionFormFields {
  static const String TABLE_NAME = 'tbl_heel_prick_blood_collection_form';
  static final List<String> values = [
    // Metadata
    infantId,
    visitType,
    visitDate,
    syncDt,

    // Section 1: Identification
    q1_a, // Site name
    q1_b, // Participant ID/Infants ID
    q1_c, // Child Name
    q1_d, // Date of birth
    // Section 2: Consent
    q2, // Has the guardian been able to sign the consent form?
    q2_a, // Date of consent
    q2_b, // Time of consent
    q2_c, // consent no reason
    q2_c_sp, // consent no reason specify
    // Section 3: Collection and processing
    q3_a, // Type of visit
    q3_b, // Sample collected
    q3_c, // Reasons for not collection
    q3_c_other, // Other reason specify
    q3_d, // Sample ID
    q3_e, // Date of sample collection
    q3_f, // Time of sample collection
    q3_g, // Place of sample collection
    q3_g_other, // Other place specify
    q3_h, // How many circles in Whatman card filled
    q3_i, // Number of satisfactory circles
    q3_j, // Number of unsatisfactory circles
    q3_k, // Appropriately dried the Whatman card
    q3_l, // Stored in the freezer
    q3_m, // Code of the lab staff
    // Location
    lat,
    lng,
    endDate,
  ];

  // Metadata fields
  static const String infantId = 'infant_id';
  static const String visitType = 'visit_type';
  static const String visitDate = 'visit_date';
  static const String syncDt = 'sync_dt';

  // Section 1: Identification
  static const String q1_a = 'q1_a'; // Site name
  static const String q1_b = 'q1_b'; // Participant ID/Infants ID
  static const String q1_c = 'q1_c'; // Child Name
  static const String q1_d = 'q1_d'; // Date of birth

  // Section 2: Consent
  static const String q2 =
      'q2'; // Has the guardian been able to sign the consent form?
  static const String q2_a = 'q2_a'; // Date of consent
  static const String q2_b = 'q2_b'; // Time of consent
  static const String q2_c = 'q2_c'; // consent no reason
  static const String q2_c_sp = 'q2_c_sp'; // consent no reason

  // Section 3: Collection and processing
  static const String q3_a = 'q3_a'; // Type of visit
  static const String q3_b = 'q3_b'; // Sample collected
  static const String q3_c = 'q3_c'; // Reasons for not collection
  static const String q3_c_other = 'q3_c_other'; // Other reason specify
  static const String q3_d = 'q3_d'; // Sample ID
  static const String q3_e = 'q3_e'; // Date of sample collection
  static const String q3_f = 'q3_f'; // Time of sample collection
  static const String q3_g = 'q3_g'; // Place of sample collection
  static const String q3_g_other = 'q3_g_other'; // Other place specify
  static const String q3_h = 'q3_h'; // How many circles in Whatman card filled
  static const String q3_i = 'q3_i'; // Number of satisfactory circles
  static const String q3_j = 'q3_j'; // Number of unsatisfactory circles
  static const String q3_k = 'q3_k'; // Appropriately dried the Whatman card
  static const String q3_l = 'q3_l'; // Stored in the freezer
  static const String q3_m = 'q3_m'; // Code of the lab staff

  // Location
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String endDate = 'end_date';
}
