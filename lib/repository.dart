import 'dart:convert';
import 'dart:io';
import 'models.dart';

// Utilisation d'une interface générique <T>
abstract interface class Repository<T> {
  void saveAll(List<T> items);
  List<T> loadAll();
}

// Implémentation concrète de l'interface générique spécialisée pour le type 'Task'
class JsonTaskRepository implements Repository<Task> {
  final File _file;

  JsonTaskRepository(String filePath) : _file = File(filePath);

  // Sauvegarde la liste complète dans le fichier JSON
  @override
  void saveAll(List<Task> items) {
    final jsonList = items.map((item) => item.toJson()).toList();
    _file.writeAsStringSync(jsonEncode(jsonList), flush: true);
  }

  // Charge les données du fichier JSON et reconstruit les bons objets (Standard ou Urgent)
  @override
  List<Task> loadAll() {
    if (!_file.existsSync()) return [];
    try {
      final content = _file.readAsStringSync();
      if (content.trim().isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(content);

      return jsonList.map((json) {
        final type = json['type'] as String;
        final id = json['id'] as int;
        final title = json['title'] as String;
        final priority = Priority.values.byName(json['priority'] as String);
        final dueDateStr = json['dueDate'] as String?;
        final dueDate = dueDateStr != null ? DateTime.parse(dueDateStr) : null;
        final isCompleted = json['isCompleted'] as bool;

        // Recréation polymorphe selon le type enregistré
        if (type == 'urgent') {
          return UrgentTask(id: id, title: title, dueDate: dueDate, isCompleted: isCompleted);
        } else {
          return StandardTask(id: id, title: title, priority: priority, dueDate: dueDate, isCompleted: isCompleted);
        }
      }).toList();
    } catch (e) {
      return []; // Retourne une liste vide sécurisée si le fichier JSON est corrompu
    }
  }
}
