import '../fields/heel_prick_blood_infant_fields.dart';

class HeelPrickBloodInfantModel {
  final String? infantId;
  final String? cluster;
  final String? siteWomanId;
  final String? pregSL;
  final String? dob;
  final String? tob;
  final String? pidBaby;
  final String? cSex;
  final String? visitType;
  final String? sampleId;
  final String? dueDate;
  final String? endDate;
  final String? childName;
  final String? childPid;
  final String? childCid;
  final String? fatherName;
  final String? motherName;
  final String? motherCid;
  final String? mobile;
  final String? dtRandom;
  final String? syncDt;
  final String? collectionDate;
  final String? sendDt;

  HeelPrickBloodInfantModel({
    this.infantId,
    this.cluster,
    this.siteWomanId,
    this.pregSL,
    this.dob,
    this.tob,
    this.pidBaby,
    this.cSex,
    this.visitType,
    this.sampleId,
    this.dueDate,
    this.endDate,
    this.childName,
    this.childPid,
    this.childCid,
    this.fatherName,
    this.motherName,
    this.motherCid,
    this.mobile,
    this.dtRandom,
    this.collectionDate,
    this.sendDt,
    this.syncDt,
  });

  factory HeelPrickBloodInfantModel.fromJson(Map<String, dynamic> json) {
  //  print('json data : ${json}');
  //  print(
    //   'end date : ${json[HeelPrickBloodInfantFields.endDate].toString().trim()}',
    // );
    return HeelPrickBloodInfantModel(
      infantId: json[HeelPrickBloodInfantFields.infantId].toString().trim(),
      cluster: json[HeelPrickBloodInfantFields.cluster].toString().trim(),
      siteWomanId: json[HeelPrickBloodInfantFields.siteWomanId]
          .toString()
          .trim(),
      pregSL: json[HeelPrickBloodInfantFields.pregSL].toString().trim(),
      dob: json[HeelPrickBloodInfantFields.dob].toString().trim(),
      tob: json[HeelPrickBloodInfantFields.tob].toString().trim(),
      pidBaby: json[HeelPrickBloodInfantFields.pidBaby].toString().trim(),
      cSex: json[HeelPrickBloodInfantFields.cSex].toString().trim(),
      visitType: json[HeelPrickBloodInfantFields.visitType].toString().trim(),
      sampleId: json[HeelPrickBloodInfantFields.sampleId].toString().trim(),
      dueDate: json[HeelPrickBloodInfantFields.dueDate].toString().trim(),
      endDate: json[HeelPrickBloodInfantFields.endDate].toString().trim(),
      childName: json[HeelPrickBloodInfantFields.childName].toString().trim(),
      childPid: json[HeelPrickBloodInfantFields.childPid].toString().trim(),
      childCid: json[HeelPrickBloodInfantFields.childCid].toString().trim(),
      fatherName: json[HeelPrickBloodInfantFields.fatherName].toString().trim(),
      motherName: json[HeelPrickBloodInfantFields.motherName].toString().trim(),
      motherCid: json[HeelPrickBloodInfantFields.motherCid].toString().trim(),
      mobile: json[HeelPrickBloodInfantFields.mobile].toString().trim(),
      dtRandom: json[HeelPrickBloodInfantFields.dtRandom].toString().trim(),
      collectionDate: json[HeelPrickBloodInfantFields.collectionDate]
          .toString()
          .trim(),
      sendDt: json[HeelPrickBloodInfantFields.sendDt].toString().trim(),
      syncDt: json[HeelPrickBloodInfantFields.syncDt].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      HeelPrickBloodInfantFields.infantId: infantId,
      HeelPrickBloodInfantFields.cluster: cluster,
      HeelPrickBloodInfantFields.siteWomanId: siteWomanId,
      HeelPrickBloodInfantFields.pregSL: pregSL,
      HeelPrickBloodInfantFields.dob: dob,
      HeelPrickBloodInfantFields.tob: tob,
      HeelPrickBloodInfantFields.pidBaby: pidBaby,
      HeelPrickBloodInfantFields.cSex: cSex,
      HeelPrickBloodInfantFields.visitType: visitType,
      HeelPrickBloodInfantFields.sampleId: sampleId,
      HeelPrickBloodInfantFields.dueDate: dueDate,
      HeelPrickBloodInfantFields.endDate: endDate,
      HeelPrickBloodInfantFields.childName: childName,
      HeelPrickBloodInfantFields.childPid: childPid,
      HeelPrickBloodInfantFields.childCid: childCid,
      HeelPrickBloodInfantFields.fatherName: fatherName,
      HeelPrickBloodInfantFields.motherName: motherName,
      HeelPrickBloodInfantFields.motherCid: motherCid,
      HeelPrickBloodInfantFields.mobile: mobile,
      HeelPrickBloodInfantFields.dtRandom: dtRandom,
      HeelPrickBloodInfantFields.syncDt: syncDt,
    };
  }

  HeelPrickBloodInfantModel copyWith({
    String? infantId,
    String? cluster,
    String? siteWomanId,
    String? pregSL,
    String? dob,
    String? tob,
    String? pidBaby,
    String? cSex,
    String? visitType,
    String? sampleId,
    String? dueDate,
    String? endDate,
    String? childName,
    String? childPid,
    String? childCid,
    String? fatherName,
    String? motherName,
    String? motherCid,
    String? mobile,
    String? dtRandom,
    String? syncDt,
  }) {
    return HeelPrickBloodInfantModel(
      infantId: infantId ?? this.infantId,
      cluster: cluster ?? this.cluster,
      siteWomanId: siteWomanId ?? this.siteWomanId,
      pregSL: pregSL ?? this.pregSL,
      dob: dob ?? this.dob,
      tob: tob ?? this.tob,
      pidBaby: pidBaby ?? this.pidBaby,
      cSex: cSex ?? this.cSex,
      visitType: visitType ?? this.visitType,
      sampleId: sampleId ?? this.sampleId,
      dueDate: dueDate ?? this.dueDate,
      endDate: endDate ?? this.endDate,
      childName: childName ?? this.childName,
      childPid: childPid ?? this.childPid,
      childCid: childCid ?? this.childCid,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      motherCid: motherCid ?? this.motherCid,
      mobile: mobile ?? this.mobile,
      dtRandom: dtRandom ?? this.dtRandom,
      syncDt: syncDt ?? this.syncDt,
    );
  }
}
