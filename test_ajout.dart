import 'package:test/test.dart';
import 'lib/models/task_models.dart';
import 'lib/services/task_service.dart';
import 'lib/repositories/task_repository.dart';


class MemoryRepository implements Repository<Task> {
  List<Task> data = [];
  @override List<Task> loadAll() => data;
  @override void saveAll(List<Task> items) { data = List.from(items); }
}

void main() {
  test('1. L\'ajout d\'une tâche augmente la taille de la liste', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Acheter du pain', Priority.low, null, false);
    expect(service.tasks.length, equals(1));
  });
}
