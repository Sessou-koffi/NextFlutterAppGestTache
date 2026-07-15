import '../lib/data/task_repository.dart';
import '../lib/domain/task_service.dart';
import '../lib/presentation/cli_interface.dart';

void main() {
  final repository = JsonTaskRepository('tasks.json');
  final service = TaskService(repository);
  final interface = CliInterface(service);
  interface.start();
}
