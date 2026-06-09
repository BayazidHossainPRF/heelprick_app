// part 'common_report_db.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../prefs/user_prefs.dart';
import 'fields/heel_prick_blood_collection_form_fields.dart';
import 'fields/heel_prick_blood_infant_fields.dart';
import 'fields/user_fields.dart';
import 'models/heel_prick_blood_collection_form_model.dart';
import 'models/heel_prick_blood_infent_model.dart';
import 'models/user_model.dart';
part 'user_db.dart';
part 'heel_prick_blood_infent_db.dart';
part 'heel_prick_blood_collection_form_db.dart';

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
    final Path = join(dbPath, filePath);
    print('Database path: $Path');

    return await openDatabase(Path, version: 9, onCreate: _createDB);
  }

  Future<void> _openDb() async {
    final dbPath = await getDatabasesPath();
    final Path = join(dbPath, _dbName);
    _database = await openDatabase(Path, version: 9);
  }

  Future<String> exportDb() async {
    final db = await DataDb.instance.database;
    await db.close();
    bool granted = await requestStoragePermission();
    if (!granted) {
      print("❌ Storage permission denied");
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
    print("✅ Database exported to: $newPath");
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

    // Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result == null) {
      print("❌ No file selected");
      return;
    }

    String backupPath = result.files.single.path!;
    print("📂 Selected backup file: $backupPath");

    // Read backup
    File backupFile = File(backupPath);
    List<int> bytes = await backupFile.readAsBytes();

    // Overwrite current DB
    String dbPath = join(await getDatabasesPath(), _dbName);
    File dbFile = File(dbPath);
    await dbFile.writeAsBytes(bytes, flush: true);

    print("✅ Database restored from backup");
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
      ("211", "123", "Hosan Ali", "1", "IOA", "", "", "", "")
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

    await db.execute(''' CREATE TABLE ${HeelPrickBloodCollectionFormFields.TABLE_NAME} (
        ${HeelPrickBloodCollectionFormFields.infantId} $textType NOT NULL,
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
        
        PRIMARY KEY (${HeelPrickBloodCollectionFormFields.infantId}, ${HeelPrickBloodCollectionFormFields.visitType}, ${HeelPrickBloodCollectionFormFields.visitDate})
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
      print('--__-- Database file deleted successfully');
    } else {
      print('--__-- Database file does not exist');
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
      print('Error getting upazilas: $e');
      return false;
    }
  }
}
