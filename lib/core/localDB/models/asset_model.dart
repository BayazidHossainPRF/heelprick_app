import '../fields/asset_fields.dart';

class AssetModel {
  final String? infantId;

  // Section 1: ID and visit details
  final String? q101; // Study ID
  final String? q102; // PID (auto-filled)
  final String? q103; // CID (auto-filled)
  final String? q104; // Name of Pregnant woman (auto-filled)
  final String? q105; // Husband's name (auto-filled)
  final String? q106; // Field work area code (auto-filled)
  final String? q107; // Date of data collection
  final String? q108; // Time of data collection
  final String? q109; // CHW's code

  // Section 2: Asset list
  final String? q201; // Main source of drinking water
  final String? q202; // If water source "other", specify
  final String? q203; // Type of toilet facility
  final String? q204; // If toilet facility "other", specify
  final String? q205; // How many people usually sleep in the house
  final String? q206; // How many rooms used for sleeping
  final String? q207; // Main material of the floor
  final String? q208; // If floor material "other", specify
  final String? q209; // Main material of the walls
  final String? q210; // If wall material "other", specify
  final String? q211; // Main material of the roof
  final String? q212; // If roof material "other", specify
  final String? q213; // Does anyone own agricultural land
  final String? q215; // Color / flat screen television
  final String? q216; // Internet connection
  final String? q217; // Refrigerator
  final String? q218; // Wristwatch or clock
  final String? q219; // Motorcycle or scooter
  final String? q220; // Water pump (only for this household)
  final String? q221; // Solar plant / solar electricity
  final String? q222; // Cabinet / Almirah / Wardrobe
  final String? q223; // Sofa
  final String? q224; // Divider / piece of wood / cardboard / metal
  final String? q225;
  // Location
  final String? lat;
  final String? lng;

  // Meta fields
  final String? entryUserId;
  final String? entryDate;
  final String? startDT;
  final String? endDT;
  final String? syncDt;

  AssetModel({
    this.infantId,
    // Section 1
    this.q101,
    this.q102,
    this.q103,
    this.q104,
    this.q105,
    this.q106,
    this.q107,
    this.q108,
    this.q109,
    // Section 2
    this.q201,
    this.q202,
    this.q203,
    this.q204,
    this.q205,
    this.q206,
    this.q207,
    this.q208,
    this.q209,
    this.q210,
    this.q211,
    this.q212,
    this.q213,
    this.q215,
    this.q216,
    this.q217,
    this.q218,
    this.q219,
    this.q220,
    this.q221,
    this.q222,
    this.q223,
    this.q224,
    this.q225,
    // Location
    this.lat,
    this.lng,
    // Meta
    this.entryUserId,
    this.entryDate,
    this.startDT,
    this.endDT,
    this.syncDt,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      infantId: json[AssetFields.infantId],

      // Section 1
      q101: json[AssetFields.q101],
      q102: json[AssetFields.q102],
      q103: json[AssetFields.q103],
      q104: json[AssetFields.q104],
      q105: json[AssetFields.q105],
      q106: json[AssetFields.q106],
      q107: json[AssetFields.q107],
      q108: json[AssetFields.q108],
      q109: json[AssetFields.q109],

      // Section 2
      q201: json[AssetFields.q201],
      q202: json[AssetFields.q202],
      q203: json[AssetFields.q203],
      q204: json[AssetFields.q204],
      q205: json[AssetFields.q205],
      q206: json[AssetFields.q206],
      q207: json[AssetFields.q207],
      q208: json[AssetFields.q208],
      q209: json[AssetFields.q209],
      q210: json[AssetFields.q210],
      q211: json[AssetFields.q211],
      q212: json[AssetFields.q212],
      q213: json[AssetFields.q213],
      q215: json[AssetFields.q215],
      q216: json[AssetFields.q216],
      q217: json[AssetFields.q217],
      q218: json[AssetFields.q218],
      q219: json[AssetFields.q219],
      q220: json[AssetFields.q220],
      q221: json[AssetFields.q221],
      q222: json[AssetFields.q222],
      q223: json[AssetFields.q223],
      q224: json[AssetFields.q224],
      q225: json[AssetFields.q225],

      // Location
      lat: json[AssetFields.lat],
      lng: json[AssetFields.lng],

      // Meta
      entryUserId: json[AssetFields.entryUserId],
      entryDate: json[AssetFields.entryDate],
      startDT: json[AssetFields.startDT],
      endDT: json[AssetFields.endDT],
      syncDt: json[AssetFields.syncDt],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AssetFields.infantId: infantId,

      // Section 1
      AssetFields.q101: q101,
      AssetFields.q102: q102,
      AssetFields.q103: q103,
      AssetFields.q104: q104,
      AssetFields.q105: q105,
      AssetFields.q106: q106,
      AssetFields.q107: q107,
      AssetFields.q108: q108,
      AssetFields.q109: q109,

      // Section 2
      AssetFields.q201: q201,
      AssetFields.q202: q202,
      AssetFields.q203: q203,
      AssetFields.q204: q204,
      AssetFields.q205: q205,
      AssetFields.q206: q206,
      AssetFields.q207: q207,
      AssetFields.q208: q208,
      AssetFields.q209: q209,
      AssetFields.q210: q210,
      AssetFields.q211: q211,
      AssetFields.q212: q212,
      AssetFields.q213: q213,
      AssetFields.q215: q215,
      AssetFields.q216: q216,
      AssetFields.q217: q217,
      AssetFields.q218: q218,
      AssetFields.q219: q219,
      AssetFields.q220: q220,
      AssetFields.q221: q221,
      AssetFields.q222: q222,
      AssetFields.q223: q223,
      AssetFields.q224: q224,
      AssetFields.q225: q225,

      // Location
      AssetFields.lat: lat,
      AssetFields.lng: lng,

      // Meta
      AssetFields.entryUserId: entryUserId,
      AssetFields.entryDate: entryDate,
      AssetFields.startDT: startDT,
      AssetFields.endDT: endDT,
      AssetFields.syncDt: syncDt,
    };
  }

