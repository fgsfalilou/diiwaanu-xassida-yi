# Site vitrine — Diiwaanu Xassida Yi

Page statique de présentation de l’application, hébergée sur GitHub Pages :

**https://diiwaanu-xassida-yi.com/**

La politique de confidentialité reste à son adresse officielle, inchangée :

**https://fgsfalilou.github.io/khassida-privacy/**

## Contenu

- `index.html` : page complète, sans dépendance externe ni script. Navigation réduite à cinq entrées, accroche wolof/anglais, FAQ native (`<details>`) et galerie légendée/numérotée.
- `bibliotheque.html` : bibliothèque statique des khassaïdes, générée depuis `assets/books.json`. Aucun script ni nombre figé ; les PDF restent hébergés sur le R2 de l’application.
- `rubriques.html` : **texte** et liens vers toutes les rubriques — aucune capture d’écran n’y est utilisée comme contenu.
- `nafilas.html` : texte des 30 nuits de nafilas, généré depuis les modèles Dart, en texte seul avec police Amiri et filets dorés.
- `nafila-du-jour.html` : les 7 fiches de la semaine en français, wolof et anglais, générées depuis `nafila_du_jour.dart`.
- `99-noms.html` : les 99 Noms d’Allah (arabe, latin, sens, dhikr), générés depuis `assets/divine_names.json`.
- `xam-yoonwi.html` : les 30 chapitres en texte et portraits recadrés, générés depuis `xam_yoonwi_entry.dart`.
- `prieres.html` : 47 villes, 9 événements hijri, Qibla et widget, générés depuis les sources Dart de l’application.
- `sitemap.xml` et `robots.txt` : fichiers d’aide à l’indexation Google.
- `assets/fonts/AmiriQuran-Regular.ttf` : police serif locale, hébergée sur le site même (aucun service externe).
- `assets/app-icon.png` : icône de l’application.
- `assets/serigne_touba.png` : portrait encadré d’or affiché dans chaque carte de la bibliothèque (identique à `BookPortrait` dans l’application).
- `assets/feature-graphic.png` : bandeau 1024 × 500.
- `assets/screenshots/v2/` : 11 captures 720 × 1560 réservées à la galerie **Aperçus** de l’accueil. Elles ne servent jamais de contenu dans `rubriques.html`.

## Mettre à jour

1. Modifier les gabarits (ou remplacer les images de la galerie dans `assets/`).
2. Régénérer depuis la racine du projet Flutter :
   - `dart run tools/generate_bibliotheque.dart`
   - `dart run tools/generate_nafilas.dart`
   - `dart run tools/generate_xam_yoonwi.dart`
   - `dart run tools/generate_site_pages.dart`
   - `dart run tools/generate_prieres.dart`
   - `dart run tools/generate_rubriques.dart`
3. Copier le dossier `store/site/` dans un clone du dépôt `diiwaanu-xassida-yi`.
4. `git add . && git commit -m "Mise à jour du site" && git push`.

GitHub Pages publie automatiquement la branche `master`.

## Activer le bouton Google Play

Tant que la fiche n’est pas publiée, le bloc `#play-store` affiche **« Bientôt sur Google Play »** et la mention **« Version 1.0 · Android »**. Le bouton n’est pas cliquable (validation du compte Google Play en attente).

Après publication, remplacer **uniquement** le `<span data-play-status>` dans `index.html` :

```html
<span class="btn btn-gold" data-play-status aria-disabled="true">Bientôt sur Google Play</span>
```

par :

```html
<a class="btn btn-gold" data-play-status href="https://play.google.com/store/apps/details?id=com.khassida.khassida_app">Télécharger sur Google Play</a>
```

La mention `<span class="play-version" data-play-version>Version 1.0 · Android</span>` reste inchangée. Raccourcir alors la note « L’application est prête et signée… ».

## Règles éditoriales

- Aucune publicité, analytics ou suivi.
- Aucun lien vers une chaîne vidéo, aucun lecteur vidéo.
- Aucune mention de site tiers de PDF.
- Aucun don : le don reste uniquement dans « À propos » dans l’application.
- Aucun nombre figé de khassaïdes.
- Coordonnées utilisées : les trois e-mails et les trois numéros WhatsApp officiels.
