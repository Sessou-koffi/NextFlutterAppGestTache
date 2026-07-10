//  PAR CECI :
import 'lib/models/task_models.dart';
import 'package:test/test.dart';
import 'lib/services/task_service.dart';
import 'test_ajout.dart';

void main() {
  test('4. Supprimer une tâche la retire de la liste', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Nettoyer la chambre', Priority.low, null, false);
    service.deleteTask(1);
    expect(service.tasks.isEmpty, isTrue);
  });
}
