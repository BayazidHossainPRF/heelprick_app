part of 'data_db.dart';

class UserDb {
  static final UserDb instance = UserDb();

  Future<void> deleteAllUsers() async {
    final db = await DataDb.instance.database;
    await db.delete(UserFields.TABLE_NAME);
    debugPrint('All user deleted');
  }

  /// Update an existing farmer
  // Future<bool> updateReport(ReportModel model) async {
  //   final db = await DataDb.instance.database;
  //   try {
  //     final rowsAffected = await db.update(
  //       ReportFields.TABLE_NAME,
  //       model.toJson(),
  //       where: '${ReportFields.reportId} = ?',
  //       whereArgs: [model.reportId],
  //     );

  //     debugPrint('Report with ID ${model.reportId} updated');
  //     return rowsAffected > 0;
  //   } catch (e) {
  //     debugPrint('Error updating report with ID ${model.reportId}: $e');
  //     return false;
  //   }
  // }

  // Future<bool> deleteReport(int reportId) async {
  //   final db = await DataDb.instance.database;
  //   try {
  //     final rowsAffected = await db.delete(
  //       ReportFields.TABLE_NAME,
  //       where: '${ReportFields.reportId} = ?',
  //       whereArgs: [reportId],
  //     );
  //     debugPrint('Report with ID $reportId deleted');
  //     return rowsAffected > 0;
  //   } catch (e) {
  //     debugPrint('Error deleting report with ID $reportId: $e');
  //     return false;
  //   }
  // }

  // Future<bool> createAllReport(List<FarmerInfoModel> farmerList) async {
  //   final db = await DataDb.instance.database;
  //   // await db.delete(FarmerInfoFields.TABLE_NAME);
  //   try {
  //     for (int i = 0; i < farmerList.length; i++) {
  //       await db.insert(
  //         FarmerInfoFields.TABLE_NAME,
  //         farmerList[i].toJson(),
  //         conflictAlgorithm: ConflictAlgorithm.replace,
  //       );
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  //   return true;
  // }

  Future<bool> createNewUserWithReplace({required UserModel model}) async {
    final db = await DataDb.instance.database;
    try {
      await db.insert(
        UserFields.TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Success');
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  // Future<int> createNewReport({required ReportModel model}) async {
  //   final db = await DataDb.instance.database;
  //   // await db.delete(FarmerInfoFields.TABLE_NAME);
  //   return await db.insert(ReportFields.TABLE_NAME, model.toJson());
  // }

  // Future<List<ReportModel>> readAllReport() async {
  //   final db = await DataDb.instance.database;

  //   // final orderBy = '${DirectoryFields.name} DESC';
  //   // print('(((((((((((((Order asc)))))))))))))');
  //   final maps = await db.query(
  //     ReportFields.TABLE_NAME,
  //     columns: ReportFields.values,
  //     // where: '${EmployeeFields.samityStatus} = ?',
  //     // whereArgs: ['A'],
  //   );
  //   if (maps.isNotEmpty) {
  //     List<ReportModel> reportList = [];
  //     // print('-------------len of samity local db ${maps.length}');
  //     for (int i = 0; i < maps.length; i++) {
  //       // print(maps[i]);
  //       reportList.add(ReportModel.fromJson(maps[i]));
  //     }
  //     // print('---------decoded samity list ${samityList.length}');
  //     return reportList;
  //   } else {
  //     return [];
  //   }
  // }

  Future<bool> checkUser({
    required String userId,
    required String password,
  }) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        UserFields.TABLE_NAME,
        where: '${UserFields.userId} = ? and ${UserFields.userPass} = ?',
        whereArgs: [userId, password],
      );
      if (maps.isNotEmpty) {
        print('user in database : ${maps.first}');
        await UserPrefs.setUser(userJson: maps.first);
        return true;
      } else {
        print('No Report found in database_____________________');
        return false;
      }
    } catch (e) {
      print('Error in:_____________________ $e');
      return false;
    }
  }

  // Future<String> countReport() async {
  //   final db = await DataDb.instance.database;
  //   try {
  //     final result = await db.rawQuery(
  //       'SELECT COUNT(*) as count FROM ${ReportFields.TABLE_NAME}',
  //     );

  //     return Sqflite.firstIntValue(result).toString();
  //   } catch (e) {
  //     return '0';
  //   }
  // }

  // Future<String> countFarmerUnderBlockByType({
  //   required int blockId,
  //   required String type,
  // }) async {
  //   final db = await DataDb.instance.database;
  //   try {
  //     final result = await db.rawQuery(
  //       'SELECT COUNT(*) as count FROM ${FarmerInfoFields.TABLE_NAME} WHERE ${FarmerInfoFields.blockId} = ? AND ${FarmerInfoFields.farmerType} = ?',
  //       [blockId, type],
  //     );

  //     return Sqflite.firstIntValue(result).toString();
  //   } catch (e) {
  //     return '0';
  //   }
  // }

  // Future<int> countFarmerByVillageId({required int villageId}) async {
  //   final db = await DataDb.instance.database;
  //   try {
  //     final result = await db.rawQuery(
  //       'SELECT COUNT(*) as count FROM ${FarmerInfoFields.TABLE_NAME} where ${FarmerInfoFields.villageId} = ?',
  //       [villageId],
  //     );
  //     return Sqflite.firstIntValue(result) ?? 0;
  //   } catch (e) {
  //     return 0;
  //   }
  // }

  // Future<int> countFarmerByWordId({required int wordId}) async {
  //   final db = await DataDb.instance.database;
  //   try {
  //     final result = await db.rawQuery(
  //       '''SELECT COUNT(*) as count
  //           FROM ${FarmerInfoFields.TABLE_NAME} f
  //             JOIN ${VillageFields.TABLE_NAME} v ON f.${FarmerInfoFields.villageId} = v.${VillageFields.villageId}
  //               WHERE v.${VillageFields.wordId} = ?''',
  //       [wordId],
  //     );
  //     return Sqflite.firstIntValue(result) ?? 0;
  //   } catch (e) {
  //     return 0;
  //   }
  // }
}
