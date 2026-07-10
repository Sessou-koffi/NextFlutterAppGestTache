import 'dart:io';
import 'package:task_cli/exceptions/task_exceptions.dart';
import 'package:task_cli/models/task_models.dart';
import 'package:task_cli/repositories/task_repository.dart';
import 'package:task_cli/services/task_service.dart';

class Logger {
  static void success(String msg) => print('\x1B[32m$msg\x1B[0m');
  static void error(String msg) => print('\x1B[31m$msg\x1B[0m');
  static void info(String msg) => print('\x1B[34m$msg\x1B[0m');
}

void main() {
  final repository = JsonTaskRepository('tasks.json');
  final service = TaskService(repository);

  Logger.info('=== BIENVENUE DANS TASK-CLI ===');

  while (true) {
    print('\nMenu principal :');
    print('1. Ajouter une tâche');
    print('2. Lister toutes les tâches');
    print('3. Marquer une tâche comme terminée');
    print('4. Supprimer une tâche');
    print('5. Quitter');
    stdout.write('Choisissez une option (1-5) : ');

    final choice = stdin.readLineSync();

    try {
      switch (choice) {
        case '1':
          _handleAddTask(service);
          break;
        case '2':
          _handleListTasks(service);
          break;
        case '3':
          _handleCompleteTask(service);
          break;
        case '4':
          _handleDeleteTask(service);
          break;
        case '5':
          Logger.info('Au revoir !');
          exit(0);
        default:
          print('Option invalide.');
      }
    } on TaskException catch (e) {
      Logger.error(e.toString());
    } catch (e) {
      Logger.error('Une erreur imprévue est survenue : $e');
    }
  }
}

void _handleAddTask(TaskService service) {
  stdout.write('Titre de la tâche : ');
  final title = stdin.readLineSync() ?? '';

  stdout.write('Est-ce une tâche urgente ? (o/n) : ');
  final isUrgent = (stdin.readLineSync()?.toLowerCase() == 'o');

  Priority priority = Priority.medium;
  if (!isUrgent) {
    stdout.write('Priorité (1: Faible, 2: Moyenne, 3: Élevée) [2] : ');
    final pChoice = stdin.readLineSync();
    if (pChoice == '1') {
      priority = Priority.low;
    }
    if (pChoice == '3') {
      priority = Priority.high;
    }
  }

  stdout.write('Date limite (AAAA-MM-JJ) ou Entrée : ');
  final dateInput = stdin.readLineSync();
  DateTime? dueDate;
  if (dateInput != null && dateInput.trim().isNotEmpty) {
    dueDate = DateTime.tryParse(dateInput);
    if (dueDate == null) {
      throw InvalidTaskDataException('Format de date incorrect.');
    }
  }

  service.addTask(title, priority, dueDate, isUrgent);
  Logger.success('Tâche ajoutée avec succès !');
}

void _handleListTasks(TaskService service) {
  stdout.write('Tri (1: Aucun, 2: Priorité, 3: Date) : ');
  final sortChoice = stdin.readLineSync();
  String sortBy = 'aucun';
  if (sortChoice == '2') {
    sortBy = 'priorite';
  }
  if (sortChoice == '3') {
    sortBy = 'date';
  }

  final tasks = service.listTasks(sortBy: sortBy);
  if (tasks.isEmpty) {
    print('Aucune tâche enregistrée.');
    return;
  }

  for (final task in tasks) {
    final status = task.isCompleted ? '[X]' : '[ ]';
    final typeStr = task is UrgentTask ? '🔥 URGENT' : 'Standard';
    print(
        '$status ID: ${task.id} | $typeStr | ${task.title} | Priorité : ${task.priority.label}');
  }
}

void _handleCompleteTask(TaskService service) {
  stdout.write('ID de la tâche complétée : ');
  final id = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  service.completeTask(id);
  Logger.success('Tâche marquée comme terminée.');
}

void _handleDeleteTask(TaskService service) {
  stdout.write('ID de la tâche à supprimer : ');
  final id = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  service.deleteTask(id);
  Logger.success('Tâche supprimée.');
}
