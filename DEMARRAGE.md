# Démarrage — Site Diiwaanu Xassida Yi

Site statique, sans backend, sans analytics ni publicité. 27 pages, 27 URL dans le sitemap.
Dépôt public : `https://github.com/fgsfalilou/diiwaanu-xassida-yi` · branches `main` et `master`.
Site en ligne : `https://www.diiwaanu-xassida-yi.com/`.

## Reprise sur un autre PC

```powershell
git clone https://github.com/fgsfalilou/diiwaanu-xassida-yi.git
cd diiwaanu-xassida-yi
dart run tools/audit_site.dart
```

Aucune compilation n’est nécessaire. Ouvrez simplement le dossier comme espace de travail dans OpenCode.
Pour un aperçu local : `dart run tools/serve_site.dart`, puis `http://127.0.0.1:8765/`.

Dernier audit connu : **27 pages · 27 URL · 838 entrées de recherche · 0 problème**.

## Règles à respecter

- Polices : `"Times New Roman", Times, serif` partout, sauf la calligraphie arabe `Amiri Site`.
- UTF-8 explicite, textes ≥ 16 px, cibles tactiles ≥ 48 px.
- Orthographe **khassaïdes** en prose ; `Diiwaanu Xassida Yi` inchangé.
- URLs canoniques, OG et sitemap en `https://www.diiwaanu-xassida-yi.com`.
- Cache des assets : `?v=biblio50`. Toute modification CSS/JS doit passer à `biblio50` puis mettre à jour
  `tools/generate_site_pages.dart` (dans le dépôt privé de l’application) et l’audit.
- Formulaires en `mailto:beguefallou@gmail.com`, sans backend ni suivi.
- Aucune donnée d’un autre site (AdSense, GTM, compteurs, réseaux sociaux, IBM Plex) ne doit être reprise.

## Contenu ajouté en novembre 2026

- `index.html` : bloc « À la une » (3 actualités) et « Agenda à venir » (3 repères).
- `agenda.html` : dates 2027 et 2026 du calendrier de l’application, réglage Touba (+1 jour).
- `voie-mouride.html#sous-rubriques` : Khalifes, famille, disciples, exils, Sanoussi, témoignages
  (liens vers les chapitres réels de `xam-yoonwi.html`).
- `audio.html` : playlist unique de 23 MP3, lecture en ligne via R2, aucun `download`.
- `recherche.html` + `assets/js/search-data.js` : 838 entrées générées (pages, livres, audio, conférences et chaînes), recherche 100 % locale.
- `conferences.html` : page dédiée aux conférences de Serigne Moustapha Saliou. Un seul lecteur, 22 pistes compactes, photo éclaircie `assets/conferences/serigne-moustapha-saliou-clair.jpg` en fond et portrait net en haut. `voie-mouride.html#conferences` renvoie désormais vers cette page.
- `conferences-saliou-sow.html` : trente-six conférences de Serigne Saliou Sow, même structure que `conferences.html` (photo dédiée, un seul lecteur, playlist R2 `CONFERENCES_SALIOU_SOW/`, aucun téléchargement).
- `conferences-bousso-seck.html` : quatorze conférences de Serigne Bousso Seck, même structure que `conferences.html` (photo fournie dans le dossier audio, un seul lecteur, playlist R2 `CONFERENCES_BOUSSO_SECK/`, aucun téléchargement).
- `conferences-bassirou-mbacke.html` : cent trente conférences de Serigne Bassirou Mbacke Xelcome, même structure que `conferences.html` (photo fournie dans le dossier audio, un seul lecteur, playlist R2 `CONFERENCES_BASSIROU_MBACKE/`, aucun téléchargement).
- `index.html` : six boutons mourides dans l’ordre « Info mouride », « Xam sa serigne », « Xam sa diine », « Galerie mouride », « Taalif » et « Conférences ». Le bouton « Taalif » ouvre `taalif.html`, avec une calligraphie arabe `تأليف` en filigrane doré. Le bouton « Conférences » ouvre un sous-menu local avec quatre entrées : « Serigne Moustapha Saliou » (`conferences.html`, 22 MP3, préfixe R2 `CONFERENCES/`), « Serigne Saliou Sow » (`conferences-saliou-sow.html`, 36 MP3, préfixe R2 `CONFERENCES_SALIOU_SOW/`) et « Serigne Bousso Seck » (`conferences-bousso-seck.html`, 14 MP3, préfixe R2 `CONFERENCES_BOUSSO_SECK/`) et « Serigne Bassirou Mbacke Xelcome » (`conferences-bassirou-mbacke.html`, 130 MP3, préfixe R2 `CONFERENCES_BASSIROU_MBACKE/`) ; lecteur unique et aucun téléchargement.
- `taalif.html` : texte intégral de `assets/pdf/xarnubi.pdf` extrait du PDF natif (36 feuillets, 1079 vers), mis en page en vert profond et or avec palette visible, saut entre feuillets et lien discret vers le PDF source. Seules les coupures de ligne évidentes et la ponctuation typographique ont été rétablies.
- `index.html#accueil-rubriques` : la bibliothèque des khassaïdes est le bouton principal, suivi des six boutons mourides et de huit raccourcis du menu (arabe, français, wolof, anglais, audio, nafilas, 99 Noms, recherche). Le bloc « En direct » et ses sept aperçus YouTube ont été retirés de l’accueil le 28 novembre 2026 ; ils restent sur `media.html#direct-youtube`. Les trois vidéos de présentation avaient été retirées du site le 27 novembre 2026.
- Vidéos de présentation : sections supprimées de `index.html` et `media.html`, entrées retirées de la recherche et trois MP4 supprimés du préfixe R2 `VIDEOS/`. Aucun lecteur vidéo, aucun iframe, aucun appel tiers.
- `media.html#direct-youtube` : sept chaînes mourides en aperçus cliquables ; miniatures stockées dans `assets/youtube-previews/`, téléchargées une seule fois. Un clic ouvre YouTube dans un nouvel onglet : aucun lecteur intégré, aucun appel à Google au chargement de la page.
- `index.html` : six boutons mourides juste au-dessus de la grille « À la une », le sixième ouvrant le sous-menu des deux conférences.
- `voie-mouride.html#infos-mourides` : quatre sections « Info mouride », « Xam sa serigne », « Xam sa diine » et « Galerie mouride » (portraits ronds cerclés d’or, lightbox sans dépendance).
- `voie-mouride.html#info-mouride` : repères biographiques sur Cheikh Ahmadou Bamba (1853-1927), rédigés à partir de sources ouvertes (Wikipédia, Britannica) et reliés au chapitre 2 de XAM YOONWI ; l’entrée « La Voie Mouride » de `assets/js/search-data.js` a été enrichie des mêmes repères.
- Navigation déployée sur les 27 pages, avec menu, `noscript` et pied de page synchronisés.

