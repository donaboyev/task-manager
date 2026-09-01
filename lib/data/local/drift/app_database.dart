import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show getDatabasesPath;
import 'package:todo_clone/core/constants/app_constants.dart';
import 'package:todo_clone/data/local/drift/dao/tasks_dao.dart';
import 'package:todo_clone/data/local/drift/tables/tasks.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks], daos: [TasksDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static late AppDatabase instance;

  static Future<void> init() async {
    instance = AppDatabase._();
    await instance.customSelect('SELECT 1').get();
  }

  @override
  int get schemaVersion => AppConstants.databaseVersion;
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'task_manager',
    native: DriftNativeOptions(
      databasePath: () async =>
          p.join(await getDatabasesPath(), 'task_manager.db'),
    ),
  );
}
