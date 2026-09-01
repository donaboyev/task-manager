import 'package:todo_clone/core/constants/app_constants.dart';
import 'package:todo_clone/data/local/local_source.dart';
import 'package:todo_clone/data/model/task.dart';

class TasksRepository {
  final LocalSource? _localSource = LocalSource.getInstance();

  Future<List<Task>> getTasks(
      String? searchQuery, SortOrder sortOrder, bool hideCompleted) {
    return _localSource!.getTasks(searchQuery, sortOrder, hideCompleted);
  }

  Future<void> insertTask(Task task) async {
    await _localSource!.insertTask(task);
  }

  Future<void> deleteCompletedTasks() async {
    await _localSource!.deleteAllCompletedTasks();
  }

  Future<void> updateTask(Task task) async {
    await _localSource!.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    await _localSource!.deleteTask(task);
  }

  Future<void> setSortOrder(SortOrder sortOrder) async {
    await _localSource!.setSortOrder(sortOrder);
  }

  Future<void> setHideCompleted(bool value) async {
    await _localSource!.setHideCompleted(value);
  }

  SortOrder getSortOrder() => _localSource!.getSortOrder();

  bool getHideCompleted() => _localSource!.getHideCompleted();
}
