// part 'common_report_db.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/pending_infant_model.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../prefs/user_prefs.dart';
import 'fields/asset_fields.dart';
import 'fields/enrollment_form_field.dart';
import 'fields/growth_and_outcome_form_field.dart';
import 'fields/heel_prick_blood_collection_form_fields.dart';
import 'fields/heel_prick_blood_infant_fields.dart';
import 'fields/user_fields.dart';
import 'models/asset_model.dart';
import 'models/enrollment_form_model.dart';
import 'models/growth_and_outcome_form_model.dart';
import 'models/heel_prick_blood_collection_form_model.dart';
import 'models/heel_prick_blood_infent_model.dart';
import 'models/user_model.dart';
part 'user_db.dart';
part 'heel_prick_blood_infent_db.dart';
part 'heel_prick_blood_collection_form_db.dart';
part 'pending_infant_db.dart';
part 'enrollment_form_db.dart';
part 'growth_and_outcome_form_db.dart';
part 'asset_db.dart';

class DataDb {
  static final DataDb instance = DataDb._init();
  static Database? _database;

  DataDb._init();

  static const String _dbName = 'hpbc.db';

  Future<Database> get database async {
    _database ??= await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // print('Database path: $path');

    return await openDatabase(path, version: 9, onCreate: _createDB);
  }

