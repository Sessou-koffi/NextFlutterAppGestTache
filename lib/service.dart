import 'models.dart';
import 'repository.dart';
import 'exceptions.dart';

class TaskService {
  final Repository<Task> _repository;
  List<Task> _tasks = [];
  int _nextId = 1;

  TaskService(this._repository) {
    // Charge les tâches existantes dès l'initialisation du service
    _tasks = _repository.loadAll();
    if (_tasks.isNotEmpty) {
      // Calcule le prochain ID unique basé sur l'ID le plus élevé trouvé
      _nextId = _tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  // Permet de lire les tâches de l'extérieur sans pouvoir modifier la liste directement
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Fonctionnalité obligatoire 1 : Ajouter une tâche (avec ou sans urgence)
  void addTask(String title, Priority priority, DateTime? dueDate, bool isUrgent) {
    if (title.trim().isEmpty) {
      throw InvalidTaskDataException('Le titre de la tâche ne peut pas être vide.');
    }

    Task newTask;
    if (isUrgent) {
      newTask = UrgentTask(id: _nextId++, title: title, dueDate: dueDate);
    } else {
      newTask = StandardTask(id: _nextId++, title: title, priority: priority, dueDate: dueDate);
    }

    _tasks.add(newTask);
    _repository.saveAll(_tasks); // Persiste les données immédiatement
  }

  // Fonctionnalité obligatoire 3 : Marquer une tâche comme terminée
  void completeTask(int id) {
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) throw TaskNotFoundException(id);

    _tasks[taskIndex].isCompleted = true;
    _repository.saveAll(_tasks);
  }

  // Fonctionnalité obligatoire 4 : Supprimer une tâche
  void deleteTask(int id) {
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) throw TaskNotFoundException(id);

    _tasks.removeAt(taskIndex);
    _repository.saveAll(_tasks);
  }

  // Fonctionnalité obligatoire 2 : Lister toutes les tâches avec tri optionnel
  List<Task> listTasks({required String sortBy}) {
    final sortedList = List<Task>.from(_tasks);
    
    if (sortBy == 'priorite') {
      // Tri décroissant : High (index 2) -> Medium (index 1) -> Low (index 0)
      sortedList.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else if (sortBy == 'date') {
      // Tri chronologique : Les dates les plus proches en premier, les tâches sans date à la fin
      sortedList.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    }
    return sortedList;
  }
}
