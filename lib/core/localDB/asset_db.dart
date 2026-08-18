part of 'data_db.dart';

class AssetDb {
  static final AssetDb instance = AssetDb();

  // ==================== MAIN FORM METHODS ====================

  Future<void> deleteAllForms() async {
    final db = await DataDb.instance.database;
    await db.delete(AssetFields.TABLE_NAME);
    print('All asset forms deleted');
  }

  Future<bool> updateForm(AssetModel model) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.update(
        AssetFields.TABLE_NAME,
        model.toJson(),
        where: '${AssetFields.infantId} = ?',
        whereArgs: [model.infantId],
      );
      print('Asset form with ID ${model.infantId} updated');
      return rowsAffected > 0;
    } catch (e) {
      print('Error updating form with ID ${model.infantId}: $e');
      return false;
    }
  }

  Future<bool> deleteForm(String infantId) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.delete(
        AssetFields.TABLE_NAME,
        where: '${AssetFields.infantId} = ?',
        whereArgs: [infantId],
      );
      print('Asset form with ID $infantId deleted');
      return rowsAffected > 0;
    } catch (e) {
      print('Error deleting form with ID $infantId: $e');
      return false;
    }
  }

  Future<bool> createAllForms(List<AssetModel> formList) async {
    final db = await DataDb.instance.database;
    try {
      final batch = db.batch();
      for (final form in formList) {
        batch.insert(
          AssetFields.TABLE_NAME,
          form.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error creating all forms: $e');
      return false;
    }
  }

  Future<bool> createNewFormWithReplace({required AssetModel model}) async {
    final db = await DataDb.instance.database;
    try {
      await db.insert(
        AssetFields.TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Asset form created successfully');
    } catch (e) {
      print('Error creating form: $e');
      return false;
    }
    return true;
  }

  Future<int> createNewForm({required AssetModel model}) async {
    final db = await DataDb.instance.database;
    return await db.insert(AssetFields.TABLE_NAME, model.toJson());
  }

  Future<AssetModel?> createOrIgnoreForm({required AssetModel model}) async {
    final db = await DataDb.instance.database;
    final res = await db.insert(
      AssetFields.TABLE_NAME,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    print('Form initiate response: $res');
    final newModel = await getFormById(infantId: model.infantId);
    print('Form get by scr id: ${model.infantId}: ${newModel == null}');
    return newModel;
  }

  Future<List<AssetModel>> readAllForms() async {
    final db = await DataDb.instance.database;
    final maps = await db.query(
      AssetFields.TABLE_NAME,
      columns: AssetFields.values,
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => AssetModel.fromJson(map)).toList();
  }

  Future<List<AssetModel>> readAllNew() async {
    final db = await DataDb.instance.database;
    final maps = await db.query(
      AssetFields.TABLE_NAME,
      columns: AssetFields.values,
      where: '''${AssetFields.syncDt} is null 
      and ${AssetFields.endDT} is not null
      and trim(${AssetFields.endDT}) != ''
      ''',
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => AssetModel.fromJson(map)).toList();
  }

  Future<AssetModel?> getFormById({required String? infantId}) async {
    if (infantId == null) return null;

    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        AssetFields.TABLE_NAME,
        where: '${AssetFields.infantId} = ?',
        whereArgs: [infantId],
      );
      if (maps.isNotEmpty) {
        return AssetModel.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting form with ID $infantId: $e');
      return null;
    }
  }

  Future<bool> checkFormExists(String infantId) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        AssetFields.TABLE_NAME,
        where: '${AssetFields.infantId} = ?',
        whereArgs: [infantId],
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
      print('Error checking form with ID $infantId: $e');
      return false;
    }
  }

  Future<String> countForms() async {
    final db = await DataDb.instance.database;
    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AssetFields.TABLE_NAME}',
      );
      return result.first['count'].toString();
    } catch (e) {
      print('Error counting forms: $e');
      return '0';
    }
  }

  Future<List<AssetModel>> getFormsByQuestionValue(
    String questionField,
    String value,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        AssetFields.TABLE_NAME,
        where: '$questionField = ?',
        whereArgs: [value],
      );

      if (maps.isEmpty) return [];

      return maps.map((map) => AssetModel.fromJson(map)).toList();
    } catch (e) {
      print('Error getting forms by $questionField: $e');
      return [];
    }
  }

  Future<List<AssetModel>> getFormsWithNullField(String fieldName) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        AssetFields.TABLE_NAME,
        where: '$fieldName IS NULL',
      );

      if (maps.isEmpty) return [];

      return maps.map((map) => AssetModel.fromJson(map)).toList();
    } catch (e) {
      print('Error getting forms with null $fieldName: $e');
      return [];
    }
  }

  Future<List<AssetModel>> getFormsWithNonNullField(String fieldName) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        AssetFields.TABLE_NAME,
        where: '$fieldName IS NOT NULL',
      );

      if (maps.isEmpty) return [];

      return maps.map((map) => AssetModel.fromJson(map)).toList();
    } catch (e) {
      print('Error getting forms with non-null $fieldName: $e');
      return [];
    }
  }

  Future<bool> createFormsInBatch(List<AssetModel> forms) async {
    final db = await DataDb.instance.database;
    final batch = db.batch();

    try {
      for (final form in forms) {
        batch.insert(
          AssetFields.TABLE_NAME,
          form.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error creating forms in batch: $e');
      return false;
    }
  }

  Future<List<AssetModel>> getFormsByDateRange(
    String dateField,
    String startDate,
    String endDate,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        AssetFields.TABLE_NAME,
        where: '$dateField BETWEEN ? AND ?',
        whereArgs: [startDate, endDate],
      );

      if (maps.isEmpty) return [];

      return maps.map((map) => AssetModel.fromJson(map)).toList();
    } catch (e) {
      print('Error getting forms by date range: $e');
      return [];
    }
  }

  Future<int> getAssetOwnershipCount(String assetField) async {
    final db = await DataDb.instance.database;
    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AssetFields.TABLE_NAME} WHERE $assetField = ?',
        ['1'],
      );
      return (result.first['count'] as int?) ?? 0;
    } catch (e) {
      print('Error counting asset ownership: $e');
      return 0;
    }
  }

  Future<void> close() async {
    final db = await DataDb.instance.database;
    await db.close();
  }
}