  Future<void> _openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _database = await openDatabase(path, version: 9);
  }

  Future<String> exportDb() async {
    final db = await DataDb.instance.database;
    await db.close();
    bool granted = await requestStoragePermission();
    if (!granted) {
      // print("❌ Storage permission denied");
      _openDb();
      return "";
    }

    String dbPath = join(await getDatabasesPath(), _dbName);
    File dbFile = File(dbPath);

    // Downloads directory (works on most Android phones)
    Directory downloadsDir = Directory("/storage/emulated/0/Download");
    String newPath = join(
      downloadsDir.path,
      "${UserPrefs.userModel.userId}_hpbc.db",
    );

    await dbFile.copy(newPath);
    // print("✅ Database exported to: $newPath");
    _openDb();
    return newPath;
  }

  Future<void> restoreDatabase() async {
    // String dbPath = join(await getDatabasesPath(), _dbName);

    // // Close current DB
    // Database db = await openDatabase(dbPath);
    // await db.close();

    // Downloads directory (works on most Android phones)
    // Directory downloadsDir = Directory("/storage/emulated/0/Download");
    // String backupPath = join(downloadsDir.path, "db_agri_farmer_data-backup.db");

    final List<PlatformFile> result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
    );
    final String? backupPath = result.first.path;
    // print("📂 Selected backup file: $backupPath");
    if (backupPath == null) {
      // print("❌ No file selected");
      return;
    }
    // Read backup
    File backupFile = File(backupPath);
    List<int> bytes = await backupFile.readAsBytes();

    // Overwrite current DB
    String dbPath = join(await getDatabasesPath(), _dbName);
    File dbFile = File(dbPath);
    await dbFile.writeAsBytes(bytes, flush: true);

    // print("✅ Database restored from backup");
    _openDb();
  }

  Future _createDB(Database db, int version) async {
    // const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeN = 'TEXT';
    // const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE ${UserFields.TABLE_NAME}(
      ${UserFields.userId} $textType PRIMARY KEY,
      ${UserFields.userPass} $textType,
      ${UserFields.name} $textType,
      ${UserFields.userLevel} $textTypeN,
      ${UserFields.designation} $textTypeN,
      ${UserFields.phone} $textTypeN,
      ${UserFields.cluster1} $textTypeN,
      ${UserFields.cluster2} $textTypeN,
      ${UserFields.teamId} $textTypeN)''');
    await db.execute('''
    insert or ignore into ${UserFields.TABLE_NAME}(${UserFields.userId},
      ${UserFields.userPass}, ${UserFields.name}, ${UserFields.userLevel},
      ${UserFields.designation}, ${UserFields.phone}, ${UserFields.cluster1}, ${UserFields.cluster2}, ${UserFields.teamId})
      VALUES ("881", "1180", "Admin", "1", "ADMIN", "", "", "", ""),
      ("211", "123", "Hosan Ali", "2", "Lab", "", "", "", ""),
      ("871", "123", "Jusna Bala", "1", "IOA", "01314593847", "103A", "103B", "301"),
      ("410", "123", "Marzana Begum", "1", "IOA", "01733700792", "103A", "103B", "301"),
      ("407", "123", "Uma Begum", "1", "IOA", "01703298051", "105A", "105B", "302"),
      ("813", "123", "Joli Rani Biswas", "1", "IOA", "01305362185", "105A", "105B", "302"),
      ("815", "123", "Somita Begum", "1", "IOA", "01767798747", "107A", "107B", "303"),
      ("409", "123", "Moni Akter Munni", "1", "IOA", "01317927752", "107A", "107B", "303"),
      ("812", "123", "Yeasmin Akter Tamanna", "1", "IOA", "01790258423", "109A", "109B", "304"),
      ("751", "123", "Tanjina Afrin", "1", "IOA", "01762150270", "109A", "109B", "304"),
      ("749", "123", "Suhada Begum-2", "1", "IOA", "01752670898", "114A", "116A", "305"),
      ("748", "123", "Surovi Rani Ray", "1", "IOA", "01733700792", "114A", "116A", "305"),
      ("442", "123", "Sumona Akter Juma", "1", "IOA", "01612918661", "106A", "106B", "306"),
      ("787", "123", "Sumi Begum", "1", "IOA", "01911454292", "106A", "106B", "306"),
      ("811", "123", "Tamanna Begum", "1", "IOA", "01765792861", "110A", "110B", "307"),
      ("880", "123", "Sunna Akther", "1", "IOA", "01707891836", "110A", "110B", "307"),
      ("747", "123", "Suhada Begum-1", "1", "IOA", "01730171731", "104A", "104B", "308"),
      ("786", "123", "Lucky Rani Ray", "1", "IOA", "01726982530", "104A", "104B", "308"),
      ("413", "123", "Ema Begum", "1", "IOA", "01763517105", "108A", "108B", "309"),
      ("814", "123", "Parul Begum", "1", "IOA", "01319353545", "108A", "108B", "309")
    ''');

    await db.execute(''' CREATE TABLE ${HeelPrickBloodInfantFields.TABLE_NAME} (
        ${HeelPrickBloodInfantFields.infantId} $textType,
        ${HeelPrickBloodInfantFields.cluster} $textTypeN,
        ${HeelPrickBloodInfantFields.siteWomanId} $textTypeN,
        ${HeelPrickBloodInfantFields.pregSL} $textTypeN,
        ${HeelPrickBloodInfantFields.dob} $textTypeN,
        ${HeelPrickBloodInfantFields.tob} $textTypeN,
        ${HeelPrickBloodInfantFields.pidBaby} $textTypeN,
        ${HeelPrickBloodInfantFields.cSex} $textTypeN,
        ${HeelPrickBloodInfantFields.visitType} $textType,
        ${HeelPrickBloodInfantFields.sampleId} $textTypeN,
        ${HeelPrickBloodInfantFields.dueDate} $textTypeN,
        ${HeelPrickBloodInfantFields.endDate} $textTypeN,
        ${HeelPrickBloodInfantFields.childName} $textTypeN,
        ${HeelPrickBloodInfantFields.childPid} $textTypeN,
        ${HeelPrickBloodInfantFields.childCid} $textTypeN,
        ${HeelPrickBloodInfantFields.fatherName} $textTypeN,
        ${HeelPrickBloodInfantFields.motherName} $textTypeN,
        ${HeelPrickBloodInfantFields.motherCid} $textTypeN,
        ${HeelPrickBloodInfantFields.mobile} $textTypeN,
        ${HeelPrickBloodInfantFields.dtRandom} $textTypeN,
        ${HeelPrickBloodInfantFields.syncDt} $textTypeN, 
        PRIMARY KEY(${HeelPrickBloodInfantFields.infantId}, ${HeelPrickBloodInfantFields.visitType})
      )
    ''');

    await db.execute(
      ''' CREATE TABLE ${HeelPrickBloodCollectionFormFields.TABLE_NAME} (
        ${HeelPrickBloodCollectionFormFields.infantId} $textType NOT NULL,
        ${HeelPrickBloodCollectionFormFields.pregSl} $textType NOT NULL,
        ${HeelPrickBloodCollectionFormFields.visitType} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.visitDate} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.syncDt} $textTypeN,
        
        -- Section 1: Identification
        ${HeelPrickBloodCollectionFormFields.q1_a} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q1_b} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q1_c} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q1_d} $textTypeN,
        
        -- Section 2: Consent
        ${HeelPrickBloodCollectionFormFields.q2} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q2_a} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q2_b} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q2_c} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q2_c_sp} $textTypeN,
        
        -- Section 3: Collection and processing
        ${HeelPrickBloodCollectionFormFields.q3_a} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_b} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_c} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_c_other} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_d} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_e} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_f} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_g} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_g_other} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_h} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_i} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_j} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_k} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_l} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.q3_m} $textTypeN,
        
        -- Location
        ${HeelPrickBloodCollectionFormFields.lat} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.lng} $textTypeN,
        ${HeelPrickBloodCollectionFormFields.endDate} $textTypeN,
        
        PRIMARY KEY (${HeelPrickBloodCollectionFormFields.infantId}, ${HeelPrickBloodCollectionFormFields.visitType}, ${HeelPrickBloodCollectionFormFields.visitDate}, ${HeelPrickBloodCollectionFormFields.pregSl})
      )
    ''',
    );
    await db.execute('''
    CREATE TABLE ${PendingInfantEnum.pendingInfantTable.name}(
      ${PendingInfantEnum.babyPid.name} $textType PRIMARY KEY,
      ${PendingInfantEnum.householdId.name} $textType,
      ${PendingInfantEnum.siteWomanId.name} $textType,
      ${PendingInfantEnum.womanName.name} $textType,
      ${PendingInfantEnum.childName.name} $textType,
      ${PendingInfantEnum.branchWomanId.name} $textType,
      ${PendingInfantEnum.fatherName.name} $textType,
      ${PendingInfantEnum.pregSl.name} $textTypeN,
      ${PendingInfantEnum.numOfBabies.name} $textTypeN,
      ${PendingInfantEnum.infantId.name} $textTypeN,
      ${PendingInfantEnum.childSex.name} $textTypeN,
      ${PendingInfantEnum.childPid.name} $textTypeN,
      ${PendingInfantEnum.dob.name} $textTypeN,
      ${PendingInfantEnum.phone.name} $textTypeN,
      ${PendingInfantEnum.cluster.name} $textTypeN)''');

    await db.execute('''
  CREATE TABLE ${EnrollmentFormField.TABLE_NAME}(
    ${EnrollmentFormField.infantId} $textType,
    ${EnrollmentFormField.pregSL} $textType,

    ${EnrollmentFormField.q101} $textTypeN,
    ${EnrollmentFormField.q102} $textTypeN,
    ${EnrollmentFormField.q103} $textTypeN,
    ${EnrollmentFormField.q104} $textTypeN,
    ${EnrollmentFormField.q105} $textTypeN,

    ${EnrollmentFormField.q202a} $textTypeN,
    ${EnrollmentFormField.q202b} $textTypeN,
    ${EnrollmentFormField.q202c} $textTypeN,
    ${EnrollmentFormField.q202d} $textTypeN,

    ${EnrollmentFormField.q301} $textTypeN,
    ${EnrollmentFormField.q302} $textTypeN,

    ${EnrollmentFormField.q401} $textTypeN,
    ${EnrollmentFormField.q402} $textTypeN,
    ${EnrollmentFormField.q403} $textTypeN,
    ${EnrollmentFormField.q404} $textTypeN,
    ${EnrollmentFormField.q405} $textTypeN,
    ${EnrollmentFormField.q406} $textTypeN,
    ${EnrollmentFormField.q407} $textTypeN,
    ${EnrollmentFormField.q408} $textTypeN,
    ${EnrollmentFormField.q409} $textTypeN,
    ${EnrollmentFormField.q410} $textTypeN,
    ${EnrollmentFormField.q411} $textTypeN,
    ${EnrollmentFormField.q412} $textTypeN,
    ${EnrollmentFormField.q413} $textTypeN,

    ${EnrollmentFormField.q501} $textTypeN,
    ${EnrollmentFormField.q502a} $textTypeN,
    ${EnrollmentFormField.q502b} $textTypeN,

    ${EnrollmentFormField.q601} $textTypeN,
    ${EnrollmentFormField.q602} $textTypeN,

    ${EnrollmentFormField.father} $textTypeN,
    ${EnrollmentFormField.phone} $textTypeN,
    ${EnrollmentFormField.dob} $textTypeN,
    ${EnrollmentFormField.userId} $textTypeN,
    ${EnrollmentFormField.startDt} $textTypeN,
    ${EnrollmentFormField.enDt} $textTypeN,
    ${EnrollmentFormField.lat} $textTypeN,
    ${EnrollmentFormField.lng} $textTypeN,
    ${EnrollmentFormField.syncDt} $textTypeN,
    PRIMARY KEY(${EnrollmentFormField.infantId}, ${EnrollmentFormField.pregSL})
  )
