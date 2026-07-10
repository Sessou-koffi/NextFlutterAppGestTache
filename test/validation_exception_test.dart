import 'package:test/test.dart';
import '../lib/models/task_models.dart';
import '../lib/services/task_service.dart';
import '../lib/exceptions/task_exceptions.dart';
import 'test_utils.dart';

void main() {
  test('3. Tenter d\'ajouter un titre vide lève une exception InvalidTaskDataException', () {
    final service = TaskService(MemoryRepository());
    expect(() => service.addTask('   ', Priority.medium, null, false), throwsA(isA<InvalidTaskDataException>()));
  });
}
