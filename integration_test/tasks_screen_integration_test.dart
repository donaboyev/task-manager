import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_clone/controller/tasks_controller.dart';
import 'package:todo_clone/ui/tasks/tasks_screen.dart';

import '../test/support/fake_tasks_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.put(TasksController(FakeTasksRepository(tasks: testTasks)));
  });

  tearDown(Get.reset);

  testWidgets('user can find, complete, and hide a task', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: TasksPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'groceries');
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.text('Call Alice'), findsNothing);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hide completed'));
    await tester.pumpAndSettle();

    expect(find.text('No tasks yet'), findsOneWidget);
  });
}
