part of 'data_db.dart';

class HeelPrickBloodCollectionFormDb {
  static final HeelPrickBloodCollectionFormDb instance =
      HeelPrickBloodCollectionFormDb();

  // ==================== MAIN FORM METHODS ====================

  Future<void> deleteAllForms() async {
    final db = await DataDb.instance.database;
    await db.delete(HeelPrickBloodCollectionFormFields.TABLE_NAME);
    //  print('All heel prick blood collection forms deleted');
  }

  Future<bool> updateForm(HeelPrickBloodCollectionFormModel model) async {
    final db = await DataDb.instance.database;
    //  print(
    //   'parimary keys : ${[model.infantId, model.visitType, model.visitDate]}',
    // );
    // final newModel = await getFormById(
    //   infantId: model.infantId,
    //   visitType: model.visitType,
    //   visitDate: model.visitDate,
    // );
    //  print('Form get by infant id: ${model.infantId}: ${newModel == null}');
    try {
      final rowsAffected = await db.update(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        model.toJson(),
        where:
            '${HeelPrickBloodCollectionFormFields.infantId} = ? AND ${HeelPrickBloodCollectionFormFields.visitType} = ? AND ${HeelPrickBloodCollectionFormFields.visitDate} = ?',
        whereArgs: [model.infantId, model.visitType, model.visitDate],
      );
      //  print(
      //   'Heel prick blood collection form for infant ${model.infantId} updated $rowsAffected rows',
      // );
      // final newModel = await getFormById(
      //   infantId: model.infantId,
      //   visitType: model.visitType,
      //   visitDate: model.visitDate,
      // );
      //  print('Form get by infant id: ${model.infantId}: ${newModel == null}');
      //  print('Updated form data: ${newModel?.toJson()}');
      return rowsAffected > 0;
    } catch (e) {
      //  print('Error updating form for infant ${model.infantId}: $e');
      return false;
    }
  }

