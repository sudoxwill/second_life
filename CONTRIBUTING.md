# Git & GitHub — Workflow du projet

## Branches

La branche `master` contient uniquement les versions stables du projet.

Les développements se font sur des branches dédiées :

| Préfixe     | Utilisation             | Exemple                     |
| ----------- | ----------------------- | --------------------------- |
| `feature/`  | Nouvelle fonctionnalité | `feature/pomodoro-timer`    |
| `fix/`      | Correction de bug       | `fix/timer-persistence`     |
| `refactor/` | Refactorisation         | `refactor/auth-repository`  |
| `docs/`     | Documentation           | `docs/readme`               |
| `test/`     | Tests                   | `test/timer-notifier`       |
| `chore/`    | mastertenance             | `chore/update-dependencies` |

Les noms doivent être courts, descriptifs et en anglais.

## Workflow

### 1. Créer une branche

À partir de `develop` :

```bash
git checkout develop
git pull
git checkout -b feature/my-feature
```

### 2. Développer

Faire des commits réguliers et ciblés.

### 3. Convention des commits

Nous utilisons les Conventional Commits :

```text
feat: add pomodoro timer
fix: fix timer persistence
refactor: simplify timer notifier
docs: update README
test: add timer tests
chore: update dependencies
style: format code
```

### 4. Push

```bash
git push -u origin feature/my-feature
```

### 5. Pull Request

Une Pull Request est ensuite créée vers `develop`.

Avant le merge :

* le code doit compiler ;
* les tests doivent passer ;
* les changements doivent être relus ;
* les conversations de la PR doivent être résolues.

### 6. Merge

Après validation, la Pull Request est mergée dans `develop`.

La branche `master` est réservée aux versions stables et ne doit pas recevoir de push direct.

## Règles importantes

* ❌ Ne jamais push directement sur `master`.
* ❌ Ne jamais utiliser `git push --force` sur `master`.
* ❌ Ne pas travailler directement sur `develop`.
* ✅ Une fonctionnalité = une branche.
* ✅ Une Pull Request = une fonctionnalité/correction cohérente.
* ✅ Garder les commits petits et descriptifs.
* ✅ Synchroniser régulièrement sa branche avec `develop`.
