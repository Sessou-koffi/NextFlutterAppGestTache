import 'package:test/test.dart';
import 'package:task_cli/models/task_models.dart';
import 'package:task_cli/services/task_service.dart';

import 'ajout_test.dart';

void main() {
  test('3. Marquer une tâche comme terminée change son statut isCompleted', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Faire du sport', Priority.medium, null, false);
    service.completeTask(1);
    expect(service.tasks.first.isCompleted, isTrue);
  });
}