  Future<bool> deleteForm(String infantId, String visitType) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.delete(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where:
            '${HeelPrickBloodCollectionFormFields.infantId} = ? AND ${HeelPrickBloodCollectionFormFields.visitType} = ?',
        whereArgs: [infantId, visitType],
      );
      //  print('Heel prick blood collection form for infant $infantId deleted');
      return rowsAffected > 0;
    } catch (e) {
      //  print('Error deleting form for infant $infantId: $e');
      return false;
    }
  }

  Future<bool> deleteAllFormsForInfant(String infantId) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.delete(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where: '${HeelPrickBloodCollectionFormFields.infantId} = ?',
        whereArgs: [infantId],
      );
      //  print(
      //   'All heel prick blood collection forms for infant $infantId deleted',
      // );
      return rowsAffected > 0;
    } catch (e) {
      //  print('Error deleting forms for infant $infantId: $e');
      return false;
    }
  }

  Future<bool> createAllForms(
    List<HeelPrickBloodCollectionFormModel> formList,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final batch = db.batch();
      for (final form in formList) {
        batch.insert(
          HeelPrickBloodCollectionFormFields.TABLE_NAME,
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
    required HeelPrickBloodCollectionFormModel model,
  }) async {
    final db = await DataDb.instance.database;
    try {
      await db.insert(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      //  print('Heel prick blood collection form created successfully');
    } catch (e) {
      //  print('Error creating form: $e');
      return false;
    }
    return true;
  }

  Future<int> createNewForm({
    required HeelPrickBloodCollectionFormModel model,
  }) async {
    final db = await DataDb.instance.database;
    return await db.insert(
      HeelPrickBloodCollectionFormFields.TABLE_NAME,
      model.toJson(),
    );
  }

  Future<HeelPrickBloodCollectionFormModel?> createOrIgnoreForm({
    required HeelPrickBloodCollectionFormModel model,
  }) async {
    final db = await DataDb.instance.database;
     await db.insert(
      HeelPrickBloodCollectionFormFields.TABLE_NAME,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    //  print('Form initiate response: $res');
    final newModel = await getFormById(
      infantId: model.infantId,
      visitType: model.visitType,
      visitDate: model.visitDate,
    );
    //  print('Form get by infant id: ${model.infantId}: ${newModel == null}');
    return newModel;
  }

  Future<List<HeelPrickBloodCollectionFormModel>> readAllForms() async {
    final db = await DataDb.instance.database;
    final maps = await db.query(
      HeelPrickBloodCollectionFormFields.TABLE_NAME,
      columns: HeelPrickBloodCollectionFormFields.values,
    );

    if (maps.isEmpty) return [];

    return maps
        .map((map) => HeelPrickBloodCollectionFormModel.fromJson(map))
        .toList();
  }

  Future<List<HeelPrickBloodCollectionFormModel>> readAllNew() async {
    final db = await DataDb.instance.database;
    final maps = await db.query(
      HeelPrickBloodCollectionFormFields.TABLE_NAME,
      columns: HeelPrickBloodCollectionFormFields.values,
      where: '${HeelPrickBloodCollectionFormFields.syncDt} IS NULL and ${HeelPrickBloodCollectionFormFields.endDate} is not null and trim(${HeelPrickBloodCollectionFormFields.endDate}) != \'\' ',
    );

    if (maps.isEmpty) return [];

    return maps
        .map((map) => HeelPrickBloodCollectionFormModel.fromJson(map))
        .toList();
  }

  Future<HeelPrickBloodCollectionFormModel?> getFormById({
    required String? infantId,
    required String? visitType,
    required String? visitDate,
  }) async {
    if (infantId == null || visitType == null) return null;

    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where:
            '${HeelPrickBloodCollectionFormFields.infantId} = ? AND ${HeelPrickBloodCollectionFormFields.visitType} = ? AND ${HeelPrickBloodCollectionFormFields.visitDate} = ?',
        whereArgs: [infantId, visitType, visitDate],
      );
      if (maps.isNotEmpty) {
        return HeelPrickBloodCollectionFormModel.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      //  print('Error getting form for infant $infantId: $e');
      return null;
    }
  }

  Future<List<HeelPrickBloodCollectionFormModel>> getFormsByInfantId(
    String infantId,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where: '${HeelPrickBloodCollectionFormFields.infantId} = ?',
        whereArgs: [infantId],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodCollectionFormModel.fromJson(map))
          .toList();
    } catch (e) {
      //  print('Error getting forms for infant $infantId: $e');
      return [];
    }
  }

  Future<bool> checkFormExists(String infantId, String visitType) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where:
            '${HeelPrickBloodCollectionFormFields.infantId} = ? AND ${HeelPrickBloodCollectionFormFields.visitType} = ?',
        whereArgs: [infantId, visitType],
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
      //  print('Error checking form for infant $infantId: $e');
      return false;
    }
  }

  Future<String> countForms() async {
    final db = await DataDb.instance.database;
    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}',
      );
      return result.first['count'].toString();
    } catch (e) {
      //  print('Error counting forms: $e');
      return '0';
    }
  }

  Future<Map<String, int>> countFormsByVisitType() async {
    final db = await DataDb.instance.database;
    try {
      final result = await db.rawQuery('''
        SELECT ${HeelPrickBloodCollectionFormFields.visitType}, COUNT(*) as count 
        FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME} 
        GROUP BY ${HeelPrickBloodCollectionFormFields.visitType}
      ''');

      final stats = <String, int>{};
      for (final row in result) {
        final visitType =
            row[HeelPrickBloodCollectionFormFields.visitType]?.toString() ??
            'Unknown';
        final count = (row['count'] as int?) ?? 0;
        stats[visitType] = count;
      }
      return stats;
    } catch (e) {
      //  print('Error counting forms by visit type: $e');
      return {};
    }
  }

  Future<List<HeelPrickBloodCollectionFormModel>> getFormsBySampleStatus(
    bool isCollected,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final value = isCollected ? '1' : '2';
      final maps = await db.query(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where: '${HeelPrickBloodCollectionFormFields.q3_b} = ?',
        whereArgs: [value],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodCollectionFormModel.fromJson(map))
          .toList();
    } catch (e) {
      //  print('Error getting forms by sample status: $e');
      return [];
    }
  }

  Future<List<HeelPrickBloodCollectionFormModel>> getFormsByConsentStatus(
    bool isConsented,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final value = isConsented ? '1' : '2';
      final maps = await db.query(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where: '${HeelPrickBloodCollectionFormFields.q2} = ?',
        whereArgs: [value],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodCollectionFormModel.fromJson(map))
          .toList();
    } catch (e) {
      //  print('Error getting forms by consent status: $e');
      return [];
    }
  }

  Future<List<HeelPrickBloodCollectionFormModel>> getFormsByDateRange(
    String startDate,
    String endDate,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where: '${HeelPrickBloodCollectionFormFields.q3_e} BETWEEN ? AND ?',
        whereArgs: [startDate, endDate],
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodCollectionFormModel.fromJson(map))
          .toList();
    } catch (e) {
      //  print('Error getting forms by date range: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getQualityControlStats() async {
    final db = await DataDb.instance.database;
    try {
      // Total forms with sample collected
      final totalCollectedResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '1'
      ''');
      final totalCollected = (totalCollectedResult.first['count'] as int?) ?? 0;

      // Properly dried cards
      final properlyDriedResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '1' AND ${HeelPrickBloodCollectionFormFields.q3_k} = '1'
      ''');
      final properlyDried = (properlyDriedResult.first['count'] as int?) ?? 0;

      // Stored in freezer
      final storedInFreezerResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '1' AND ${HeelPrickBloodCollectionFormFields.q3_l} = '1'
      ''');
      final storedInFreezer =
          (storedInFreezerResult.first['count'] as int?) ?? 0;

      // Average circles filled
      final avgCirclesResult = await db.rawQuery('''
        SELECT AVG(CAST(${HeelPrickBloodCollectionFormFields.q3_h} AS REAL)) as avg_circles
        FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '1' AND ${HeelPrickBloodCollectionFormFields.q3_h} IS NOT NULL
      ''');
      final avgCircles =
          (avgCirclesResult.first['avg_circles'] as double?) ?? 0.0;

      // Average satisfactory circles
      final avgSatisfactoryResult = await db.rawQuery('''
        SELECT AVG(CAST(${HeelPrickBloodCollectionFormFields.q3_i} AS REAL)) as avg_satisfactory
        FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '1' AND ${HeelPrickBloodCollectionFormFields.q3_i} IS NOT NULL
      ''');
      final avgSatisfactory =
          (avgSatisfactoryResult.first['avg_satisfactory'] as double?) ?? 0.0;

      return {
        'totalCollected': totalCollected,
        'properlyDried': properlyDried,
        'properlyDriedPercentage': totalCollected > 0
            ? (properlyDried / totalCollected * 100).toStringAsFixed(1)
            : '0',
        'storedInFreezer': storedInFreezer,
        'storedInFreezerPercentage': totalCollected > 0
            ? (storedInFreezer / totalCollected * 100).toStringAsFixed(1)
            : '0',
        'avgCirclesFilled': avgCircles.toStringAsFixed(1),
        'avgSatisfactoryCircles': avgSatisfactory.toStringAsFixed(1),
      };
    } catch (e) {
      //  print('Error getting quality control stats: $e');
      return {
        'totalCollected': 0,
        'properlyDried': 0,
        'properlyDriedPercentage': '0',
        'storedInFreezer': 0,
        'storedInFreezerPercentage': '0',
        'avgCirclesFilled': '0',
        'avgSatisfactoryCircles': '0',
      };
    }
  }

  Future<Map<String, dynamic>> getCollectionReasonsStats() async {
    final db = await DataDb.instance.database;
    try {
      final reasons = {
        '1': 'Moved out',
        '2': 'Died',
        '3': 'Refused',
        '4': 'Consent withdrawn',
        '5': 'Collection failure',
        '6': 'Others',
      };

      final stats = <String, int>{};

      for (final entry in reasons.entries) {
        final result = await db.rawQuery(
          '''
          SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
          WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '2' AND ${HeelPrickBloodCollectionFormFields.q3_c} = ?
        ''',
          [entry.key],
        );

        final count = (result.first['count'] as int?) ?? 0;
        if (count > 0) {
          stats[entry.value] = count;
        }
      }

      return stats;
    } catch (e) {
      //  print('Error getting collection reasons stats: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getPlaceOfCollectionStats() async {
    final db = await DataDb.instance.database;
    try {
      final result = await db.rawQuery('''
        SELECT ${HeelPrickBloodCollectionFormFields.q3_g}, COUNT(*) as count 
        FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '1'
        GROUP BY ${HeelPrickBloodCollectionFormFields.q3_g}
      ''');

      final placeLabels = {'1': 'Home', '2': 'Hospital', '3': 'Other'};

      final stats = <String, int>{};
      for (final row in result) {
        final placeCode =
            row[HeelPrickBloodCollectionFormFields.q3_g]?.toString() ?? '';
        final placeName = placeLabels[placeCode] ?? placeCode;
        final count = (row['count'] as int?) ?? 0;
        stats[placeName] = count;
      }

      return stats;
    } catch (e) {
      //  print('Error getting place of collection stats: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getFormStatistics() async {
    final db = await DataDb.instance.database;
    try {
      final totalForms = await countForms();

      final collectedResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '1'
      ''');
      final collected = (collectedResult.first['count'] as int?) ?? 0;

      final notCollectedResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q3_b} = '2'
      ''');
      final notCollected = (notCollectedResult.first['count'] as int?) ?? 0;

      final consentedResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${HeelPrickBloodCollectionFormFields.TABLE_NAME}
        WHERE ${HeelPrickBloodCollectionFormFields.q2} = '1'
      ''');
      final consented = (consentedResult.first['count'] as int?) ?? 0;

      final visitTypeStats = await countFormsByVisitType();
      final qualityStats = await getQualityControlStats();
      final collectionReasons = await getCollectionReasonsStats();
      final placeStats = await getPlaceOfCollectionStats();

      return {
        'totalForms': totalForms,
        'collected': collected,
        'notCollected': notCollected,
        'consented': consented,
        'collectionRate': int.parse(totalForms) > 0
            ? (collected / int.parse(totalForms) * 100).toStringAsFixed(1)
            : '0',
        'consentRate': int.parse(totalForms) > 0
            ? (consented / int.parse(totalForms) * 100).toStringAsFixed(1)
            : '0',
        'visitTypeStats': visitTypeStats,
        'qualityStats': qualityStats,
        'collectionReasons': collectionReasons,
        'placeStats': placeStats,
      };
    } catch (e) {
      //  print('Error getting form statistics: $e');
      return {
        'totalForms': '0',
        'collected': 0,
        'notCollected': 0,
        'consented': 0,
        'collectionRate': '0',
        'consentRate': '0',
        'visitTypeStats': {},
        'qualityStats': {},
        'collectionReasons': {},
        'placeStats': {},
      };
    }
  }

  Future<List<HeelPrickBloodCollectionFormModel>> getIncompleteForms() async {
    final db = await DataDb.instance.database;
    try {
      final maps = await db.query(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        where: '${HeelPrickBloodCollectionFormFields.q3_e} IS NULL',
      );

      if (maps.isEmpty) return [];

      return maps
          .map((map) => HeelPrickBloodCollectionFormModel.fromJson(map))
          .toList();
    } catch (e) {
      //  print('Error getting incomplete forms: $e');
      return [];
    }
  }

  Future<int> updateSyncDate(
    String infantId,
    String visitType,
    String syncDateTime,
  ) async {
    final db = await DataDb.instance.database;
    try {
      final rowsAffected = await db.update(
        HeelPrickBloodCollectionFormFields.TABLE_NAME,
        {HeelPrickBloodCollectionFormFields.syncDt: syncDateTime},
        where:
            '${HeelPrickBloodCollectionFormFields.infantId} = ? AND ${HeelPrickBloodCollectionFormFields.visitType} = ?',
        whereArgs: [infantId, visitType],
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
