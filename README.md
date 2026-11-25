# Site vitrine — Diiwaanu Xassida Yi

Page statique de présentation de l’application, hébergée sur GitHub Pages :

**https://diiwaanu-xassida-yi.com/**

La politique de confidentialité reste à son adresse officielle, inchangée :

**https://fgsfalilou.github.io/khassida-privacy/**

## Contenu

- `index.html` : page complète, sans dépendance externe ni script.
- `bibliotheque.html` : bibliothèque statique des khassaïdes, générée depuis `assets/books.json`. Aucun script ni nombre figé ; les PDF restent hébergés sur le R2 de l’application.
- `rubriques.html` : présentation de toutes les rubriques de l’application, avec captures et liens vers la bibliothèque et les nafilas.
- `nafilas.html` : texte des nuits de nafilas, généré depuis les modèles Dart, en texte seul avec police Amiri et filets dorés.
- `sitemap.xml` et `robots.txt` : fichiers d’aide à l’indexation Google.
- `assets/fonts/AmiriQuran-Regular.ttf` : police serif locale, hébergée sur le site même (aucun service externe).
- `assets/app-icon.png` : icône de l’application.
- `assets/feature-graphic.png` : bandeau 1024 × 500.
- `assets/screenshots/v2/` : 11 captures 720 × 1560 prises dans l’application (8 utilisées sur le Play Store + XAM YOONWI, Qibla et Nafila du jour). Elles conservent leurs proportions et s’ouvrent en taille réelle au clic.

## Mettre à jour

1. Modifier `index.html` / `rubriques.html` (ou remplacer les images dans `assets/`).
2. Si le catalogue a changé, régénérer la bibliothèque depuis la racine du projet Flutter :
   `dart run tools/generate_bibliotheque.dart`
3. Si les textes des nafilas ont changé, régénérer la page dédiée :
   `dart run tools/generate_nafilas.dart`
4. Copier le dossier `store/site/` dans un clone du dépôt `diiwaanu-xassida-yi`.
5. `git add . && git commit -m "Mise à jour du site" && git push`.

GitHub Pages publie automatiquement la branche `master`.

## Activer le bouton Google Play

Tant que la fiche n’est pas publiée, le bouton affiche **« Bientôt sur Google Play »** et n’est pas cliquable (l’application est prête mais la validation d’identité du compte Google Play est en attente).

Après publication, remplacer dans `index.html` **et** `rubriques.html` le bloc :

```html
<span class="btn btn-gold" aria-disabled="true">Bientôt sur Google Play</span>
```

par :

```html
<a class="btn btn-gold" href="https://play.google.com/store/apps/details?id=com.khassida.khassida_app">Disponible sur Google Play</a>
```

Puis supprimer ou raccourcir la note « L’application est terminée et signée… ».

## Règles éditoriales

- Aucune publicité, analytics ou suivi.
- Aucun lien vers une chaîne vidéo, aucun lecteur vidéo.
- Aucune mention de site tiers de PDF.
- Aucun don : le don reste uniquement dans « À propos » dans l’application.
- Aucun nombre figé de khassaïdes.
- Coordonnées utilisées : les trois e-mails et les trois numéros WhatsApp officiels.
