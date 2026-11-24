import '../fields/enrollment_form_field.dart';

class EnrollmentFormModel {
  // Section 1
  final String? q101;
  final String? q102;
  final String? q103;
  final String? q104;
  final String? q105;

  // Section 2
  final String? q202a;
  final String? q202b;
  final String? q202c;
  final String? q202d;

  // Section 3
  final String? q301;
  final String? q302;

  // Section 4
  final String? q401;
  final String? q402;
  final String? q403;
  final String? q404;
  final String? q405;
  final String? q406;
  final String? q407;
  final String? q408;
  final String? q409;
  final String? q410;
  final String? q411;
  final String? q412;
  final String? q413;

  // Section 5
  final String? q501;
  final String? q502a;
  final String? q502b;

  final String? q601;
  final String? q602;

  // Metadata
  final String infantId;
  final String pregSl;
  final String? father;
  final String? phone;
  final String? dob;
  final String? userId;
  final String? startDt;
  final String? enDt;
  final String? lat;
  final String? lng;
  final String? syncDt;
  final String? visitWeek;

  EnrollmentFormModel({
    // Section 1
    this.q101,
    this.q102,
    this.q103,
    this.q104,
    this.q105,

    // Section 2
    this.q202a,
    this.q202b,
    this.q202c,
    this.q202d,

    // Section 3
    this.q301,
    this.q302,

    // Section 4
    this.q401,
    this.q402,
    this.q403,
    this.q404,
    this.q405,
    this.q406,
    this.q407,
    this.q408,
    this.q409,
    this.q410,
    this.q411,
    this.q412,
    this.q413,

    // Section 5
    this.q501,
    this.q502a,
    this.q502b,

    this.q601,
    this.q602,

    // Metadata
    required this.infantId,
    required this.pregSl,
    this.father,
    this.phone,
    this.dob,
    this.userId,
    this.startDt,
    this.enDt,
    this.lat,
    this.lng,
    this.syncDt,
    this.visitWeek,
  });

