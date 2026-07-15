import 'dart:convert';
import 'dart:io';
import '../models/task_models.dart';

abstract interface class Repository<T> {
  void saveAll(List<T> items);
  List<T> loadAll();
}

class JsonTaskRepository implements Repository<Task> {
  final File _file;

  JsonTaskRepository(String filePath) : _file = File(filePath);

  @override
  void saveAll(List<Task> items) {
    final jsonList = items.map((item) => item.toJson()).toList();
    _file.writeAsStringSync(jsonEncode(jsonList), flush: true);
  }

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

        if (type == 'urgent') {
          return UrgentTask(id: id, title: title, dueDate: dueDate, isCompleted: isCompleted);
        } else {
          return StandardTask(id: id, title: title, priority: priority, dueDate: dueDate, isCompleted: isCompleted);
        }
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
