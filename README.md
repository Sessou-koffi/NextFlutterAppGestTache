# Task CLI - Gestion de Taches en Dart

Application console (Dart pur) pour gerer des taches avec priorites, dates limites, statut de completion, tri et persistance JSON.

## Fonctionnalites
- Ajout de taches standards et urgentes.
- Completion et suppression par identifiant.
- Tri par priorite ou par date limite.
- Sauvegarde et chargement automatique dans `tasks.json`.
- Gestion d'erreurs via exceptions metier personnalisees.

## Architecture
Le code est organise par responsabilite:

- `bin/` : point d'entree CLI.
- `lib/models/` : modeles (`Task`, `StandardTask`, `UrgentTask`) et interface `Serializable`.
- `lib/repositories/` : contrat `Repository<T>`, implementation JSON generique `JsonRepository<T>`, adaptation `JsonTaskRepository`.
- `lib/services/` : logique metier (`TaskService`).
- `lib/exceptions/` : exceptions metier (`TaskException`, `TaskNotFoundException`, etc.).
- `test/` : tests unitaires (ajout, urgence, completion, suppression, tri, exigences).
- `.github/workflows/` : pipeline CI GitHub Actions.

## Prerequis
- Dart SDK `>=3.0.0 <4.0.0`

Verifier votre installation:

```bash
dart --version
```

## Installation

Depuis la racine du projet:

```bash
dart pub get
```

## Lancer l'application

```bash
dart run bin/task_cli.dart
```

## Lancer les tests

Tous les tests:

```bash
dart test
```

Un fichier de test specifique:

```bash
dart test test/ajout_test.dart
```

## Verification qualite locale

Analyse statique:

```bash
dart analyze
```

Verification formatage:

```bash
dart format --output=none --set-exit-if-changed .
```

## CI/CD

Le workflow GitHub Actions dans `.github/workflows/dart.yml` execute automatiquement sur `push` et `pull_request`:

- installation des dependances,
- verification du formatage,
- analyse statique,
- execution de tous les tests.

## Exemples rapides d'utilisation

1. Ajouter une tache urgente (priorite haute automatique).
2. Lister les taches avec tri par priorite.
3. Completer une tache via son ID.
4. Supprimer une tache via son ID.
