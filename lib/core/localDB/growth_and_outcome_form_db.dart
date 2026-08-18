part of 'data_db.dart';

class GrowthAndOutcomeFormDb {
  static final GrowthAndOutcomeFormDb instance = GrowthAndOutcomeFormDb();

  // ==================== MAIN FORM METHODS ====================

  Future<void> deleteAllForms() async {
    final db = await DataDb.instance.database;
    await db.delete(GrowthAndOutcomeFormField.TABLE_NAME);
    // print('All growth and outcome forms deleted');
  }

  // ==================== UPDATE ====================

  Future<bool> updateForm(GrowthAndOutcomeFormModel model) async {
    final db = await DataDb.instance.database;
    // print('inserting model : ${model.toJson()}');
    try {
      final rowsAffected = await db.update(
        GrowthAndOutcomeFormField.TABLE_NAME,
        model.toJson(),
        where:
            '${GrowthAndOutcomeFormField.infantId} = ? and ${GrowthAndOutcomeFormField.q201} = ?',
        whereArgs: [model.infantId, model.q201],
      );
      // print(
      //   'Growth and outcome form for infant ${model.infantId} updated '
      //   '$rowsAffected rows',
      // );
      return rowsAffected > 0;
    } catch (e) {
      // print(
      //   'Error updating growth and outcome form for infant '
      //   '${model.infantId}: $e',
      // );
      return false;
    }
  }

  // ==================== DELETE ====================

  Future<bool> deleteForm(String infantId, String q201) async {
    final db = await DataDb.instance.database;

    try {
      final rowsAffected = await db.delete(
        GrowthAndOutcomeFormField.TABLE_NAME,
        where:
            '${GrowthAndOutcomeFormField.infantId} = ? and ${GrowthAndOutcomeFormField.q201} = ?',
        whereArgs: [infantId, q201],
      );

      return rowsAffected > 0;
    } catch (e) {
      return false;
    }
  }

  // ==================== DELETE ALL FOR INFANT ====================

  Future<bool> deleteAllFormsForInfant(String infantId, String q201) async {
    final db = await DataDb.instance.database;

    try {
      final rowsAffected = await db.delete(
        GrowthAndOutcomeFormField.TABLE_NAME,
        where:
            '${GrowthAndOutcomeFormField.infantId} = ? and ${GrowthAndOutcomeFormField.q201} = ?',
        whereArgs: [infantId, q201],
      );

      return rowsAffected > 0;
    } catch (e) {
      return false;
    }
  }

  // ==================== CREATE ALL ====================