  AssetModel copyWith({
    String? infantId,
    // Section 1
    String? q101,
    String? q102,
    String? q103,
    String? q104,
    String? q105,
    String? q106,
    String? q107,
    String? q108,
    String? q109,
    // Section 2
    String? q201,
    String? q202,
    String? q203,
    String? q204,
    String? q205,
    String? q206,
    String? q207,
    String? q208,
    String? q209,
    String? q210,
    String? q211,
    String? q212,
    String? q213,
    String? q215,
    String? q216,
    String? q217,
    String? q218,
    String? q219,
    String? q220,
    String? q221,
    String? q222,
    String? q223,
    String? q224,
    String? q225,
    // Location
    String? lat,
    String? lng,
    // Meta
    String? entryUserId,
    String? entryDate,
    String? editUserId,
    String? editDate,
    String? startDT,
    String? endDT,
   required String? syncDt,
  }) {
    return AssetModel(
      infantId: infantId ?? this.infantId,
      // Section 1
      q101: q101 ?? this.q101,
      q102: q102 ?? this.q102,
      q103: q103 ?? this.q103,
      q104: q104 ?? this.q104,
      q105: q105 ?? this.q105,
      q106: q106 ?? this.q106,
      q107: q107 ?? this.q107,
      q108: q108 ?? this.q108,
      q109: q109 ?? this.q109,
      // Section 2
      q201: q201 ?? this.q201,
      q202: q202 ?? this.q202,
      q203: q203 ?? this.q203,
      q204: q204 ?? this.q204,
      q205: q205 ?? this.q205,
      q206: q206 ?? this.q206,
      q207: q207 ?? this.q207,
      q208: q208 ?? this.q208,
      q209: q209 ?? this.q209,
      q210: q210 ?? this.q210,
      q211: q211 ?? this.q211,
      q212: q212 ?? this.q212,
      q213: q213 ?? this.q213,
      q215: q215 ?? this.q215,
      q216: q216 ?? this.q216,
      q217: q217 ?? this.q217,
      q218: q218 ?? this.q218,
      q219: q219 ?? this.q219,
      q220: q220 ?? this.q220,
      q221: q221 ?? this.q221,
      q222: q222 ?? this.q222,
      q223: q223 ?? this.q223,
      q224: q224 ?? this.q224,
      q225: q225 ?? this.q225,
      // Location
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      // Meta
      entryUserId: entryUserId ?? this.entryUserId,
      entryDate: entryDate ?? this.entryDate,
      startDT: startDT ?? this.startDT,
      endDT: endDT ?? this.endDT,
      syncDt: syncDt ?? this.syncDt,
    );
  }
}
