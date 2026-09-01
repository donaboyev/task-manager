// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TasksDao? _tasksDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Task` (`id` INTEGER, `name` TEXT, `important` INTEGER, `completed` INTEGER, `created` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TasksDao get tasksDao {
    return _tasksDaoInstance ??= _$TasksDao(database, changeListener);
  }
}

class _$TasksDao extends TasksDao {
  _$TasksDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'Task',
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'important':
                      item.important == null ? null : (item.important! ? 1 : 0),
                  'completed':
                      item.completed == null ? null : (item.completed! ? 1 : 0),
                  'created': item.created
                }),
        _taskUpdateAdapter = UpdateAdapter(
            database,
            'Task',
            ['id'],
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'important':
                      item.important == null ? null : (item.important! ? 1 : 0),
                  'completed':
                      item.completed == null ? null : (item.completed! ? 1 : 0),
                  'created': item.created
                }),
        _taskDeletionAdapter = DeletionAdapter(
            database,
            'Task',
            ['id'],
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'important':
                      item.important == null ? null : (item.important! ? 1 : 0),
                  'completed':
                      item.completed == null ? null : (item.completed! ? 1 : 0),
                  'created': item.created
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Task> _taskInsertionAdapter;

  final UpdateAdapter<Task> _taskUpdateAdapter;

  final DeletionAdapter<Task> _taskDeletionAdapter;

  @override
  Future<List<Task>> getTasksSortedByDateCreated(
    String query,
    bool hideCompleted,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Task WHERE (completed != ?2 OR completed = 0) AND name LIKE ?1 ORDER BY important DESC, created',
        mapper: (Map<String, Object?> row) => Task(id: row['id'] as int?, name: row['name'] as String?, important: row['important'] == null ? null : (row['important'] as int) != 0, completed: row['completed'] == null ? null : (row['completed'] as int) != 0, created: row['created'] as int?),
        arguments: [query, hideCompleted ? 1 : 0]);
  }

  @override
  Future<List<Task>> getTasksSortedByName(
    String query,
    bool hideCompleted,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Task WHERE (completed != ?2 OR completed = 0) AND name LIKE ?1 ORDER BY important DESC, name',
        mapper: (Map<String, Object?> row) => Task(id: row['id'] as int?, name: row['name'] as String?, important: row['important'] == null ? null : (row['important'] as int) != 0, completed: row['completed'] == null ? null : (row['completed'] as int) != 0, created: row['created'] as int?),
        arguments: [query, hideCompleted ? 1 : 0]);
  }

  @override
  Future<void> deleteCompletedTasks() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Task WHERE completed = 1');
  }

  @override
  Future<void> insertTask(Task task) async {
    await _taskInsertionAdapter.insert(task, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _taskUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _taskDeletionAdapter.delete(task);
  }
}
