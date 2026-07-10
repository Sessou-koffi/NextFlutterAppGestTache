import 'dart:convert';
import 'dart:io';

import '../exceptions/task_exceptions.dart';
import '../models/task_models.dart';

abstract interface class Repository<T> {
  void saveAll(List<T> items);
  List<T> loadAll();
}

class JsonRepository<T extends Serializable> implements Repository<T> {
  final File _file;
  final T Function(Map<String, dynamic>) _fromJson;

  JsonRepository(String filePath, this._fromJson) : _file = File(filePath);

  @override
  void saveAll(List<T> items) {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      _file.writeAsStringSync(jsonEncode(jsonList), flush: true);
    } on IOException catch (e) {
      throw TaskPersistenceException('Impossible d\'écrire le fichier: $e');
    } catch (e) {
      throw TaskPersistenceException('Erreur inattendue à la sauvegarde: $e');
    }
  }

  @override
  List<T> loadAll() {
    if (!_file.existsSync()) return [];

    try {
      final content = _file.readAsStringSync();
      if (content.trim().isEmpty) return [];
      final decoded = jsonDecode(content);
      if (decoded is! List<dynamic>) {
        throw TaskDeserializationException(
          'Le contenu JSON doit être une liste.',
        );
      }

      final jsonList = decoded;
      return List<T>.generate(jsonList.length, (index) {
        final raw = jsonList[index];
        if (raw is! Map<String, dynamic>) {
          throw TaskDeserializationException(
            'Élément $index invalide: objet JSON attendu.',
          );
        }
        return _fromJson(raw);
      });
    } on FormatException catch (e) {
      throw TaskDeserializationException('JSON invalide: ${e.message}');
    } on IOException catch (e) {
      throw TaskPersistenceException('Impossible de lire le fichier: $e');
    } on TaskException {
      rethrow;
    } catch (e) {
      throw TaskPersistenceException('Erreur inattendue au chargement: $e');
    }
  }
}

class JsonTaskRepository extends JsonRepository<Task> {
  JsonTaskRepository(String filePath) : super(filePath, _taskFromJson);

  static Task _taskFromJson(Map<String, dynamic> json) {
    final type = _require<String>(json, 'type');
    final id = _require<int>(json, 'id');
    final title = _require<String>(json, 'title');
    final priorityName = _require<String>(json, 'priority');
    final isCompleted = _require<bool>(json, 'isCompleted');

    final priority = Priority.values
        .where((priority) => priority.name == priorityName)
        .firstOrNull;
    if (priority == null) {
      throw TaskDeserializationException('Priorité inconnue: $priorityName');
    }

    final dueDateStr = json['dueDate'];
    DateTime? dueDate;
    if (dueDateStr != null) {
      if (dueDateStr is! String) {
        throw TaskDeserializationException(
          'Le champ dueDate doit être une chaîne ISO-8601.',
        );
      }
      dueDate = DateTime.tryParse(dueDateStr);
      if (dueDate == null) {
        throw TaskDeserializationException(
          'Date invalide pour dueDate: $dueDateStr',
        );
      }
    }

    if (type == 'urgent') {
      return UrgentTask(
        id: id,
        title: title,
        dueDate: dueDate,
        isCompleted: isCompleted,
      );
    }
    if (type == 'standard') {
      return StandardTask(
        id: id,
        title: title,
        priority: priority,
        dueDate: dueDate,
        isCompleted: isCompleted,
      );
    }

    throw TaskDeserializationException('Type de tâche inconnu: $type');
  }

  static U _require<U>(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! U) {
      throw TaskDeserializationException('Champ "$key" manquant ou invalide.');
    }
    return value;
  }
}
