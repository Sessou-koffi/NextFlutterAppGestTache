# Task CLI - Application de Gestion de Tâches en Dart Pure

Application complète en ligne de commande pour gérer vos tâches quotidiennes, construite en Dart natif.

## Architecture du Projet
L'application est découpée de manière modulaire selon les exigences de généricité, d'héritage et de polymorphisme :
- `lib/models/` : Modèles de données (Héritage `UrgentTask` et `StandardTask` étendant `Task`).
- `lib/repositories/` : Patron de conception Repository générique (`Repository<T>`) et persistance locale JSON.
- `lib/services/` : Orchestration de la logique métier, validation et tris complexes.
- `lib/exceptions/` : Définition des exceptions applicatives personnalisées.

## Prérequis
- Dart SDK installé (version >= 3.0.0)

## Lancement de l'application CLI
Exécutez le script principal depuis la racine :
```bash
dart run bin/task_cli.dart
```

## Lancement des 5 scénarios de tests unitaires individuels
Chaque aspect de l'application possède son propre fichier de test à la racine :
```bash
dart test test_ajout.dart
dart test test_urgence.dart
dart test test_completion.dart
dart test test_suppression.dart
dart test test_tri.dart
```

## Intégration Continue (CI/CD)
Un pipeline GitHub Actions est configuré dans `.github/workflows/dart.yml` pour valider automatiquement chaque push.
