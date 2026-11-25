# Site vitrine — Diiwaanu Xassida Yi

Page statique de présentation de l’application, hébergée sur GitHub Pages :

**https://diiwaanu-xassida-yi.com/**

La politique de confidentialité reste à son adresse officielle, inchangée :

**https://fgsfalilou.github.io/khassida-privacy/**

## Contenu

- `index.html` : accueil mobile first. Menu hamburger, titre/CTA visibles dès le premier écran, capture dans un cadre de téléphone, formulaire « Être informé de la sortie », wolof/anglais discrets, rubriques, FAQ et contact.
- `bibliotheque.html` : liste compacte générée depuis `assets/books.json`. Recherche, filtres par langue et index A → Z dans `assets/js/site.js`. Titres nettoyés (underscores remplacés par des espaces) ; les PDF restent sur le R2.
- `rubriques.html` : aperçus réels de l’application, texte de chaque rubrique et liens directs vers les six pages complètes.
- `nafilas.html` : texte des 30 nuits, généré depuis les modèles Dart.
- `nafila-du-jour.html` : les 7 fiches de la semaine en français, wolof et anglais.
- `99-noms.html` : les 99 Noms d’Allah (arabe, latin, sens, dhikr).
- `xam-yoonwi.html` : les 30 chapitres, sommaire en vraie liste, visuel calligraphique à la place du portrait recadré sur les yeux.
- `prieres.html` : 47 villes, 9 événements hijri, Qibla et widget.
- `assets/css/site.css` : feuille unique, vert profond/or, serif élégant, responsive mobile → tablette → ordinateur. Amiri limitée à l’arabe afin que le français utilise une police système qui gère les accents.
- `assets/js/site.js` : menu, formulaire et bibliothèque. Vanilla JS, aucune dépendance, aucun suivi.
- `assets/fonts/AmiriQuran-Regular.ttf` : police locale, réservée aux caractères arabes.
- `assets/screenshots/v2/` : 11 captures 720 × 1560 utilisées dans les cadres de téléphone et les aperçus.

## Mettre à jour

1. Modifier les gabarits ou remplacer les images dans `assets/`.
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

Tant que la fiche n’est pas publiée, `#play-store` affiche **« Bientôt sur Google Play »** et **« Version 1.0 · Android »**. Le bouton n’est pas cliquable.

Après publication, remplacer uniquement le `<span data-play-status>` de `index.html` par :

```html
<a class="btn btn-gold" data-play-status href="https://play.google.com/store/apps/details?id=com.khassida.khassida_app">Télécharger sur Google Play</a>
```

## Règles éditoriales

- Graphie retenue : **khassaïdes** partout, sauf dans le nom propre `Diiwaanu Xassida Yi`.
- Aucune publicité, analytics ou suivi.
- Aucun lien vidéo, aucun lecteur vidéo, aucune mention de site tiers de PDF.
- Aucun nombre figé de khassaïdes dans les textes de présentation.
- Le formulaire ouvre la messagerie de l’utilisateur : aucune adresse n’est stockée ni transmise à un service tiers.
- Coordonnées utilisées : les trois e-mails et les trois numéros WhatsApp officiels.
