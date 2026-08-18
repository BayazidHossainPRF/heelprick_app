import '../fields/growth_and_outcome_form_field.dart';

class GrowthAndOutcomeFormModel {
  // Section 1
  final String? q101;
  final String? q105;

  // Section 2
  final String? q201;
  final String? q201a;
  final String? q201b;
  final String? q201c;
  final String? q201d;
  final String? q201e;

  // Section 3
  final String? q301;
  final String? q302;
  final String? q303;
  final String? q304;

  // Section 4
  final String? q401;
  final String? q401a;
  final String? q401b;
  final String? q402;
  final String? q402a;
  final String? q402b;
  final String? q403;
  final String? q403a;
  final String? q403b;
  final String? q404;
  final String? q404a;
  final String? q404b;

  // Metadata
  final String infantId;
  final String? userId;
  final String? startDt;
  final String? enDt;
  final String? lat;
  final String? lng;
  final String? syncDt;

  GrowthAndOutcomeFormModel({
    // Section 1
    this.q101,
    this.q105,

    // Section 2
    this.q201,
    this.q201a,
    this.q201b,
    this.q201c,
    this.q201d,
    this.q201e,

    // Section 3
    this.q301,
    this.q302,
    this.q303,
    this.q304,

    // Section 4
    this.q401,
    this.q401a,
    this.q401b,
    this.q402,
    this.q402a,
    this.q402b,
    this.q403,
    this.q403a,
    this.q403b,
    this.q404,
    this.q404a,
    this.q404b,

    // Metadata
    required this.infantId,
    this.userId,
    this.startDt,
    this.enDt,
    this.lat,
    this.lng,
    this.syncDt,
  });

  factory GrowthAndOutcomeFormModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GrowthAndOutcomeFormModel(
      // Section 1
      q101: json[GrowthAndOutcomeFormField.q101],
      q105: json[GrowthAndOutcomeFormField.q105],

      // Section 2
      q201: json[GrowthAndOutcomeFormField.q201],
      q201a: json[GrowthAndOutcomeFormField.q201a],
      q201b: json[GrowthAndOutcomeFormField.q201b],
      q201c: json[GrowthAndOutcomeFormField.q201c],
      q201d: json[GrowthAndOutcomeFormField.q201d],
      q201e: json[GrowthAndOutcomeFormField.q201e],

      // Section 3
      q301: json[GrowthAndOutcomeFormField.q301],
      q302: json[GrowthAndOutcomeFormField.q302],
      q303: json[GrowthAndOutcomeFormField.q303],
      q304: json[GrowthAndOutcomeFormField.q304],

      // Section 4
      q401: json[GrowthAndOutcomeFormField.q401],
      q401a: json[GrowthAndOutcomeFormField.q401a],
      q401b: json[GrowthAndOutcomeFormField.q401b],
      q402: json[GrowthAndOutcomeFormField.q402],
      q402a: json[GrowthAndOutcomeFormField.q402a],
      q402b: json[GrowthAndOutcomeFormField.q402b],
      q403: json[GrowthAndOutcomeFormField.q403],
      q403a: json[GrowthAndOutcomeFormField.q403a],
      q403b: json[GrowthAndOutcomeFormField.q403b],
      q404: json[GrowthAndOutcomeFormField.q404],
      q404a: json[GrowthAndOutcomeFormField.q404a],
      q404b: json[GrowthAndOutcomeFormField.q404b],

      // Metadata
      infantId: json[GrowthAndOutcomeFormField.infantId],
      userId: json[GrowthAndOutcomeFormField.userId],
      startDt: json[GrowthAndOutcomeFormField.startDt],
      enDt: json[GrowthAndOutcomeFormField.enDt],
      lat: json[GrowthAndOutcomeFormField.lat],
      lng: json[GrowthAndOutcomeFormField.lng],
      syncDt: json[GrowthAndOutcomeFormField.syncDt],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Section 1
      GrowthAndOutcomeFormField.q101: q101,
      GrowthAndOutcomeFormField.q105: q105,

      // Section 2
      GrowthAndOutcomeFormField.q201: q201,
      GrowthAndOutcomeFormField.q201a: q201a,
      GrowthAndOutcomeFormField.q201b: q201b,
      GrowthAndOutcomeFormField.q201c: q201c,
      GrowthAndOutcomeFormField.q201d: q201d,
      GrowthAndOutcomeFormField.q201e: q201e,

      // Section 3
      GrowthAndOutcomeFormField.q301: q301,
      GrowthAndOutcomeFormField.q302: q302,
      GrowthAndOutcomeFormField.q303: q303,
      GrowthAndOutcomeFormField.q304: q304,

      // Section 4
      GrowthAndOutcomeFormField.q401: q401,
      GrowthAndOutcomeFormField.q401a: q401a,
      GrowthAndOutcomeFormField.q401b: q401b,
      GrowthAndOutcomeFormField.q402: q402,
      GrowthAndOutcomeFormField.q402a: q402a,
      GrowthAndOutcomeFormField.q402b: q402b,
      GrowthAndOutcomeFormField.q403: q403,
      GrowthAndOutcomeFormField.q403a: q403a,
      GrowthAndOutcomeFormField.q403b: q403b,
      GrowthAndOutcomeFormField.q404: q404,
      GrowthAndOutcomeFormField.q404a: q404a,
      GrowthAndOutcomeFormField.q404b: q404b,

      // Metadata
      GrowthAndOutcomeFormField.infantId: infantId,
      GrowthAndOutcomeFormField.userId: userId,
      GrowthAndOutcomeFormField.startDt: startDt,
      GrowthAndOutcomeFormField.enDt: enDt,
      GrowthAndOutcomeFormField.lat: lat,
      GrowthAndOutcomeFormField.lng: lng,
      GrowthAndOutcomeFormField.syncDt: syncDt,
    };
  }

  GrowthAndOutcomeFormModel copyWith({
    // Section 1
    String? q101,
    String? q105,

    // Section 2
    String? q201,
    String? q201a,
    String? q201b,
    String? q201c,
    String? q201d,
    String? q201e,

    // Section 3
    String? q301,
    String? q302,
    String? q303,
    String? q304,

    // Section 4
    String? q401,
    String? q401a,
    String? q401b,
    String? q402,
    String? q402a,
    String? q402b,
    String? q403,
    String? q403a,
    String? q403b,
    String? q404,
    String? q404a,
    String? q404b,

    // Metadata
    String? infantId,
    String? userId,
    String? startDt,
    String? enDt,
    String? lat,
    String? lng,
    required String? syncDt,
  }) {
    return GrowthAndOutcomeFormModel(
      // Section 1
      q101: q101 ?? this.q101,
      q105: q105 ?? this.q105,

      // Section 2
      q201: q201 ?? this.q201,
      q201a: q201a ?? this.q201a,
      q201b: q201b ?? this.q201b,
      q201c: q201c ?? this.q201c,
      q201d: q201d ?? this.q201d,
      q201e: q201e ?? this.q201e,

      // Section 3
      q301: q301 ?? this.q301,
      q302: q302 ?? this.q302,
      q303: q303 ?? this.q303,
      q304: q304 ?? this.q304,

      // Section 4
      q401: q401 ?? this.q401,
      q401a: q401a ?? this.q401a,
      q401b: q401b ?? this.q401b,
      q402: q402 ?? this.q402,
      q402a: q402a ?? this.q402a,
      q402b: q402b ?? this.q402b,
      q403: q403 ?? this.q403,
      q403a: q403a ?? this.q403a,
      q403b: q403b ?? this.q403b,
      q404: q404 ?? this.q404,
      q404a: q404a ?? this.q404a,
      q404b: q404b ?? this.q404b,

      // Metadata
      infantId: infantId ?? this.infantId,
      userId: userId ?? this.userId,
      startDt: startDt ?? this.startDt,
      enDt: enDt ?? this.enDt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      syncDt: syncDt,
    );
  }
}