import 'dart:io';
import '../lib/models.dart';
import '../lib/repository.dart';
import '../lib/service.dart';
import '../lib/exceptions.dart';

void main() {
  // Initialisation de la persistance locale dans un fichier local tasks.json
  final repository = JsonTaskRepository('tasks.json');
  final service = TaskService(repository);

  print('=== BIENVENUE DANS TASK-CLI ===');

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
          print('Au revoir !');
          exit(0);
        default:
          print('Option invalide. Veuillez choisir entre 1 et 5.');
      }
    } on TaskException catch (e) {
      // Affiche les messages d'erreurs métiers en rouge dans le terminal
      print('\x1B[31m$e\x1B[0m'); 
    } catch (e) {
      print('Une erreur imprévue est survenue : $e');
    }
  }
}

void _handleAddTask(TaskService service) {
  stdout.write('Titre de la tâche : ');
  final title = stdin.readLineSync() ?? '';

  stdout.write('Est-ce une tâche urgente ? (o/n) : ');
  final urgentInput = stdin.readLineSync()?.toLowerCase();
  final isUrgent = urgentInput == 'o' || urgentInput == 'oui';

  Priority priority = Priority.medium;
  if (!isUrgent) {
    print('Priorité (1: Faible, 2: Moyenne, 3: Élevée) [Par défaut: 2] : ');
    final pChoice = stdin.readLineSync();
    if (pChoice == '1') priority = Priority.low;
    if (pChoice == '3') priority = Priority.high;
  }

  stdout.write('Date limite optionnelle (AAAA-MM-JJ) ou Entrée pour aucune : ');
  final dateInput = stdin.readLineSync();
  DateTime? dueDate;
  if (dateInput != null && dateInput.trim().isNotEmpty) {
    dueDate = DateTime.tryParse(dateInput);
    if (dueDate == null) throw InvalidTaskDataException('Format de date incorrect.');
  }

  service.addTask(title, priority, dueDate, isUrgent);
  print('\x1B[32mTâche ajoutée avec succès !\x1B[0m');
}

void _handleListTasks(TaskService service) {
  stdout.write('Type de tri (1: Aucun, 2: Par priorité, 3: Par date limite) : ');
  final sortChoice = stdin.readLineSync();
  String sortBy = 'aucun';
  if (sortChoice == '2') sortBy = 'priorite';
  if (sortChoice == '3') sortBy = 'date';

  final tasks = service.listTasks(sortBy: sortBy);

  if (tasks.isEmpty) {
    print('Aucune tâche enregistrée.');
    return;
  }

  print('\n--- LISTE DES TÂCHES ---');
  for (final task in tasks) {
    final status = task.isCompleted ? '[X]' : '[ ]';
    final dateStr = task.dueDate != null ? ' (Échéance : ${task.dueDate!.toIso8601String().substring(0, 10)})' : '';
    final typeStr = task is UrgentTask ? '🔥 URGENT' : 'Standard';
    print('$status ID: ${task.id} | $typeStr | ${task.title} | Priorité : ${task.priority.label}$dateStr');
  }
}

void _handleCompleteTask(TaskService service) {
  stdout.write('Entrez l\'ID de la tâche complétée : ');
  final idInput = stdin.readLineSync();
  final id = int.tryParse(idInput ?? '');
  if (id == null) throw InvalidTaskDataException('L\'ID doit être un nombre valide.');

  service.completeTask(id);
  print('\x1B[32mTâche marquée comme terminée.\x1B[0m');
}

void _handleDeleteTask(TaskService service) {
  stdout.write('Entrez l\'ID de la tâche à supprimer : ');
  final idInput = stdin.readLineSync();
  final id = int.tryParse(idInput ?? '');
  if (id == null) throw InvalidTaskDataException('L\'ID doit être un nombre valide.');

  service.deleteTask(id);
  print('\x1B[32mTâche supprimée définitivement.\x1B[0m');
}
