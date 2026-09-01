import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_clone/core/constants/app_constants.dart';
import 'package:todo_clone/data/model/task.dart';
import 'package:todo_clone/data/repository/tasks_repository.dart';

class TasksController extends GetxController {
  final TasksRepository? _repository;

  TasksController(this._repository);

  final RxBool _isSearching = false.obs;
  final RxBool _clearButtonEnabled = false.obs;
  TextEditingController? searchController;
  List<Task>? _tasks;
  final RxBool _hideCompleted = false.obs;

  @override
  Future<void> onInit() async {
    searchController = TextEditingController();
    _hideCompleted.value = _repository!.getHideCompleted();
    getTasks();
    super.onInit();
  }

  @override
  Future<void> dispose() async {
    searchController!.dispose();
    super.dispose();
  }

  Future<void> setIsSearching(bool value) async {
    _isSearching.value = value;
    update();
  }

  Future<void> isClearButtonEnabled(bool value) async {
    _clearButtonEnabled.value = value;
    update();
  }

  Future<void> setSortOrder(SortOrder order) async {
    if (order == _repository!.getSortOrder()) return;
    _repository.setSortOrder(order);
    getTasks();
  }

  Future<void> setHideCompleted() async {
    _repository!.setHideCompleted(!_hideCompleted.value);
    _hideCompleted.value = !_hideCompleted.value;
    getTasks();
  }

  Future<void> getTasks() async {
    _tasks = await _repository!.getTasks(
      '%${searchController!.text.toString().trim()}%',
      _repository.getSortOrder(),
      _repository.getHideCompleted(),
    );
    update();
  }

  Future<void> insertTask(Task task) async {
    await _repository!.insertTask(
      Task(
        name: task.name,
        created: DateTime.now().millisecondsSinceEpoch,
        completed: false,
        important: false,
      ),
    );
  }

  Future<void> updateTask(Task task, bool isChecked) async {
    Task newTask = Task(
      id: task.id,
      name: task.name,
      completed: isChecked,
      important: task.important,
      created: task.created,
    );
    await _repository!.updateTask(newTask);
    update();
  }

  Future<void> deleteTask(Task task) async {
    await _repository!.deleteTask(task);
    _tasks!.remove(task);
    update();
  }

  Future<void> deleteCompletedTasks() async {
    await _repository!.deleteCompletedTasks();
    getTasks();
  }

  bool get isSearching => _isSearching.value;

  bool get clearButtonEnabled => _clearButtonEnabled.value;

  RxBool get hideCompleted => _hideCompleted;

  List<Task>? get tasks => _tasks;
}
