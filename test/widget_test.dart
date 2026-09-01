import 'package:flutter_test/flutter_test.dart';
import 'package:todo_clone/core/constants/app_constants.dart';

void main() {
  test('SortOrder exposes its persisted enum name', () {
    expect(SortOrder.byName.value, 'byName');
    expect(SortOrder.byDate.value, 'byDate');
  });
}
