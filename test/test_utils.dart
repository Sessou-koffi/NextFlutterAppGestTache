import '../lib/models/task_models.dart';
import '../lib/repositories/task_repository.dart';

class MemoryRepository implements Repository<Task> {
  List<Task> data = [];
  @override
  List<Task> loadAll() => data;
  @override
  void saveAll(List<Task> items) { data = List.from(items); }
}
