
import '../fields/user_fields.dart';

class UserModel {
  final String? userId;
  final String? userPass;
  final String? name;
  final String? userLevel;
  final String? designation;
  final String? phone;
  final String? cluster1;
  final String? cluster2;
  final String? teamId;


  UserModel({
    this.name,
    this.userId,
    this.userPass,
    this.userLevel,
    this.designation,
    this.phone,
    this.cluster1,
    this.cluster2,
    this.teamId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json[UserFields.name].toString().trim(),
      userId: json[UserFields.userId].toString().trim(),
      userPass: json[UserFields.userPass].toString().trim(),
      userLevel: json[UserFields.userLevel].toString().trim(),
      designation: json[UserFields.designation].toString().trim(),
      phone: json[UserFields.phone].toString().trim(),
      cluster1: json[UserFields.cluster1].toString().trim(),
      cluster2: json[UserFields.cluster2].toString().trim(),
      teamId: json[UserFields.teamId].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      UserFields.name: name,
      UserFields.userId: userId,
      UserFields.userPass: userPass,
      UserFields.userLevel: userLevel,
      UserFields.designation: designation,
      UserFields.phone: phone,
      UserFields.cluster1: cluster1,
      UserFields.cluster2: cluster2,
      UserFields.teamId: teamId,
    };
  }

  // UnionModel copyWith({
  //   int? unionId,
  //   String? name,
  //   int? districtId,
  //   int? upazilaId,
  //   int? status,
  //   int? uploaded,
  // }) {
  //   return UnionModel(
  //     unionId: unionId ?? this.unionId,
  //     name: name ?? this.name,
  //     districtId: districtId ?? this.districtId,
  //     upazilaId: upazilaId ?? this.upazilaId,
  //     status: status ?? this.status,
  //     uploaded: uploaded ?? this.uploaded,
  //   );
  // }
}