  Future<bool> createAllForms(List<GrowthAndOutcomeFormModel> formList) async {
    final db = await DataDb.instance.database;

    try {
      final batch = db.batch();

      for (final form in formList) {
        batch.insert(
          GrowthAndOutcomeFormField.TABLE_NAME,
          form.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit();

      return true;
    } catch (e) {
      // print('Error creating all growth and outcome forms: $e');
      return false;
    }
  }

  // ==================== CREATE WITH REPLACE ====================

  Future<bool> createNewFormWithReplace({
    required GrowthAndOutcomeFormModel model,
  }) async {
    final db = await DataDb.instance.database;

    try {
      await db.insert(
        GrowthAndOutcomeFormField.TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== CREATE ====================

  Future<int> createNewForm({required GrowthAndOutcomeFormModel model}) async {
    final db = await DataDb.instance.database;

    return await db.insert(
      GrowthAndOutcomeFormField.TABLE_NAME,
      model.toJson(),
    );
  }

  // ==================== CREATE OR IGNORE ====================

  Future<GrowthAndOutcomeFormModel?> createOrIgnoreForm({
    required GrowthAndOutcomeFormModel model,
  }) async {
    final db = await DataDb.instance.database;

    await db.insert(
      GrowthAndOutcomeFormField.TABLE_NAME,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return await getFormById(infantId: model.infantId, q201: model.q201 ?? '');
  }

  // ==================== READ ALL ====================

  Future<List<GrowthAndOutcomeFormModel>> readAllForms() async {
    final db = await DataDb.instance.database;

    final maps = await db.query(
      GrowthAndOutcomeFormField.TABLE_NAME,
      columns: GrowthAndOutcomeFormField.values,
    );

    if (maps.isEmpty) {
      return [];
    }

    return maps.map((map) => GrowthAndOutcomeFormModel.fromJson(map)).toList();
  }

  // ==================== READ UNSYNCED ====================

  Future<List<GrowthAndOutcomeFormModel>> readAllNew() async {
    final db = await DataDb.instance.database;

    final maps = await db.query(
      GrowthAndOutcomeFormField.TABLE_NAME,
      where:
          '''${GrowthAndOutcomeFormField.syncDt} IS NULL
      and ${GrowthAndOutcomeFormField.enDt} is not null 
      and trim(${GrowthAndOutcomeFormField.enDt}) != ''
      ''',
    );

    if (maps.isEmpty) {
      return [];
    }

    return maps.map((map) => GrowthAndOutcomeFormModel.fromJson(map)).toList();
  }

  // ==================== GET BY INFANT ID ====================

  Future<GrowthAndOutcomeFormModel?> getFormById({
    required String? infantId,
    required String q201,
  }) async {
    if (infantId == null) {
      return null;
    }

    final db = await DataDb.instance.database;

    try {
      final maps = await db.query(
        GrowthAndOutcomeFormField.TABLE_NAME,
        where:
            '${GrowthAndOutcomeFormField.infantId} = ? and ${GrowthAndOutcomeFormField.q201} = ?',
        whereArgs: [infantId, q201],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return GrowthAndOutcomeFormModel.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== GET ALL BY INFANT ID ====================

  Future<List<GrowthAndOutcomeFormModel>> getFormsByInfantId(
    String infantId,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        GrowthAndOutcomeFormField.TABLE_NAME,
        where: '${GrowthAndOutcomeFormField.infantId} = ?',
        whereArgs: [infantId],
      );
      if (maps.isEmpty) {
        return [];
      }
      return maps
          .map((map) => GrowthAndOutcomeFormModel.fromJson(map))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== CHECK EXISTS ====================

  Future<bool> checkFormExists(String infantId) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        GrowthAndOutcomeFormField.TABLE_NAME,
        where: '${GrowthAndOutcomeFormField.infantId} = ?',
        whereArgs: [infantId],
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ==================== COUNT ====================

  Future<String> countForms() async {
    final db = await DataDb.instance.database;

    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count '
        'FROM ${GrowthAndOutcomeFormField.TABLE_NAME}',
      );

      return result.first['count'].toString();
    } catch (e) {
      return '0';
    }
  }

  // ==================== UPDATE SYNC DATE ====================

  Future<int> updateSyncDate(String infantId, String syncDateTime) async {
    final db = await DataDb.instance.database;

    try {
      final rowsAffected = await db.update(
        GrowthAndOutcomeFormField.TABLE_NAME,
        {GrowthAndOutcomeFormField.syncDt: syncDateTime},
        where: '${GrowthAndOutcomeFormField.infantId} = ?',
        whereArgs: [infantId],
      );

      return rowsAffected;
    } catch (e) {
      return 0;
    }
  }

  // ==================== GET INCOMPLETE FORMS ====================

  Future<List<GrowthAndOutcomeFormModel>> getIncompleteForms() async {
    final db = await DataDb.instance.database;

    try {
      final maps = await db.query(
        GrowthAndOutcomeFormField.TABLE_NAME,
        where: '${GrowthAndOutcomeFormField.enDt} IS NULL',
      );

      if (maps.isEmpty) {
        return [];
      }

      return maps
          .map((map) => GrowthAndOutcomeFormModel.fromJson(map))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== CLOSE ====================

  Future<void> close() async {
    final db = await DataDb.instance.database;

    await db.close();
  }
}
