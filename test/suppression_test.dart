import 'package:test/test.dart';
import 'package:task_cli/models/task_models.dart';
import 'package:task_cli/services/task_service.dart';
import 'ajout_test.dart';

void main() {
  test('4. Supprimer une tâche la retire de la liste', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Nettoyer la chambre', Priority.low, null, false);
    service.deleteTask(1);
    expect(service.tasks.isEmpty, isTrue);
  });
}