''');

await db.execute('''
  CREATE TABLE ${GrowthAndOutcomeFormField.TABLE_NAME}(
    ${GrowthAndOutcomeFormField.infantId} $textType,
    ${GrowthAndOutcomeFormField.pregSl} $textType,

    ${GrowthAndOutcomeFormField.q101} $textTypeN,
    ${GrowthAndOutcomeFormField.q105} $textTypeN,

    ${GrowthAndOutcomeFormField.q201} $textType,
    ${GrowthAndOutcomeFormField.q201a} $textTypeN,
    ${GrowthAndOutcomeFormField.q201b} $textTypeN,
    ${GrowthAndOutcomeFormField.q201c} $textTypeN,
    ${GrowthAndOutcomeFormField.q201d} $textTypeN,
    ${GrowthAndOutcomeFormField.q201e} $textTypeN,

    ${GrowthAndOutcomeFormField.q301} $textTypeN,
    ${GrowthAndOutcomeFormField.q302} $textTypeN,
    ${GrowthAndOutcomeFormField.q303} $textTypeN,
    ${GrowthAndOutcomeFormField.q304} $textTypeN,

    ${GrowthAndOutcomeFormField.q401} $textTypeN,
    ${GrowthAndOutcomeFormField.q401a} $textTypeN,
    ${GrowthAndOutcomeFormField.q401b} $textTypeN,
    ${GrowthAndOutcomeFormField.q402} $textTypeN,
    ${GrowthAndOutcomeFormField.q402a} $textTypeN,
    ${GrowthAndOutcomeFormField.q402b} $textTypeN,
    ${GrowthAndOutcomeFormField.q403} $textTypeN,
    ${GrowthAndOutcomeFormField.q403a} $textTypeN,
    ${GrowthAndOutcomeFormField.q403b} $textTypeN,
    ${GrowthAndOutcomeFormField.q404} $textTypeN,
    ${GrowthAndOutcomeFormField.q404a} $textTypeN,
    ${GrowthAndOutcomeFormField.q404b} $textTypeN,

    ${GrowthAndOutcomeFormField.userId} $textTypeN,
    ${GrowthAndOutcomeFormField.startDt} $textTypeN,
    ${GrowthAndOutcomeFormField.enDt} $textTypeN,
    ${GrowthAndOutcomeFormField.lat} $textTypeN,
    ${GrowthAndOutcomeFormField.lng} $textTypeN,
    ${GrowthAndOutcomeFormField.syncDt} $textTypeN,
    PRIMARY KEY (${GrowthAndOutcomeFormField.infantId}, ${GrowthAndOutcomeFormField.pregSl}, ${GrowthAndOutcomeFormField.q201})
  )
