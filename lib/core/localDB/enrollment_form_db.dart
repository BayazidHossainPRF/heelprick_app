part of 'data_db.dart';

class EnrollmentFormDb {
  static final EnrollmentFormDb instance = EnrollmentFormDb();

  // ==================== MAIN FORM METHODS ====================

  Future<void> deleteAllForms() async {
    final db = await DataDb.instance.database;

    await db.delete(EnrollmentFormField.TABLE_NAME);

    // print('All enrollment forms deleted');
  }

  // ==================== UPDATE ====================

  Future<bool> updateForm(EnrollmentFormModel model) async {
    final db = await DataDb.instance.database;
    print('inserting modle : ${model.toJson()}');
    try {
      final rowsAffected = await db.update(
        EnrollmentFormField.TABLE_NAME,
        model.toJson(),
        where: '${EnrollmentFormField.infantId} = ?',
        whereArgs: [model.infantId],
      );

      print(
        'Enrollment form for infant ${model.infantId} updated '
        '$rowsAffected rows',
      );
      return rowsAffected > 0;
    } catch (e) {
      print(
        'Error updating enrollment form for infant '
        '${model.infantId}: $e',
      );
      return false;
    }
  }

  // ==================== DELETE ====================

  Future<bool> deleteForm(String infantId) async {
    final db = await DataDb.instance.database;

    try {
      final rowsAffected = await db.delete(
        EnrollmentFormField.TABLE_NAME,
        where: '${EnrollmentFormField.infantId} = ?',
        whereArgs: [infantId],
      );

      // print(
      //   'Enrollment form for infant $infantId deleted',
      // );

      return rowsAffected > 0;
    } catch (e) {
      // print(
      //   'Error deleting enrollment form for infant '
      //   '$infantId: $e',
      // );

      return false;
    }
  }

  // ==================== DELETE ALL FOR INFANT ====================

  Future<bool> deleteAllFormsForInfant(String infantId) async {
    final db = await DataDb.instance.database;

    try {
      final rowsAffected = await db.delete(
        EnrollmentFormField.TABLE_NAME,
        where: '${EnrollmentFormField.infantId} = ?',
        whereArgs: [infantId],
      );

      // print(
      //   'All enrollment forms for infant $infantId deleted',
      // );

      return rowsAffected > 0;
    } catch (e) {
      // print(
      //   'Error deleting enrollment forms for infant '
      //   '$infantId: $e',
      // );

      return false;
    }
  }

  // ==================== CREATE ALL ====================

