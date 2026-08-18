part of 'data_db.dart';

class HeelPrickBloodInfantDb {
  static final HeelPrickBloodInfantDb instance = HeelPrickBloodInfantDb();

  // ==================== MAIN FORM METHODS ====================

  Future<void> deleteAllForms() async {
    final db = await DataDb.instance.database;
    await db.delete(HeelPrickBloodInfantFields.TABLE_NAME);
  //  print('All heel prick blood infant forms deleted');
  }

  Future<bool> updateForm(HeelPrickBloodInfantModel model) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.update(
        HeelPrickBloodInfantFields.TABLE_NAME,
        model.toJson(),
        where: '${HeelPrickBloodInfantFields.infantId} = ?',
        whereArgs: [model.infantId],
      );
    //  print('Heel prick blood infant form with ID ${model.infantId} updated');
      return rowsAffected > 0;
    } catch (e) {
    //  print('Error updating form with ID ${model.infantId}: $e');
      return false;
    }
  }

  Future<bool> deleteForm(String infantId) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.delete(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.infantId} = ?',
        whereArgs: [infantId],
      );
    //  print('Heel prick blood infant form with ID $infantId deleted');
      return rowsAffected > 0;
    } catch (e) {
    //  print('Error deleting form with ID $infantId: $e');
      return false;
    }
  }

  Future<bool> createAllForms(List<HeelPrickBloodInfantModel> formList) async {
    final db = await DataDb.instance.database;
    try {
      final batch = db.batch();
      for (final form in formList) {
        batch.insert(
          HeelPrickBloodInfantFields.TABLE_NAME,
          form.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
      return true;
    } catch (e) {
    //  print('Error creating all forms: $e');
      return false;
    }
  }

  Future<bool> createNewFormWithReplace({
    required HeelPrickBloodInfantModel model,
  }) async {
    final db = await DataDb.instance.database;
    try {
      await db.insert(
        HeelPrickBloodInfantFields.TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    //  print('Heel prick blood infant form created successfully');
    } catch (e) {
    //  print('Error creating form: $e');
      return false;
    }
    return true;
  }

  Future<int> createNewForm({required HeelPrickBloodInfantModel model}) async {
    final db = await DataDb.instance.database;
    return await db.insert(
      HeelPrickBloodInfantFields.TABLE_NAME,
      model.toJson(),
    );
  }

  Future<HeelPrickBloodInfantModel?> createOrIgnoreForm({
    required HeelPrickBloodInfantModel model,
  }) async {
    final db = await DataDb.instance.database;
     await db.insert(
      HeelPrickBloodInfantFields.TABLE_NAME,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  //  print('Form initiate response: $res');
    final newModel = await getFormById(infantId: model.infantId);
  //  print('Form get by infant id: ${model.infantId}: ${newModel == null}');
    return newModel;
  }

  Future<List<HeelPrickBloodInfantModel>> readAllForms() async {
    final db = await DataDb.instance.database;
    final maps = await db.query(
      HeelPrickBloodInfantFields.TABLE_NAME,
      columns: HeelPrickBloodInfantFields.values,
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => HeelPrickBloodInfantModel.fromJson(map)).toList();
  }

  Future<List<HeelPrickBloodInfantModel>> readTodoForms() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final db = await DataDb.instance.database;
    final maps = await db.rawQuery('''
      WITH last_record AS (
          SELECT 
              infant_id,
              visit_type,
              q2,
			  q2_c,
              visit_date,
              ROW_NUMBER() OVER (
                  PARTITION BY infant_id, visit_type 
                  ORDER BY date(visit_date) DESC
              ) AS rn,
			  end_date
          FROM tbl_heel_prick_blood_collection_form
      )
      SELECT hi.*
      FROM tbl_heel_prick_blood_infant hi
      -- Join latest record only
      LEFT JOIN last_record lr
          ON hi.infant_id = lr.infant_id
          AND hi.visit_type = lr.visit_type
          AND lr.rn = 1

      WHERE 
          NOT EXISTS (
              SELECT 1 FROM tbl_heel_prick_blood_collection_form t
              WHERE t.infant_id = hi.infant_id
             AND t.visit_type = hi.visit_type
             AND t.visit_date = '$today'
             AND t.end_date IS NOT NULL
          )
          AND (
              lr.infant_id IS NULL  
            or (lr.q2 = '2' and lr.q2_c not in ('1', '2'))
			or lr.end_date is null
          );
    ''');

    if (maps.isEmpty) return [];

    return maps.map((map) => HeelPrickBloodInfantModel.fromJson(map)).toList();
  }

  Future<List<HeelPrickBloodInfantModel>> readTodoFormsByVisitType({
    required String listType,
  }) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final db = await DataDb.instance.database;
    final maps = await db.rawQuery('''
      WITH last_record AS (
          SELECT 
              infant_id,
              visit_type,
              q2,
			  q2_c,
              visit_date,
              ROW_NUMBER() OVER (
                  PARTITION BY infant_id, visit_type 
                  ORDER BY date(visit_date) DESC
              ) AS rn,
			  end_date
          FROM tbl_heel_prick_blood_collection_form
      )
      SELECT hi.*
      FROM tbl_heel_prick_blood_infant hi
      -- Join latest record only
      LEFT JOIN last_record lr
          ON hi.infant_id = lr.infant_id
          AND hi.visit_type = lr.visit_type
          AND lr.rn = 1

      WHERE hi.visit_type='$listType' AND
          NOT EXISTS (
              SELECT 1 FROM tbl_heel_prick_blood_collection_form t
              WHERE t.infant_id = hi.infant_id
             AND t.visit_type = hi.visit_type
             AND t.visit_date = '$today'
             AND t.end_date IS NOT NULL
          )
          AND (
              lr.infant_id IS NULL  
            or (lr.q2 = '2' and lr.q2_c not in ('1', '2'))
			or lr.end_date is null
          );
    ''');

    if (maps.isEmpty) return [];

    return maps.map((map) => HeelPrickBloodInfantModel.fromJson(map)).toList();
  }

  Future<List<HeelPrickBloodInfantModel>> readDoneForms() async {
    final db = await DataDb.instance.database;
    final maps = await db.rawQuery('''
      WITH last_record AS (
          SELECT 
              infant_id,
              visit_type,
              q2,
              visit_date,
              ROW_NUMBER() OVER (
                  PARTITION BY infant_id, visit_type 
                  ORDER BY DATE(visit_date) DESC
              ) AS rn,
			  end_date,
			  sync_dt
          FROM tbl_heel_prick_blood_collection_form
      )
      SELECT hi.*, lr.end_date as collection_date, lr.sync_dt as send_dt
      FROM tbl_heel_prick_blood_infant hi
      -- Join latest record only
      LEFT JOIN last_record lr
          ON hi.infant_id = lr.infant_id
          AND hi.visit_type = lr.visit_type
          AND lr.rn = 1
      WHERE lr.q2 = '1';
    ''');

    if (maps.isEmpty) return [];

    return maps.map((map) => HeelPrickBloodInfantModel.fromJson(map)).toList();
  }

  Future<List<HeelPrickBloodInfantModel>> readRefusedForms() async {
    final db = await DataDb.instance.database;
    final maps = await db.rawQuery('''
      WITH last_record AS (
          SELECT 
              infant_id,
              visit_type,
              q2,
              visit_date,
              ROW_NUMBER() OVER (
                  PARTITION BY infant_id, visit_type 
                  ORDER BY DATE(visit_date) DESC
              ) AS rn,
			  end_date,
			  sync_dt,
			  q2_c
          FROM tbl_heel_prick_blood_collection_form
      )
      SELECT hi.*, lr.end_date as collection_date, lr.sync_dt as send_dt
      FROM tbl_heel_prick_blood_infant hi
      -- Join latest record only
      LEFT JOIN last_record lr
          ON hi.infant_id = lr.infant_id
          AND hi.visit_type = lr.visit_type
          AND lr.rn = 1
      WHERE 
           q2_c='1';
    ''');

    if (maps.isEmpty) return [];

    return maps.map((map) => HeelPrickBloodInfantModel.fromJson(map)).toList();
  }

  Future<HeelPrickBloodInfantModel?> getFormById({
    required String? infantId,
  }) async {
    if (infantId == null) return null;

    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.infantId} = ?',
        whereArgs: [infantId],
      );
      if (maps.isNotEmpty) {
        return HeelPrickBloodInfantModel.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (e) {
    //  print('Error getting form with ID $infantId: $e');
      return null;
    }
  }

  Future<bool> checkFormExists(String infantId) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.infantId} = ?',
        whereArgs: [infantId],
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
    //  print('Error checking form with ID $infantId: $e');
      return false;
    }
  }

  Future<int> countForms() async {
    final db = await DataDb.instance.database;
    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${HeelPrickBloodInfantFields.TABLE_NAME}',
      );
      return result.first['count'] as int;
    } catch (e) {
    //  print('Error counting forms: $e');
      return 0;
    }
  }

  Future<int> todoCountForms() async {
    final db = await DataDb.instance.database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final result = await db.rawQuery('''
        WITH last_record AS (
          SELECT 
              infant_id,
              visit_type,
              q2,
			  q2_c,
              visit_date,
              ROW_NUMBER() OVER (
                  PARTITION BY infant_id, visit_type 
                  ORDER BY date(visit_date) DESC
              ) AS rn,
			  end_date
          FROM tbl_heel_prick_blood_collection_form
      )
      SELECT COUNT(*) as count
      FROM tbl_heel_prick_blood_infant hi
      -- Join latest record only
      LEFT JOIN last_record lr
          ON hi.infant_id = lr.infant_id
          AND hi.visit_type = lr.visit_type
          AND lr.rn = 1

      WHERE 
          NOT EXISTS (
              SELECT 1 FROM tbl_heel_prick_blood_collection_form t
              WHERE t.infant_id = hi.infant_id
             AND t.visit_type = hi.visit_type
             AND t.visit_date = '$today'
             AND t.end_date IS NOT NULL
          )
          AND (
              lr.infant_id IS NULL  
            or (lr.q2 = '2' and lr.q2_c not in ('1', '2'))
			or lr.end_date is null
          );''');
      return result.first['count'] as int;
    } catch (e) {
    //  print('Error counting forms: $e');
      return 0;
    }
  }

  Future<List<HeelPrickBloodInfantModel>> getFormsByCluster(
    String cluster,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.cluster} = ?',
        whereArgs: [cluster],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodInfantModel.fromJson(map))
          .toList();
    } catch (e) {
    //  print('Error getting forms by cluster: $e');
      return [];
    }
  }

  Future<List<HeelPrickBloodInfantModel>> getFormsBySex(String sex) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.cSex} = ?',
        whereArgs: [sex],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodInfantModel.fromJson(map))
          .toList();
    } catch (e) {
    //  print('Error getting forms by sex: $e');
      return [];
    }
  }

  Future<List<HeelPrickBloodInfantModel>> getFormsByVisitType(
    String visitType,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.visitType} = ?',
        whereArgs: [visitType],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodInfantModel.fromJson(map))
          .toList();
    } catch (e) {
    //  print('Error getting forms by visit type: $e');
      return [];
    }
  }

  Future<List<HeelPrickBloodInfantModel>> getFormsByDateRange(
    String startDate,
    String endDate,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.dob} BETWEEN ? AND ?',
        whereArgs: [startDate, endDate],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodInfantModel.fromJson(map))
          .toList();
    } catch (e) {
    //  print('Error getting forms by date range: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getFormStatistics() async {
    final db = await DataDb.instance.database;
    try {
      final totalForms = await countForms();

      final maleResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${HeelPrickBloodInfantFields.TABLE_NAME} WHERE ${HeelPrickBloodInfantFields.cSex} = ?',
        ['Male'],
      );
      final maleCount = (maleResult.first['count'] as int?) ?? 0;

      final femaleResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${HeelPrickBloodInfantFields.TABLE_NAME} WHERE ${HeelPrickBloodInfantFields.cSex} = ?',
        ['Female'],
      );
      final femaleCount = (femaleResult.first['count'] as int?) ?? 0;

      final clusterResult = await db.rawQuery('''
        SELECT ${HeelPrickBloodInfantFields.cluster}, COUNT(*) as count 
        FROM ${HeelPrickBloodInfantFields.TABLE_NAME} 
        GROUP BY ${HeelPrickBloodInfantFields.cluster}
      ''');

      final clusterStats = <String, int>{};
      for (final row in clusterResult) {
        final cluster =
            row[HeelPrickBloodInfantFields.cluster]?.toString() ?? 'Unknown';
        final count = (row['count'] as int?) ?? 0;
        clusterStats[cluster] = count;
      }

      final visitTypeResult = await db.rawQuery('''
        SELECT ${HeelPrickBloodInfantFields.visitType}, COUNT(*) as count 
        FROM ${HeelPrickBloodInfantFields.TABLE_NAME} 
        GROUP BY ${HeelPrickBloodInfantFields.visitType}
      ''');

      final visitTypeStats = <String, int>{};
      for (final row in visitTypeResult) {
        final visitType =
            row[HeelPrickBloodInfantFields.visitType]?.toString() ?? 'Unknown';
        final count = (row['count'] as int?) ?? 0;
        visitTypeStats[visitType] = count;
      }

      return {
        'totalForms': totalForms,
        'maleCount': maleCount,
        'femaleCount': femaleCount,
        'clusterStats': clusterStats,
        'visitTypeStats': visitTypeStats,
      };
    } catch (e) {
    //  print('Error getting form statistics: $e');
      return {
        'totalForms': '0',
        'maleCount': 0,
        'femaleCount': 0,
        'clusterStats': {},
        'visitTypeStats': {},
      };
    }
  }

  Future<List<HeelPrickBloodInfantModel>> getUnsynchronizedForms() async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodInfantFields.TABLE_NAME,
        where: '${HeelPrickBloodInfantFields.syncDt} IS NULL',
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodInfantModel.fromJson(map))
          .toList();
    } catch (e) {
    //  print('Error getting unsynchronized forms: $e');
      return [];
    }
  }

  Future<int> updateSyncDate(String infantId, String syncDateTime) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.update(
        HeelPrickBloodInfantFields.TABLE_NAME,
        {HeelPrickBloodInfantFields.syncDt: syncDateTime},
        where: '${HeelPrickBloodInfantFields.infantId} = ?',
        whereArgs: [infantId],
      );
      return rowsAffected;
    } catch (e) {
    //  print('Error updating sync date: $e');
      return 0;
    }
  }

  Future<void> close() async {
    final db = await DataDb.instance.database;
    await db.close();
  }
}
