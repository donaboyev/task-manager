import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_clone/controller/tasks_controller.dart';
import 'package:todo_clone/data/local/drift/app_database.dart';
import 'package:todo_clone/data/repository/tasks_repository.dart';

class TasksBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    await GetStorage.init();
    await AppDatabase.init();
    await Get.putAsync<TasksController>(() async {
      return TasksController(TasksRepository());
    });
  }
}