  Future<bool> createAllForms(List<EnrollmentFormModel> formList) async {
    final db = await DataDb.instance.database;

    try {
      final batch = db.batch();

      for (final form in formList) {
        batch.insert(
          EnrollmentFormField.TABLE_NAME,
          form.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit();

      return true;
    } catch (e) {
      // print('Error creating all enrollment forms: $e');
      return false;
    }
  }

  // ==================== CREATE WITH REPLACE ====================

  Future<bool> createNewFormWithReplace({
    required EnrollmentFormModel model,
  }) async {
    final db = await DataDb.instance.database;

    try {
      await db.insert(
        EnrollmentFormField.TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      //  print(
      //   'Enrollment form created successfully',
      // );

      return true;
    } catch (e) {
      //  print(
      //   'Error creating enrollment form: $e',
      // );

      return false;
    }
  }

  // ==================== CREATE ====================

  Future<int> createNewForm({required EnrollmentFormModel model}) async {
    final db = await DataDb.instance.database;

    return await db.insert(EnrollmentFormField.TABLE_NAME, model.toJson());
  }

  // ==================== CREATE OR IGNORE ====================

  Future<EnrollmentFormModel?> createOrIgnoreForm({
    required EnrollmentFormModel model,
  }) async {
    final db = await DataDb.instance.database;

    await db.insert(
      EnrollmentFormField.TABLE_NAME,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    //  print(
    //   'Enrollment form initiate response: $res',
    // );

    return await getFormById(infantId: model.infantId);
  }

  // ==================== READ ALL ====================

  Future<List<EnrollmentFormModel>> readAllForms() async {
    final db = await DataDb.instance.database;

    final maps = await db.query(
      EnrollmentFormField.TABLE_NAME,
      columns: EnrollmentFormField.values,
    );

    if (maps.isEmpty) {
      return [];
    }

    return maps.map((map) => EnrollmentFormModel.fromJson(map)).toList();
  }

  Future<List<EnrollmentFormModel>> readAllTodoGrowthAndOutcome() async {
    final db = await DataDb.instance.database;

    final maps = await db.rawQuery('''
       WITH enrollment AS (
        SELECT 
            en.*,
            CASE 
                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+7 days') 
                    AND date(en.dob, '+13 days') THEN '02'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+14 days') 
                    AND date(en.dob, '+20 days') THEN '03'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+21 days') 
                    AND date(en.dob, '+34 days') THEN '04'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+35 days') 
                    AND date(en.dob, '+48 days') THEN '06'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+49 days') 
                    AND date(en.dob, '+62 days') THEN '08'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+63 days') 
                    AND date(en.dob, '+76 days') THEN '10'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+77 days') 
                    AND date(en.dob, '+90 days') THEN '12'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+91 days') 
                    AND date(en.dob, '+104 days') THEN '14'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+105 days') 
                    AND date(en.dob, '+118 days') THEN '16'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+119 days') 
                    AND date(en.dob, '+132 days') THEN '18'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+133 days') 
                    AND date(en.dob, '+146 days') THEN '20'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+147 days') 
                    AND date(en.dob, '+160 days') THEN '22'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+161 days') 
                    AND date(en.dob, '+174 days') THEN '24'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+175 days') 
                    AND date(en.dob, '+181 days') THEN '26'

                WHEN date('now', 'localtime') BETWEEN date(en.dob, '+182 days') 
                    AND date(en.dob, '+188 days') THEN '27'
            END AS visit_week
        FROM tbl_heel_prick_enrollment_form en
    ),
    growth_visits as ( SELECT row_number() over(PARTITION by q101 order by q201 desc) as rn, * 
      from tbl_heel_prick_growth_and_outcome_form	)
  
      SELECT enrollment.*
      FROM enrollment
      LEFT JOIN tbl_heel_prick_growth_and_outcome_form gw
          ON enrollment.infantId = gw.infantId
          AND gw.q201 = enrollment.visit_week
    left join growth_visits gv
      on enrollment.infantId = gv.infantId and gv.rn=1
      WHERE enrollment.visit_week IS NOT NULL and enrollment.q602 is not null
      and trim(enrollment.q602) != ''
      and (gw.enDt is null or trim(gw.enDt) = '')
    and (gv.q201c is null or gv.q201c not in ('14', '15', '16')) ;
    ''');

    if (maps.isEmpty) {
      return [];
    }

    return maps.map((map) => EnrollmentFormModel.fromJson(map)).toList();
  }
  // ==================== READ UNSYNCED ====================

  Future<List<EnrollmentFormModel>> readAllNew() async {
    final db = await DataDb.instance.database;

    final maps = await db.query(
      EnrollmentFormField.TABLE_NAME,
      where:
          '''${EnrollmentFormField.syncDt} IS NULL 
      and ${EnrollmentFormField.enDt} is not null 
      and trim(${EnrollmentFormField.enDt}) != ''
      ''',
    );

    if (maps.isEmpty) {
      return [];
    }

    return maps.map((map) => EnrollmentFormModel.fromJson(map)).toList();
  }

  // ==================== GET BY INFANT ID ====================

  Future<EnrollmentFormModel?> getFormById({required String? infantId}) async {
    if (infantId == null) {
      return null;
    }

    final db = await DataDb.instance.database;

    try {
      final maps = await db.query(
        EnrollmentFormField.TABLE_NAME,
        where: '${EnrollmentFormField.infantId} = ?',
        whereArgs: [infantId],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return EnrollmentFormModel.fromJson(maps.first);
      }

      return null;
    } catch (e) {
      //  print(
      //   'Error getting enrollment form for infant '
      //   '$infantId: $e',
      // );

      return null;
    }
  }

  // ==================== GET ALL BY INFANT ID ====================

  Future<List<EnrollmentFormModel>> getFormsByInfantId(String infantId) async {
    final db = await DataDb.instance.database;

    try {
      final maps = await db.query(
        EnrollmentFormField.TABLE_NAME,
        where: '${EnrollmentFormField.infantId} = ?',
        whereArgs: [infantId],
      );

      if (maps.isEmpty) {
        return [];
      }

      return maps.map((map) => EnrollmentFormModel.fromJson(map)).toList();
    } catch (e) {
      //  print(
      //   'Error getting enrollment forms for infant '
      //   '$infantId: $e',
      // );

      return [];
    }
  }

  // ==================== CHECK EXISTS ====================

  Future<bool> checkFormExists(String infantId) async {
    final db = await DataDb.instance.database;

    try {
      final maps = await db.query(
        EnrollmentFormField.TABLE_NAME,
        where: '${EnrollmentFormField.infantId} = ?',
        whereArgs: [infantId],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      //  print(
      //   'Error checking enrollment form for infant '
      //   '$infantId: $e',
      // );

      return false;
    }
  }

  // ==================== COUNT ====================

  Future<String> countForms() async {
    final db = await DataDb.instance.database;

    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count '
        'FROM ${EnrollmentFormField.TABLE_NAME}',
      );

      return result.first['count'].toString();
    } catch (e) {
      //  print('Error counting enrollment forms: $e');

      return '0';
    }
  }

  // ==================== UPDATE SYNC DATE ====================

  Future<int> updateSyncDate(String infantId, String syncDateTime) async {
    final db = await DataDb.instance.database;

    try {
      final rowsAffected = await db.update(
        EnrollmentFormField.TABLE_NAME,
        {EnrollmentFormField.syncDt: syncDateTime},
        where: '${EnrollmentFormField.infantId} = ?',
        whereArgs: [infantId],
      );

      return rowsAffected;
    } catch (e) {
      //  print(
      //   'Error updating sync date: $e',
      // );

      return 0;
    }
  }

  // ==================== GET INCOMPLETE FORMS ====================

  Future<List<EnrollmentFormModel>> getIncompleteForms() async {
    final db = await DataDb.instance.database;

    try {
      final maps = await db.query(
        EnrollmentFormField.TABLE_NAME,
        where: '${EnrollmentFormField.enDt} IS NULL',
      );

      if (maps.isEmpty) {
        return [];
      }

      return maps.map((map) => EnrollmentFormModel.fromJson(map)).toList();
    } catch (e) {
      //  print(
      //   'Error getting incomplete enrollment forms: $e',
      // );

      return [];
    }
  }

  // ==================== CLOSE ====================

  Future<void> close() async {
    final db = await DataDb.instance.database;

    await db.close();
  }

  Future<List<Map<String, Object?>>> getSyncStatistic() async {
    final db = await DataDb.instance.database;

    final maps = await db.rawQuery('''
      SELECT count(*) as total, 
      count(case when syncDt is not null then 1 end) as sync 
      from tbl_heel_prick_enrollment_form where enDt is not null and trim(enDt) != ''

      UNION all
      SELECT count(*) as total, 
      count(case when sync_dt is not null then 1 end) as sync 
      from tbl_heel_prick_asset where end_dt is not null and trim(end_dt) != ''

      UNION all 
      SELECT count(*) as total, 
      count(case when syncDt is not null then 1 end) as sync 
      from tbl_heel_prick_growth_and_outcome_form where enDt is not null and trim(enDt) != ''
    ''');
    return maps;
  }
}
