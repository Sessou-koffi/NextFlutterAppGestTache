import 'package:test/test.dart';
import '../lib/services/task_service.dart';
import '../lib/exceptions/task_exceptions.dart';
import 'test_utils.dart';

void main() {
  test('4. Marquer une tâche inexistante lève une exception TaskNotFoundException', () {
    final service = TaskService(MemoryRepository());
    expect(() => service.completeTask(999), throwsA(isA<TaskNotFoundException>()));
  });
}
