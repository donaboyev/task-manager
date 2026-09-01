import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:todo_clone/base/base_functions.dart';
import 'package:todo_clone/controller/add_edit_task_controller.dart';
import 'package:todo_clone/controller/tasks_controller.dart';
import 'package:todo_clone/core/custom_widgets/custom_text_field.dart';
import 'package:todo_clone/core/theme/app_colors.dart';
import 'package:todo_clone/core/theme/app_text_styles.dart';
import 'package:todo_clone/data/local/floor/entity/task.dart';

class AddEditTaskPage extends GetView<AddEditTaskController> {
  final FocusNode _inputFocus = FocusNode();

  AddEditTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = Get.arguments as Task?;
    if (task != null) controller.setTaskToUpdate(task);
    return KeyboardDismisser(
      child: GetBuilder<AddEditTaskController>(
        builder: (addEditController) => Scaffold(
          backgroundColor: clrWhite,
          appBar: AppBar(
            backgroundColor: clrWhite,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: clrAccent),
              onPressed: () => Get.back(),
            ),
            title: Text(
              task != null ? 'Update task' : 'New task',
              style: styActionAppbar,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Obx(
                  () => CustomTextField(
                    autoFocus: true,
                    context: context,
                    inputAction: TextInputAction.done,
                    controller: addEditController.taskInputController,
                    currentFocus: _inputFocus,
                    keyboardType: TextInputType.text,
                    labelText: 'Input task',
                    hintText: 'Enter...',
                    showError: addEditController.isInputError,
                    errorText: 'You must input task name!',
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        addEditController.setIsInputError(false);
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Important task: ', style: styImportantNotes),
                    const SizedBox(width: 8),
                    Obx(
                      () => Checkbox(
                        value: addEditController.isImportant,
                        onChanged: (value) =>
                            addEditController.setIsImportant(value ?? false),
                        activeColor: clrAccent,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  child: Text(
                    'Created: ${BaseFunctions.getCreatedDate(task?.created ?? 0)}',
                    style: styImportantNotes,
                  ),
                  visible: task != null,
                ),
              ],
            ),
          ),
          floatingActionButton: GetBuilder<TasksController>(
            builder: (tasksController) => FloatingActionButton(
              backgroundColor: clrAccent,
              elevation: 0,
              highlightElevation: 0,
              child: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                if (addEditController.taskInputController!.text
                    .trim()
                    .isEmpty) {
                  addEditController.setIsInputError(true);
                  return;
                }
                task != null
                    ? addEditController.updateTask(task)
                    : addEditController.insertTask();
                Get.back();
                tasksController.getTasks();
              },
            ),
          ),
        ),
      ),
    );
  }
}
