import 'dart:io';

import 'package:test/test.dart';
import 'package:task_cli/exceptions/task_exceptions.dart';
import 'package:task_cli/models/task_models.dart';
import 'package:task_cli/repositories/task_repository.dart';
import 'package:task_cli/services/task_service.dart';
import 'ajout_test.dart';

void main() {
  group('Exigences projet', () {
    test('Le service lance InvalidTaskDataException si le titre est vide', () {
      final service = TaskService(MemoryRepository());

      expect(
        () => service.addTask('   ', Priority.low, null, false),
        throwsA(isA<InvalidTaskDataException>()),
      );
    });

    test('Le service lance TaskNotFoundException si ID inexistant', () {
      final service = TaskService(MemoryRepository());

      expect(
        () => service.completeTask(99),
        throwsA(isA<TaskNotFoundException>()),
      );
    });

    test('JsonTaskRepository persiste et recharge les taches', () {
      final tempDir = Directory.systemTemp.createTempSync('task_cli_test_');
      final filePath = '${tempDir.path}/tasks.json';

      try {
        final repository = JsonTaskRepository(filePath);
        final tasks = <Task>[
          StandardTask(id: 1, title: 'A', priority: Priority.low),
          UrgentTask(id: 2, title: 'B'),
        ];

        repository.saveAll(tasks);
        final loaded = repository.loadAll();

        expect(loaded.length, equals(2));
        expect(loaded[1], isA<UrgentTask>());
        expect(loaded[1].priority, equals(Priority.high));
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });

    test(
        'JsonTaskRepository lance TaskDeserializationException sur JSON invalide',
        () {
      final tempDir = Directory.systemTemp.createTempSync('task_cli_test_');
      final filePath = '${tempDir.path}/tasks.json';

      try {
        final file = File(filePath)..writeAsStringSync('{not-valid-json');
        expect(file.existsSync(), isTrue);

        final repository = JsonTaskRepository(filePath);

        expect(
          repository.loadAll,
          throwsA(isA<TaskDeserializationException>()),
        );
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });
  });
}
