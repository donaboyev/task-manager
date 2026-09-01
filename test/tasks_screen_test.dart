import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todo_clone/controller/tasks_controller.dart';
import 'package:todo_clone/ui/tasks/tasks_screen.dart';

import 'support/fake_tasks_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeTasksRepository repository;

  setUp(() {
    Get.testMode = true;
    repository = FakeTasksRepository(tasks: testTasks);
    Get.put(TasksController(repository));
  });

  tearDown(Get.reset);

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: TasksPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('renders tasks and the important marker', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.text('Call Alice'), findsOneWidget);
    expect(find.byIcon(Icons.notification_important_sharp), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no tasks', (tester) async {
    Get.reset();
    Get.put(TasksController(FakeTasksRepository()));

    await pumpScreen(tester);

    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets('searches and clears the query', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.pumpAndSettle();

    expect(find.text('Call Alice'), findsOneWidget);
    expect(find.text('Buy groceries'), findsNothing);
    expect(find.text('Clear'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.text('Call Alice'), findsOneWidget);
  });

  testWidgets('checks an incomplete task', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(repository.lastUpdatedTask!.name, 'Buy groceries');
    expect(repository.lastUpdatedTask!.completed, isTrue);
  });

  testWidgets('confirms deletion of all completed tasks', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete all completed'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm deletion'), findsOneWidget);
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.text('Call Alice'), findsNothing);
  });
}
