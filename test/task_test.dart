import 'dart:io';
import 'package:test/test.dart';
import '../lib/domain/task_models.dart';
import '../lib/data/task_repository.dart';
import '../lib/domain/task_service.dart';
import '../lib/domain/task_exceptions.dart';

class MockRepository implements Repository<Task> {
  List<Task> data = [];
  @override List<Task> loadAll() => data;
  @override void saveAll(List<Task> items) { data = List.from(items); }
}

void main() {
  group('Suite de tests complets - Task CLI', () {
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

    test('5. La complétion d\'une tâche valide passe son statut à true', () {
      service.addTask('Valider Projet', Priority.high, null, false);
      service.completeTask(1);
      expect(service.tasks.first.isCompleted, isTrue);
    });

    test('6. La suppression d\'une tâche retire l\'élément', () {
      service.addTask('Nettoyage', Priority.low, null, false);
      service.deleteTask(1);
      expect(service.tasks.isEmpty, isTrue);
    });

    test('7. Test de la persistance JSON réelle', () {
      final file = File('test_persistance.json');
      final repo = JsonTaskRepository(file.path);
      final tasks = [StandardTask(id: 1, title: 'Persist', priority: Priority.low)];
      repo.saveAll(tasks);
      final loaded = repo.loadAll();
      expect(loaded.length, equals(1));
      if (file.existsSync()) file.deleteSync();
    });
  });
}
  