import 'package:test/test.dart';
import 'package:task_cli/models/task_models.dart';
import 'package:task_cli/services/task_service.dart';
import 'ajout_test.dart';

void main() {
  test('5. Le tri par priorité place les éléments High en premier', () {
    final service = TaskService(MemoryRepository());
    service.addTask('Faible', Priority.low, null, false);
    service.addTask('Haute', Priority.high, null, false);
    final result = service.listTasks(sortBy: 'priorite');
    expect(result.first.title, equals('Haute'));
  });
}
