import 'dart:io';
import 'package:test/test.dart';
import '../lib/models/task_models.dart';
import '../lib/repositories/task_repository.dart';
import '../lib/services/task_service.dart';
import '../lib/exceptions/task_exceptions.dart';

// Éléments de Mock exigés par le rapport de l'IA
class MockRepository implements Repository<Task> {
  List<Task> data = [];
  @override
  List<Task> loadAll() => data;
  @override
  void saveAll(List<Task> items) {
    data = List.from(items);
  }
}

void main() {
  group('Tests Application CLI Tâches', () {
    late TaskService service;
    late MockRepository mockRepo;

    setUp(() {
      mockRepo = MockRepository();
      service = TaskService(mockRepo);
    });

    test('1. L\'ajout d\'une tâche augmente la taille de la liste', () {
      service.addTask('Acheter du pain', Priority.low, null, false);
      expect(service.tasks.length, equals(1));
    });

    test('2. Une tâche urgente possède automatiquement une priorité HIGH', () {
      service.addTask('Urgent', Priority.low, null, true);
      expect(service.tasks.first.priority, equals(Priority.high));
    });

    test('3. Tenter d\'ajouter un titre vide lève une exception', () {
      expect(() => service.addTask('   ', Priority.medium, null, false), throwsA(isA<InvalidTaskDataException>()));
    });

    test('4. Marquer une tâche inexistante lève une exception', () {
      expect(() => service.completeTask(999), throwsA(isA<TaskNotFoundException>()));
    });

    test('5. Test de la persistance JSON réelle sur disque temporaire', () {
      final tempFile = File('tasks_test_temp.json');
      final realRepo = JsonTaskRepository(tempFile.path);
      
      final testTasks = [
        StandardTask(id: 1, title: 'Persistance', priority: Priority.medium)
      ];
      
      realRepo.saveAll(testTasks);
      final loaded = realRepo.loadAll();
      
      expect(loaded.length, equals(1));
      expect(loaded.first.title, equals('Persistance'));
      
      if (tempFile.existsSync()) tempFile.deleteSync();
    });
  });
}
