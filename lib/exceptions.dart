class TaskException implements Exception {
  final String message;
  TaskException(this.message);

  @override
  String toString() => 'Erreur TaskCLI : $message';
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(int id) : super('La tâche avec l\'ID $id n\'existe pas.');
}

class InvalidTaskDataException extends TaskException {
  InvalidTaskDataException(String message) : super('Données invalides : $message');
}
