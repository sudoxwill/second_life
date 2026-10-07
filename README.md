# SecondLife

Une application mobile de recyclage rémunéré assisté par IA.

L'usager photographie un déchet, l'application l'identifie et estime sa
valeur en points. Il le dépose ensuite dans un point relais, où un agent
le pèse et valide le dépôt. Les points obtenus s'échangent contre des bons
chez des partenaires.

## Fonctionnalités

**Usager**
- Analyse d'un déchet par photo (catégorie, poids estimé, points)
- Carte des points relais et des lieux de recyclage, itinéraire
- Suivi des dépôts (en attente, traités) et des bons obtenus
- Catalogue de récompenses et échange de points
- Notifications in-app (dépôt validé ou refusé, bon obtenu)

**Agent de point relais**
- Scan du QR code présenté par l'usager
- Pesée, validation ou refus motivé du dépôt
- Suivi du lot en cours et enregistrement de son enlèvement
- Historique des validations

**Commun** : thème clair/sombre, français/anglais, police adaptée à la
dyslexie.

## Démarrer

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

La clé d'API se renseigne dans `lib/core/configs/secrets.dart`, à créer
à partir de `secrets.example.dart`.

## Tests

```bash
flutter test
```

## Documentation

- [Guide de prise en main](ONBOARDING.md) : conventions, design system,
  widgets disponibles
- [Architecture](docs/architecture.md) : découpe en features et en couches
- [Schéma Firestore](docs/firestore.md)
- [Workflow Git](CONTRIBUTING.md)

## Stack

Flutter, Riverpod (avec génération de code), GoRouter, Firebase
(Auth, Firestore), flutter_map (OpenStreetMap), dartz.
