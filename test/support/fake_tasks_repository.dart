import 'package:todo_clone/core/constants/app_constants.dart';
import 'package:todo_clone/data/model/task.dart';
import 'package:todo_clone/data/repository/tasks_repository.dart';

class FakeTasksRepository extends TasksRepository {
  FakeTasksRepository({
    List<Task> tasks = const [],
    this.currentSortOrder = SortOrder.byName,
    this.completedTasksHidden = false,
  }) : _tasks = List<Task>.of(tasks),
       super();

  final List<Task> _tasks;
  SortOrder currentSortOrder;
  bool completedTasksHidden;

  int getTasksCallCount = 0;
  int setSortOrderCallCount = 0;
  String? lastSearchQuery;
  Task? lastUpdatedTask;
  Task? lastDeletedTask;

  @override
  Future<List<Task>> getTasks(
    String? searchQuery,
    SortOrder sortOrder,
    bool hideCompleted,
  ) async {
    getTasksCallCount++;
    lastSearchQuery = searchQuery;

    final search = (searchQuery ?? '%').replaceAll('%', '').toLowerCase();
    final result = _tasks
        .where((task) => task.name!.toLowerCase().contains(search))
        .where((task) => !hideCompleted || !task.completed!)
        .toList();

    if (sortOrder == SortOrder.byName) {
      result.sort((a, b) => a.name!.compareTo(b.name!));
    } else {
      result.sort((a, b) => b.created!.compareTo(a.created!));
    }
    return result;
  }

  @override
  Future<void> insertTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    lastUpdatedTask = task;
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index != -1) _tasks[index] = task;
  }

  @override
  Future<void> deleteTask(Task task) async {
    lastDeletedTask = task;
    _tasks.removeWhere((item) => item.id == task.id);
  }

  @override
  Future<void> deleteCompletedTasks() async {
    _tasks.removeWhere((task) => task.completed!);
  }

  @override
  Future<void> setSortOrder(SortOrder sortOrder) async {
    setSortOrderCallCount++;
    currentSortOrder = sortOrder;
  }

  @override
  Future<void> setHideCompleted(bool value) async {
    completedTasksHidden = value;
  }

  @override
  SortOrder getSortOrder() => currentSortOrder;

  @override
  bool getHideCompleted() => completedTasksHidden;
}

const testTasks = <Task>[
  Task(
    id: 1,
    name: 'Buy groceries',
    important: false,
    completed: false,
    created: 100,
  ),
  Task(
    id: 2,
    name: 'Call Alice',
    important: true,
    completed: true,
    created: 200,
  ),
];
