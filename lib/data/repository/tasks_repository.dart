import 'package:todo_clone/core/constants/app_constants.dart';
import 'package:todo_clone/data/local/local_source.dart';
import 'package:todo_clone/data/model/task.dart';

class TasksRepository {
  TasksRepository();

  LocalSource? _localSource;

  LocalSource get localSource => _localSource ??= LocalSource.getInstance()!;

  Future<List<Task>> getTasks(
    String? searchQuery,
    SortOrder sortOrder,
    bool hideCompleted,
  ) {
    return localSource.getTasks(searchQuery, sortOrder, hideCompleted);
  }

  Future<void> insertTask(Task task) async {
    await localSource.insertTask(task);
  }

  Future<void> deleteCompletedTasks() async {
    await localSource.deleteAllCompletedTasks();
  }

  Future<void> updateTask(Task task) async {
    await localSource.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    await localSource.deleteTask(task);
  }

  Future<void> setSortOrder(SortOrder sortOrder) async {
    await localSource.setSortOrder(sortOrder);
  }

  Future<void> setHideCompleted(bool value) async {
    await localSource.setHideCompleted(value);
  }

  SortOrder getSortOrder() => localSource.getSortOrder();

  bool getHideCompleted() => localSource.getHideCompleted();
}
