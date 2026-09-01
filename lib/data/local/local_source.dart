import 'package:get_storage/get_storage.dart';
import 'package:todo_clone/core/constants/app_constants.dart';
import 'package:todo_clone/data/local/drift/app_database.dart';
import 'package:todo_clone/data/local/drift/dao/tasks_dao.dart';
import 'package:todo_clone/data/model/task.dart';

class LocalSource {
  final _localStorage = GetStorage();
  final TasksDao _taskDao = AppDatabase.instance.tasksDao;

  LocalSource._();

  static LocalSource? _instance;

  static LocalSource? getInstance() {
    if (_instance != null) {
      return _instance;
    } else {
      return LocalSource._();
    }
  }

  Future<List<Task>> getTasks(
      String? searchQuery, SortOrder sortOrder, bool hideCompleted) {
    return _taskDao.getTasks(searchQuery!, sortOrder, hideCompleted);
  }

  Future<void> insertTask(Task task) async {
    await _taskDao.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _taskDao.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    await _taskDao.deleteTask(task);
  }

  Future<void> deleteAllCompletedTasks() async {
    await _taskDao.deleteCompletedTasks();
  }

  Future<void> setSortOrder(SortOrder sortOrder) async =>
      await _localStorage.write('sort_order', sortOrder.value);

  SortOrder getSortOrder() =>
      (_localStorage.read<String>('sort_order') ?? '') ==
              SortOrder.byDate.value
          ? SortOrder.byDate
          : SortOrder.byName;

  Future<void> setHideCompleted(bool value) async =>
      await _localStorage.write('hide_completed', value);

  bool getHideCompleted() =>
      _localStorage.read<bool>('hide_completed') ?? false;
}
