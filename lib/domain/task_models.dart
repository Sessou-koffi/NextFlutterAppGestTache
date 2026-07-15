enum Priority {
  low('Faible'),
  medium('Moyenne'),
  high('Élevée');

  final String label;
  const Priority(this.label);
}

abstract interface class Serializable {
  Map<String, dynamic> toJson();
}

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

class UrgentTask extends Task {
  // Ajout d'une propriété unique exigée par l'IA pour légitimer l'héritage d'UrgentTask
  final DateTime restrictionDate;

  UrgentTask({
    required super.id,
    required super.title,
    super.dueDate,
    super.isCompleted,
  })  : restrictionDate = DateTime.now(),
        super(priority: Priority.high);

  @override
  String get taskType => 'urgent';

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['restrictionDate'] = restrictionDate.toIso8601String();
    return json;
  }
}
