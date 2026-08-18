enum PendingInfantEnum {
  pendingInfantTable,
  cluster,
  householdId,
  siteWomanId,
  branchWomanId,
  womanName,
  childName,
  fatherName,
  pregSl,
  numOfBabies,
  infantId,
  childSex,
  childPid,
  babyPid,
  dob,
  phone,
}

class PendingInfantModel {
  String? cluster;
  String? householdId;
  String? siteWomanId;
  String? branchWomanId;
  String? womanName;
  String? childName;
  String? fatherName;
  String? pregSl;
  String? numOfBabies;
  String? infantId;
  String? childSex;
  String? childPid;
  String? babyPid;
  String? dob;
  String? phone;

  PendingInfantModel({
    this.cluster,
    this.householdId,
    this.siteWomanId,
    this.branchWomanId,
    this.womanName,
    this.childName,
    this.fatherName,
    this.pregSl,
    this.numOfBabies,
    this.infantId,
    this.childSex,
    this.childPid,
    this.babyPid,
    this.dob,
    this.phone,
  });

  factory PendingInfantModel.fromJson(Map<String, dynamic> json) {
    return PendingInfantModel(
      cluster: json[PendingInfantEnum.cluster.name].toString().trim(),
      householdId: json[PendingInfantEnum.householdId.name].toString().trim(),
      siteWomanId: json[PendingInfantEnum.siteWomanId.name].toString().trim(),
      branchWomanId: json[PendingInfantEnum.branchWomanId.name]
          .toString()
          .trim(),
      womanName: json[PendingInfantEnum.womanName.name].toString().trim(),
      childName: json[PendingInfantEnum.childName.name].toString().trim(),
      fatherName: json[PendingInfantEnum.fatherName.name].toString().trim(),
      pregSl: json[PendingInfantEnum.pregSl.name].toString().trim(),
      numOfBabies: json[PendingInfantEnum.numOfBabies.name].toString().trim(),
      infantId: json[PendingInfantEnum.infantId.name].toString().trim(),
      childSex: json[PendingInfantEnum.childSex.name].toString().trim(),
      childPid: json[PendingInfantEnum.childPid.name].toString().trim(),
      babyPid: json[PendingInfantEnum.babyPid.name].toString().trim(),
      dob: json[PendingInfantEnum.dob.name].toString().trim(),
      phone: json[PendingInfantEnum.phone.name].toString().trim(),
    );
  }

   Map<String, dynamic> toJson() {
    return {
      PendingInfantEnum.cluster.name: cluster,
      PendingInfantEnum.householdId.name: householdId,
      PendingInfantEnum.siteWomanId.name: siteWomanId,
      PendingInfantEnum.branchWomanId.name: branchWomanId,
      PendingInfantEnum.womanName.name: womanName,
      PendingInfantEnum.childName.name: childName,
      PendingInfantEnum.fatherName.name: fatherName,
      PendingInfantEnum.pregSl.name: pregSl,
      PendingInfantEnum.numOfBabies.name: numOfBabies,
      PendingInfantEnum.infantId.name: infantId,
      PendingInfantEnum.childSex.name: childSex,
      PendingInfantEnum.childPid.name: childPid,
      PendingInfantEnum.babyPid.name: babyPid,
      PendingInfantEnum.dob.name: dob,
      PendingInfantEnum.phone.name: phone,
    };
  }
}