import 'package:test/test.dart';
import 'package:task_cli/models/task_models.dart';
import 'package:task_cli/services/task_service.dart';
import 'ajout_test.dart';

void main() {
  test('2. Une tâche urgente possède automatiquement une priorité HIGH', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Urgent', Priority.low, null, true);
    expect(service.tasks.first.priority, equals(Priority.high));
  });
}
