part of 'data_db.dart';


class PendingInfantDb {
  static final PendingInfantDb instance = PendingInfantDb();

  Future<int> create({required PendingInfantModel model}) async {
    final db = await DataDb.instance.database;
    return await db.insert(
      PendingInfantEnum.pendingInfantTable.name,
      model.toJson(),
    );
  }

  Future<List<PendingInfantModel>> readAllForms() async {
    final db = await DataDb.instance.database;
    final maps = await db.query(
      PendingInfantEnum.pendingInfantTable.name,
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => PendingInfantModel.fromJson(map)).toList();
  }

  Future<List<PendingInfantModel>> readTodoEnrollment() async {
    final db = await DataDb.instance.database;
    final maps = await db.rawQuery('''
      SELECT pit.* from pendingInfantTable pit
        left join tbl_heel_prick_enrollment_form en
        on pit.infantId = en.infantId 
        and trim(en.enDt) != '' and en.enDt is not null
        where en.infantId is null
    ''');

    if (maps.isEmpty) return [];

    return maps.map((map) => PendingInfantModel.fromJson(map)).toList();
  }

  // Future<List<HeelPrickBloodInfantModel>> readTodoFormsByVisitType({
  //   required String listType,
  // }) async {
  //   final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   final db = await DataDb.instance.database;
  //   final maps = await db.rawQuery('''
  //     WITH last_record AS (
  //         SELECT 
  //             infant_id,
  //             visit_type,
  //             q2,
	// 		  q2_c,
  //             visit_date,
  //             ROW_NUMBER() OVER (
  //                 PARTITION BY infant_id, visit_type 
  //                 ORDER BY date(visit_date) DESC
  //             ) AS rn,
	// 		  end_date
  //         FROM tbl_heel_prick_blood_collection_form
  //     )
  //     SELECT hi.*
  //     FROM tbl_heel_prick_blood_infant hi
  //     -- Join latest record only
  //     LEFT JOIN last_record lr
  //         ON hi.infant_id = lr.infant_id
  //         AND hi.visit_type = lr.visit_type
  //         AND lr.rn = 1

  //     WHERE hi.visit_type='$listType' AND
  //         NOT EXISTS (
  //             SELECT 1 FROM tbl_heel_prick_blood_collection_form t
  //             WHERE t.infant_id = hi.infant_id
  //            AND t.visit_type = hi.visit_type
  //            AND t.visit_date = '$today'
  //            AND t.end_date IS NOT NULL
  //         )
  //         AND (
  //             lr.infant_id IS NULL  
  //           or (lr.q2 = '2' and lr.q2_c not in ('1', '2'))
	// 		or lr.end_date is null
  //         );
  //   ''');

  //   if (maps.isEmpty) return [];

  //   return maps.map((map) => HeelPrickBloodInfantModel.fromJson(map)).toList();
  // }

}
