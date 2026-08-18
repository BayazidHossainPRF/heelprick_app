class AssetFields {
  static const String TABLE_NAME = 'tbl_heel_prick_asset';
  static final List<String> values = [
    // Metadata
    infantId,
    startDT,
    endDT,
    entryUserId,
    entryDate,
    syncDt,

    // Section 1: ID and visit details
    q101, // Study ID
    q102, // PID (auto-filled)
    q103, // CID (auto-filled)
    q104, // Name of Pregnant woman (auto-filled)
    q105, // Husband's name (auto-filled)
    q106, // Field work area code (auto-filled)
    q107, // Date of data collection
    q108, // Time of data collection
    q109, // CHW's code
    // Section 2: Asset list
    q201, // Main source of drinking water
    q202, // If water source "other", specify
    q203, // Type of toilet facility
    q204, // If toilet facility "other", specify
    q205, // How many people usually sleep in the house
    q206, // How many rooms used for sleeping
    q207, // Main material of the floor
    q208, // If floor material "other", specify
    q209, // Main material of the walls
    q210, // If wall material "other", specify
    q211, // Main material of the roof
    q212, // If roof material "other", specify
    q213, // Does anyone own agricultural land
    q215, // Color / flat screen television
    q216, // Internet connection
    q217, // Refrigerator
    q218, // Wristwatch or clock
    q219, // Motorcycle or scooter
    q220, // Water pump (only for this household)
    q221, // Solar plant / solar electricity
    q222, // Cabinet / Almirah / Wardrobe
    q223, // Sofa
    q224, // Divider / piece of wood / cardboard / metal
    q225,
    // Location
    lat,
    lng,
  ];

  // Metadata fields
  static const String infantId = 'infantId';
  static const String startDT = 'start_dt';
  static const String endDT = 'end_dt';
  static const String entryUserId = 'entry_user_id';
  static const String entryDate = 'entry_date';
  static const String syncDt = 'sync_dt';

  // Section 1: ID and visit details
  static const String q101 = 'q101'; // Study ID
  static const String q102 = 'q102'; // PID
  static const String q103 = 'q103'; // CID
  static const String q104 = 'q104'; // Name of Pregnant woman
  static const String q105 = 'q105'; // Husband's name
  static const String q106 = 'q106'; // Field work area code
  static const String q107 = 'q107'; // Date of data collection
  static const String q108 = 'q108'; // Time of data collection
  static const String q109 = 'q109'; // CHW's code

  // Section 2: Asset list
  static const String q201 = 'q201'; // Main source of drinking water
  static const String q202 = 'q202'; // If water source "other", specify
  static const String q203 = 'q203'; // Type of toilet facility
  static const String q204 = 'q204'; // If toilet facility "other", specify
  static const String q205 =
      'q205'; // How many people usually sleep in the house
  static const String q206 = 'q206'; // How many rooms used for sleeping
  static const String q207 = 'q207'; // Main material of the floor
  static const String q208 = 'q208'; // If floor material "other", specify
  static const String q209 = 'q209'; // Main material of the walls
  static const String q210 = 'q210'; // If wall material "other", specify
  static const String q211 = 'q211'; // Main material of the roof
  static const String q212 = 'q212'; // If roof material "other", specify
  static const String q213 = 'q213'; // Does anyone own agricultural land
  static const String q215 = 'q215'; // Color / flat screen television
  static const String q216 = 'q216'; // Internet connection
  static const String q217 = 'q217'; // Refrigerator
  static const String q218 = 'q218'; // Wristwatch or clock
  static const String q219 = 'q219'; // Motorcycle or scooter
  static const String q220 = 'q220'; // Water pump (only for this household)
  static const String q221 = 'q221'; // Solar plant / solar electricity
  static const String q222 = 'q222'; // Cabinet / Almirah / Wardrobe
  static const String q223 = 'q223'; // Sofa
  static const String q224 =
      'q224'; // Divider / piece of wood / cardboard / metal
  static const String q225 = 'q225';

  // Location
  static const String lat = 'lat';
  static const String lng = 'lng';
}
