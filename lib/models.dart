enum Priority {
  low('Faible'),
  medium('Moyenne'),
  high('Élevée');

  final String label;
  const Priority(this.label); // Constructeur d'enum qui initialise sa valeur label
}

// Implémentation d'une interface pure (abstract interface) pour la sérialisation JSON
abstract interface class Serializable {
  Map<String, dynamic> toJson();
}

// Classe abstraite principale qui implémente notre interface
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

  // Getter abstrait : chaque classe enfant devra définir son type de tâche
  String get taskType;

  // Implémentation de la méthode de l'interface pour convertir une tâche en Map/JSON
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

// Héritage 1 : Classe enfant pour une tâche standard
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

// Héritage 2 : Classe enfant pour une tâche urgente (qui force la priorité haute)
class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.dueDate,
    super.isCompleted,
  }) : super(priority: Priority.high); // Transmet automatiquement la priorité 'high' au parent

  @override
  String get taskType => 'urgent';
}
