import 'package:drift/drift.dart';
import 'package:todo_clone/core/constants/app_constants.dart';
import 'package:todo_clone/data/local/drift/app_database.dart';
import 'package:todo_clone/data/local/drift/tables/tasks.dart';
import 'package:todo_clone/data/model/task.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.attachedDatabase);

  Future<List<Task>> getTasks(
    String query,
    SortOrder sortOrder,
    bool hideCompleted,
  ) async {
    final statement = select(tasks)
      ..where((task) {
        final matchesSearch = task.name.like(query);
        return hideCompleted
            ? matchesSearch & task.completed.equals(false)
            : matchesSearch & task.completed.isNotNull();
      })
      ..orderBy([
        (task) => OrderingTerm.desc(task.important),
        (task) => sortOrder == SortOrder.byDate
            ? OrderingTerm.asc(task.created)
            : OrderingTerm.asc(task.name),
      ]);

    final rows = await statement.get();
    return rows.map(_toTask).toList();
  }

  Future<void> insertTask(Task task) async {
    await into(tasks)
        .insert(_toCompanion(task), mode: InsertMode.insertOrReplace);
  }

  Future<void> updateTask(Task task) async {
    final id = task.id;
    if (id == null) return;

    await (update(
      tasks,
    )..where((row) => row.id.equals(id))).write(_toCompanion(task));
  }

  Future<void> deleteTask(Task task) async {
    final id = task.id;
    if (id == null) return;

    await (delete(tasks)..where((row) => row.id.equals(id))).go();
  }

  Future<void> deleteCompletedTasks() async {
    await (delete(tasks)..where((task) => task.completed.equals(true))).go();
  }

  TasksCompanion _toCompanion(Task task) => TasksCompanion(
    id: Value(task.id),
    name: Value(task.name),
    important: Value(task.important),
    completed: Value(task.completed),
    created: Value(task.created),
  );

  Task _toTask(TaskRow row) => Task(
    id: row.id,
    name: row.name,
    important: row.important,
    completed: row.completed,
    created: row.created,
  );
}