  factory EnrollmentFormModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentFormModel(
      // Section 1
      q101: json[EnrollmentFormField.q101],
      q102: json[EnrollmentFormField.q102],
      q103: json[EnrollmentFormField.q103],
      q104: json[EnrollmentFormField.q104],
      q105: json[EnrollmentFormField.q105],

      // Section 2
      q202a: json[EnrollmentFormField.q202a],
      q202b: json[EnrollmentFormField.q202b],
      q202c: json[EnrollmentFormField.q202c],
      q202d: json[EnrollmentFormField.q202d],

      // Section 3
      q301: json[EnrollmentFormField.q301],
      q302: json[EnrollmentFormField.q302],

      // Section 4
      q401: json[EnrollmentFormField.q401],
      q402: json[EnrollmentFormField.q402],
      q403: json[EnrollmentFormField.q403],
      q404: json[EnrollmentFormField.q404],
      q405: json[EnrollmentFormField.q405],
      q406: json[EnrollmentFormField.q406],
      q407: json[EnrollmentFormField.q407],
      q408: json[EnrollmentFormField.q408],
      q409: json[EnrollmentFormField.q409],
      q410: json[EnrollmentFormField.q410],
      q411: json[EnrollmentFormField.q411],
      q412: json[EnrollmentFormField.q412],
      q413: json[EnrollmentFormField.q413],

      // Section 5
      q501: json[EnrollmentFormField.q501],
      q502a: json[EnrollmentFormField.q502a],
      q502b: json[EnrollmentFormField.q502b],

      q601: json[EnrollmentFormField.q601],
      q602: json[EnrollmentFormField.q602],

      // Metadata
      infantId: json[EnrollmentFormField.infantId],
      pregSl: json[EnrollmentFormField.pregSL],
      father: json[EnrollmentFormField.father],
      phone: json[EnrollmentFormField.phone],
      dob: json[EnrollmentFormField.dob],
      userId: json[EnrollmentFormField.userId],
      startDt: json[EnrollmentFormField.startDt],
      enDt: json[EnrollmentFormField.enDt],
      lat: json[EnrollmentFormField.lat],
      lng: json[EnrollmentFormField.lng],
      syncDt: json[EnrollmentFormField.syncDt],
      visitWeek: json[EnrollmentFormField.visitWeek],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Section 1
      EnrollmentFormField.q101: q101,
      EnrollmentFormField.q102: q102,
      EnrollmentFormField.q103: q103,
      EnrollmentFormField.q104: q104,
      EnrollmentFormField.q105: q105,

      // Section 2
      EnrollmentFormField.q202a: q202a,
      EnrollmentFormField.q202b: q202b,
      EnrollmentFormField.q202c: q202c,
      EnrollmentFormField.q202d: q202d,

      // Section 3
      EnrollmentFormField.q301: q301,
      EnrollmentFormField.q302: q302,

      // Section 4
      EnrollmentFormField.q401: q401,
      EnrollmentFormField.q402: q402,
      EnrollmentFormField.q403: q403,
      EnrollmentFormField.q404: q404,
      EnrollmentFormField.q405: q405,
      EnrollmentFormField.q406: q406,
      EnrollmentFormField.q407: q407,
      EnrollmentFormField.q408: q408,
      EnrollmentFormField.q409: q409,
      EnrollmentFormField.q410: q410,
      EnrollmentFormField.q411: q411,
      EnrollmentFormField.q412: q412,
      EnrollmentFormField.q413: q413,

      // Section 5
      EnrollmentFormField.q501: q501,
      EnrollmentFormField.q502a: q502a,
      EnrollmentFormField.q502b: q502b,

      EnrollmentFormField.q601: q601,
      EnrollmentFormField.q602: q602,

      // Metadata
      EnrollmentFormField.infantId: infantId,
      EnrollmentFormField.pregSL: pregSl,
      EnrollmentFormField.father: father,
      EnrollmentFormField.phone: phone,
      EnrollmentFormField.dob: dob,
      EnrollmentFormField.userId: userId,
      EnrollmentFormField.startDt: startDt,
      EnrollmentFormField.enDt: enDt,
      EnrollmentFormField.lat: lat,
      EnrollmentFormField.lng: lng,
      EnrollmentFormField.syncDt: syncDt,
    };
  }

  EnrollmentFormModel copyWith({
    // Section 1
    String? q101,
    String? q102,
    String? q103,
    String? q104,
    String? q105,

    // Section 2
    String? q202a,
    String? q202b,
    String? q202c,
    String? q202d,

    // Section 3
    String? q301,
    String? q302,

    // Section 4
    String? q401,
    String? q402,
    String? q403,
    String? q404,
    String? q405,
    String? q406,
    String? q407,
    String? q408,
    String? q409,
    String? q410,
    String? q411,
    String? q412,
    String? q413,

    // Section 5
    String? q501,
    String? q502a,
    String? q502b,

    String? q601,
    String? q602,

    // Metadata
    String? infantId,
    String? pregSl,
    String? father,
    String? phone,
    String? dob,
    String? userId,
    String? startDt,
    String? enDt,
    String? lat,
    String? lng,
    String? visitWeek,
    required String? syncDt,
  }) {
    return EnrollmentFormModel(
      // Section 1
      q101: q101 ?? this.q101,
      q102: q102 ?? this.q102,
      q103: q103 ?? this.q103,
      q104: q104 ?? this.q104,
      q105: q105 ?? this.q105,

      // Section 2
      q202a: q202a ?? this.q202a,
      q202b: q202b ?? this.q202b,
      q202c: q202c ?? this.q202c,
      q202d: q202d ?? this.q202d,

      // Section 3
      q301: q301 ?? this.q301,
      q302: q302 ?? this.q302,

      // Section 4
      q401: q401 ?? this.q401,
      q402: q402 ?? this.q402,
      q403: q403 ?? this.q403,
      q404: q404 ?? this.q404,
      q405: q405 ?? this.q405,
      q406: q406 ?? this.q406,
      q407: q407 ?? this.q407,
      q408: q408 ?? this.q408,
      q409: q409 ?? this.q409,
      q410: q410 ?? this.q410,
      q411: q411 ?? this.q411,
      q412: q412 ?? this.q412,
      q413: q413 ?? this.q413,

      // Section 5
      q501: q501 ?? this.q501,
      q502a: q502a ?? this.q502a,
      q502b: q502b ?? this.q502b,

      q601: q601 ?? this.q601,
      q602: q602 ?? this.q602,

      // Metadata
      infantId: infantId ?? this.infantId,
      pregSl: pregSl ?? this.pregSl,
      father: father ?? this.father,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      userId: userId ?? this.userId,
      startDt: startDt ?? this.startDt,
      enDt: enDt ?? this.enDt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      visitWeek: visitWeek ?? this.visitWeek,
      syncDt: syncDt,
    );
  }
}