''');

     await db.execute(''' CREATE TABLE ${AssetFields.TABLE_NAME} (
        ${AssetFields.infantId} $textType,
        
        -- Section 1: ID and visit details
        ${AssetFields.q101} $textTypeN,
        ${AssetFields.q102} $textTypeN,
        ${AssetFields.q103} $textTypeN,
        ${AssetFields.q104} $textTypeN,
        ${AssetFields.q105} $textTypeN,
        ${AssetFields.q106} $textTypeN,
        ${AssetFields.q107} $textTypeN,
        ${AssetFields.q108} $textTypeN,
        ${AssetFields.q109} $textTypeN,
        
        -- Section 2: Anthropometry of woman
        ${AssetFields.q201} $textTypeN,
        ${AssetFields.q202} $textTypeN,
        ${AssetFields.q203} $textTypeN,
        ${AssetFields.q204} $textTypeN,
        ${AssetFields.q205} $textTypeN,
        ${AssetFields.q206} $textTypeN,
        ${AssetFields.q207} $textTypeN,
        ${AssetFields.q208} $textTypeN,
        ${AssetFields.q209} $textTypeN,
        ${AssetFields.q210} $textTypeN,
        ${AssetFields.q211} $textTypeN,
        ${AssetFields.q212} $textTypeN,
        ${AssetFields.q213} $textTypeN,
        ${AssetFields.q215} $textTypeN,
        ${AssetFields.q216} $textTypeN,
        ${AssetFields.q217} $textTypeN,
        ${AssetFields.q218} $textTypeN,
        ${AssetFields.q219} $textTypeN,
        ${AssetFields.q220} $textTypeN,
        ${AssetFields.q221} $textTypeN,
        ${AssetFields.q222} $textTypeN,
        ${AssetFields.q223} $textTypeN,
        ${AssetFields.q224} $textTypeN,
        ${AssetFields.q225} $textTypeN,
        
        -- Location
        ${AssetFields.lat} $textTypeN,
        ${AssetFields.lng} $textTypeN,
        
        -- Meta fields
        ${AssetFields.entryUserId} $textTypeN,
        ${AssetFields.entryDate} $textTypeN,
        ${AssetFields.startDT} $textTypeN,
        ${AssetFields.endDT} $textTypeN,
        ${AssetFields.syncDt} $textTypeN,
        PRIMARY KEY(${AssetFields.infantId})
      )
    ''');
  }

  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // return await openDatabase(Path, version: 7, onCreate: _createDB);
    // Get the directory where the database file is stored
    // Check if the database file exists
    if (await File(path).exists()) {
      // Delete the database file
      await deleteDatabase(path);
      _database = null;
      // print('--__-- Database file deleted successfully');
    } else {
      // print('--__-- Database file does not exist');
    }
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else if (await Permission.manageExternalStorage.request().isGranted) {
      return true; // Android 11+
    }
    return false;
  }

  Future<bool> executeRawQuery({required String query}) async {
    final db = await DataDb.instance.database;
    try {
      await db.rawQuery(query);
      return true;
    } catch (e) {
      // print('Error getting upazilas: $e');
      return false;
    }
  }
}
