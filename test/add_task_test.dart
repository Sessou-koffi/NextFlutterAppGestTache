import 'package:test/test.dart';
import '../lib/models/task_models.dart';
import '../lib/services/task_service.dart';
import 'test_utils.dart';

void main() {
  test('1. L\'ajout d\'une tâche augmente la taille de la liste', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Acheter du pain', Priority.low, null, false);
    expect(service.tasks.length, equals(1));
  });
}
