import 'package:flutter_test/flutter_test.dart';
import 'package:todo_clone/controller/tasks_controller.dart';
import 'package:todo_clone/core/constants/app_constants.dart';

import 'support/fake_tasks_repository.dart';

void main() {
  group('TasksController', () {
    late FakeTasksRepository repository;
    late TasksController controller;

    setUp(() async {
      repository = FakeTasksRepository(tasks: testTasks);
      controller = TasksController(repository);
      await controller.onInit();
    });

    tearDown(() async {
      await controller.dispose();
    });

    test('loads tasks using persisted preferences on initialization', () {
      expect(controller.tasks!.map((task) => task.name), [
        'Buy groceries',
        'Call Alice',
      ]);
      expect(repository.lastSearchQuery, '%%');
      expect(repository.getTasksCallCount, 1);
    });

    test('searches with trimmed text wrapped in SQL wildcards', () async {
      controller.searchController!.text = '  Alice  ';

      await controller.getTasks();

      expect(repository.lastSearchQuery, '%Alice%');
      expect(controller.tasks!.single.name, 'Call Alice');
    });

    test('changes sort order once and refreshes tasks', () async {
      await controller.setSortOrder(SortOrder.byDate);
      await controller.setSortOrder(SortOrder.byDate);

      expect(repository.setSortOrderCallCount, 1);
      expect(controller.tasks!.first.name, 'Call Alice');
    });

    test('updates completion while preserving the other task fields', () async {
      final original = testTasks.first;

      await controller.updateTask(original, true);

      expect(repository.lastUpdatedTask!.id, original.id);
      expect(repository.lastUpdatedTask!.name, original.name);
      expect(repository.lastUpdatedTask!.important, original.important);
      expect(repository.lastUpdatedTask!.created, original.created);
      expect(repository.lastUpdatedTask!.completed, isTrue);
    });

    test(
      'toggles hide-completed preference and refreshes visible tasks',
      () async {
        await controller.setHideCompleted();

        expect(controller.hideCompleted.value, isTrue);
        expect(controller.tasks!.map((task) => task.name), ['Buy groceries']);
      },
    );

    test('deletes completed tasks and refreshes the list', () async {
      await controller.deleteCompletedTasks();

      expect(controller.tasks!.map((task) => task.name), ['Buy groceries']);
    });
  });
}
