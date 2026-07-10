# Task CLI - Application de Gestion de Tâches en Dart Pure

Application robuste en ligne de commande pour gérer vos tâches quotidiennes, construite en Dart natif.

## Architecture du Projet
L'application respecte les principes de la programmation orientée objet (POO) avec découpage en couches :
- `lib/models/` : Contient les modèles de données (Héritage `UrgentTask` / `StandardTask` depuis `Task`).
- `lib/repositories/` : Gère le patron de conception Repository générique et la persistance locale JSON.
- `lib/services/` : Orchestre la logique métier et le traitement des tris.
- `lib/exceptions/` : Définit les exceptions applicatives personnalisées.

## Prérequis
- Dart SDK installé (version >= 3.0.0)

## Lancement de l'application
Exécutez la commande suivante à la racine :
```bash
dart run bin/next_flutter_app_gest_tache.dart
```

## Lancement des tests unitaires
Pour exécuter les 5 scénarios de tests unitaires automatisés :
```bash
dart test
```
