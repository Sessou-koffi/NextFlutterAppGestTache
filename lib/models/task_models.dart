enum Priority {
  low('Faible'),
  medium('Moyenne'),
  high('Élevée');

  final String label;
  const Priority(this.label);
}

// Interface pure demandée
abstract interface class Serializable {
  Map<String, dynamic> toJson();
}

// Classe de base abstraite pure
abstract class Task implements Serializable {
  final int id;
  String title;
  Priority priority;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });

  String get taskType;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': taskType,
      'title': title,
      'priority': priority.name,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}

// Classe enfant concrète 1 pour les tâches standards (exigence 2 corrigée)
class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    required super.priority,
    super.dueDate,
    super.isCompleted,
  });

  @override
  String get taskType => 'standard';
}

// Classe enfant concrète 2 pour les tâches urgentes
class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.dueDate,
    super.isCompleted,
  }) : super(priority: Priority.high);

  @override
  String get taskType => 'urgent';
}
