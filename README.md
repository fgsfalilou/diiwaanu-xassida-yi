# Site vitrine — Diiwaanu Xassida Yi

Page statique de présentation de l’application, hébergée sur GitHub Pages :

**https://fgsfalilou.github.io/diiwaanu-xassida-yi/**

La politique de confidentialité reste à son adresse officielle, inchangée :

**https://fgsfalilou.github.io/khassida-privacy/**

## Contenu

- `index.html` : page complète, sans dépendance externe ni script.
- `assets/app-icon.png` : icône de l’application.
- `assets/feature-graphic.png` : bandeau 1024 × 500.
- `assets/screenshots/v2/` : les 8 captures 720 × 1560 utilisées sur le Play Store. Elles conservent leurs proportions sur la page et s’ouvrent en taille réelle au clic pour lire le texte.

## Mettre à jour

1. Modifier `index.html` (ou remplacer les images dans `assets/`).
2. Copier le dossier `store/site/` dans un clone du dépôt `diiwaanu-xassida-yi`.
3. `git add . && git commit -m "Mise à jour du site" && git push`.

GitHub Pages publie automatiquement la branche `master`.

## Activer le bouton Google Play

Tant que la fiche n’est pas publiée, le bouton affiche **« Bientôt sur Google Play »** et n’est pas cliquable (l’application est prête mais la validation d’identité du compte Google Play est en attente).

Après publication, remplacer dans `index.html` le bloc :

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
