import 'package:drift/drift.dart';

@DataClassName('TaskRow')
class Tasks extends Table {
  IntColumn get id => integer().nullable()();

  TextColumn get name => text().nullable()();

  BoolColumn get important => boolean().nullable()();

  BoolColumn get completed => boolean().nullable()();

  IntColumn get created => integer().nullable()();

  @override
  String get tableName => 'Task';

  @override
  Set<Column<Object>> get primaryKey => {id};
}
