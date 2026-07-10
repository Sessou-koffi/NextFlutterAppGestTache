import 'package:test/test.dart';
import '../lib/models/task_models.dart';

import '../lib/services/task_service.dart';
import 'ajout_test.dart';


void main() {
  test('3. Marquer une tâche comme terminée change son statut isCompleted', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Faire du sport', Priority.medium, null, false);
    service.completeTask(1);
    expect(service.tasks.first.isCompleted, isTrue);
  });
}
