import 'package:test/test.dart';
import '../lib/models/task_models.dart';
import '../lib/services/task_service.dart';
import 'test_utils.dart';

void main() {
  test('2. Une tâche urgente possède automatiquement une priorité HIGH', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Urgent', Priority.low, null, true);
    expect(service.tasks.first.priority, equals(Priority.high));
  });
}
