import 'dart:io';
import '../domain/task_models.dart';
import '../domain/task_service.dart';
import '../domain/task_exceptions.dart';

class CliInterface {
  final TaskService service;
  CliInterface(this.service);

  void start() {
    print('=== BIENVENUE DANS TASK-CLI ===');
    while (true) {
      print('\nMenu principal :');
      print('1. Ajouter une tâche');
      print('2. Lister toutes les tâches');
      print('3. Marquer une tâche comme terminée');
      print('4. Supprimer une tâche');
      print('5. Quitter');
      stdout.write('Choisissez une option (1-5) : ');

      final menuChoice = stdin.readLineSync();
      try {
        switch (menuChoice) {
          case '1': _addTask(); break;
          case '2': _listTasks(); break;
          case '3': _completeTask(); break;
          case '4': _deleteTask(); break;
          case '5': print('Au revoir !'); exit(0);
          default: print('Option invalide.');
        }
      } on TaskException catch (e) {
        print('\x1B[31m$e\x1B[0m');
      }
    }
  }

  void _addTask() {
    stdout.write('Titre de la tâche : ');
    final title = stdin.readLineSync() ?? '';
    stdout.write('Est-ce une tâche urgente ? (o/n) : ');
    final isUrgent = (stdin.readLineSync()?.toLowerCase() == 'o');

    Priority priority = Priority.medium;
    if (!isUrgent) {
      stdout.write('Priorité (1: Faible, 2: Moyenne, 3: Élevée) : ');
      final priorityChoice = stdin.readLineSync();
      if (priorityChoice == '1') priority = Priority.low;
      if (priorityChoice == '3') priority = Priority.high;
    }
    service.addTask(title, priority, null, isUrgent);
  }

  void _listTasks() {
    final tasks = service.listTasks(sortBy: 'aucun');
    for (final task in tasks) {
      print('[${task.isCompleted ? "X" : " "}] ID: ${task.id} | ${task.title}');
    }
  }

  void _completeTask() {
    stdout.write('ID de la tâche complétée : ');
    final id = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    service.completeTask(id);
  }

  void _deleteTask() {
    stdout.write('ID de la tâche à supprimer : ');
    final id = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    service.deleteTask(id);
  }
}
