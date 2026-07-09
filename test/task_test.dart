import 'package:test/test.dart';
import '../lib/models.dart';
import '../lib/repository.dart';
import '../lib/service.dart';
import '../lib/exceptions.dart';

// Création d'un "Mock" (Faux dépôt) pour tester en mémoire vive
// Cela évite de lire/écrire sur le disque dur pendant l'exécution des tests
class MemoryRepository implements Repository<Task> {
  List<Task> data = [];
  @override
  List<Task> loadAll() => data;
  @override
  void saveAll(List<Task> items) {
    data = List.from(items);
  }
}

void main() {
  late TaskService service;
  late MemoryRepository mockRepo;

  // Cette fonction s'exécute avant chaque test pour réinitialiser l'environnement
  setUp(() {
    mockRepo = MemoryRepository();
    service = TaskService(mockRepo);
  });

  test('1. L\'ajout d\'une tâche augmente la taille de la liste', () {
    service.addTask('Acheter du pain', Priority.low, null, false);
    expect(service.tasks.length, equals(1));
    expect(service.tasks.first.title, equals('Acheter du pain'));
  });

  test('2. Une tâche urgente possède automatiquement une priorité HIGH', () {
    service.addTask('Rapport D-Clic', Priority.low, null, true); // Urgent force la priorité haute
    expect(service.tasks.first.priority, equals(Priority.high));
  });

  test('3. Tenter d\'ajouter un titre vide lève une exception InvalidTaskDataException', () {
    expect(
      () => service.addTask('   ', Priority.medium, null, false),
      throwsA(isA<InvalidTaskDataException>()),
    );
  });

  test('4. Marquer une tâche inexistante lève une exception TaskNotFoundException', () {
    expect(
      () => service.completeTask(999),
      throwsA(isA<TaskNotFoundException>()),
    );
  });

  test('5. Le tri par priorité place les éléments High en premier', () {
    service.addTask('Tâche Faible', Priority.low, null, false);
    service.addTask('Tâche Haute', Priority.high, null, false);
    service.addTask('Tâche Moyenne', Priority.medium, null, false);

    final result = service.listTasks(sortBy: 'priorite');
    expect(result.first.title, equals('Tâche Haute'));
    expect(result.last.title, equals('Tâche Faible'));
  });
}
