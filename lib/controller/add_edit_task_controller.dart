import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_clone/data/model/task.dart';
import 'package:todo_clone/data/repository/tasks_repository.dart';

class AddEditTaskController extends GetxController {
  final TasksRepository? _repository;

  AddEditTaskController(this._repository);

  TextEditingController? taskInputController;
  final RxBool _isImportant = false.obs;
  final RxBool _isInputError = false.obs;

  @override
  Future<void> onInit() async {
    taskInputController = TextEditingController();
    super.onInit();
  }

  @override
  Future<void> dispose() async {
    taskInputController!.dispose();
    super.dispose();
  }

  Future<void> setIsImportant(bool value) async {
    _isImportant.value = value;
    update();
  }

  Future<void> setTaskToUpdate(Task task) async {
    _isImportant.value = task.important!;
    taskInputController!.text = task.name!;
    update();
  }

  Future<void> setIsInputError(bool value) async {
    _isInputError.value = value;
  }

  Future<void> insertTask() async {
    await _repository!.insertTask(
      Task(
        name: taskInputController!.text.trim(),
        created: DateTime.now().millisecondsSinceEpoch,
        completed: false,
        important: _isImportant.value,
      ),
    );
  }

  Future<void> updateTask(Task task) async {
    Task newTask = Task(
      id: task.id,
      name: taskInputController!.text.toString().trim(),
      completed: task.completed,
      important: _isImportant.value,
      created: task.created,
    );
    await _repository!.updateTask(newTask);
    update();
  }

  bool get isImportant => _isImportant.value;

  bool get isInputError => _isInputError.value;
}
