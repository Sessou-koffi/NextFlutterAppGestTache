import 'task_models.dart';
import '../data/task_repository.dart';
import 'task_exceptions.dart';

class TaskService {
  final Repository<Task> _repository;
  List<Task> _tasks = [];
  int _nextId = 1;

  TaskService(this._repository) {
    _tasks = _repository.loadAll();
    if (_tasks.isNotEmpty) {
      _nextId = _tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

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
    _repository.saveAll(_tasks);
  }

  void completeTask(int id) {
    if (id <= 0) throw InvalidTaskDataException('L\'ID doit être un entier positif.');
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) throw TaskNotFoundException(id);

    _tasks[taskIndex].isCompleted = true;
    _repository.saveAll(_tasks);
  }

  void deleteTask(int id) {
    if (id <= 0) throw InvalidTaskDataException('L\'ID doit être un entier positif.');
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) throw TaskNotFoundException(id);

    _tasks.removeAt(taskIndex);
    _repository.saveAll(_tasks);
  }

  List<Task> listTasks({required String sortBy}) {
    final sortedList = List<Task>.from(_tasks);
    if (sortBy == 'priorite') {
      sortedList.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else if (sortBy == 'date') {
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