## En attente

- **Conférences _23 à _29** : l’utilisateur va déposer les 7 MP3 manquants dans `C:\Users\akman\Downloads` :
  `s._moustapha_saliou_-_23.mp3` … `_29.mp3`. Une fois présents, les uploader dans `CONFERENCES/` avec
  `tools/r2/upload_conferences_to_r2.ps1`, puis régénérer la playlist de `conferences.html`, le sitemap,
  `assets/js/search-data.js` et l’audit (le contrôle attend actuellement 22 pistes).
- **Deux chaînes YouTube supplémentaires** : noms et URLs exacts encore à fournir. Les ajouter comme les 7 aperçus
  existants : miniature locale dans `assets/youtube-previews/`, lien `rel="noopener noreferrer"`, aucun iframe ni appel Google.
- Search Console : soumettre `sitemap.xml` dans **Sitemaps** si ce n’est pas encore fait.
- Ancien token Cloudflare créé pour le domaine : à révoquer si ce n’est déjà fait.

## Régénération des pages partagées

Les deux pages générées depuis l’application sont `nafila-du-jour.html` et `99-noms.html`.
Depuis le dépôt privé `khassida_app` :

```powershell
dart run tools/generate_site_pages.dart
Copy-Item store\site\nafila-du-jour.html <chemin>\diiwaanu-xassida-yi\nafila-du-jour.html -Force
Copy-Item store\site\99-noms.html <chemin>\diiwaanu-xassida-yi\99-noms.html -Force
```

Puis, depuis la racine du site : `dart run tools/audit_site.dart`.

## Outils locaux

- `tools/audit_site.dart` : liens, ancres, doublons, cache, sitemap, playlist, recherche (chemin relatif au dépôt).
- `tools/serve_site.dart` : serveur local sans dépendance (port 8765).
- `tools/build_site_updates.dart`, `tools/build_site_sections.dart`, `tools/build_site_mouride.dart`,
  `tools/build_site_youtube.dart`, `tools/build_site_videos.dart` et `tools/build_site_youtube_previews.dart`, `tools/build_site_home_videos.dart` : scripts historiques des ajouts de novembre 2026 ;
  leurs chemins sont codés en dur pour la machine d’origine et doivent être adaptés avant réutilisation.

## Déploiement et liens

- `git push origin main` et `git push origin master` : propagation GitHub Pages en quelques minutes.
- Lien anti-cache : ajouter `?voir=<date>` à l’URL (ex. `?voir=20261126g`).
- Audio : bucket R2 `khassida-pdf`, domaine `https://pub-f07ad970b3b84dfa8539a6cf6ce3f5b3.r2.dev`, préfixe `AUDIO/`.
- Vidéos : préfixe `VIDEOS/` vidé le 27 novembre 2026 (trois MP4 supprimés) ; aucun upload de vidéo n’est prévu.
- Identité : Mouhamadou Falilou Seye · `beguefallou@gmail.com` · WhatsApp `+1 301 857 8776`.
- Confidentialité : `https://fgsfalilou.github.io/khassida-privacy/`.

## À finaliser hors du dépôt

- Search Console : vérification de propriété et soumission du sitemap.
- Révoquer l’ancien token Cloudflare créé pour `diiwaanu-xassida-yi.com` si ce n’est déjà fait.
