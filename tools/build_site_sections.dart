// Ajout des rubriques mourides au site Diiwaanu Xassida Yi.
// Script local, sans dépendance : génère les nouvelles pages et met à jour
// la navigation, le pied de page, l'accueil et le cache de toutes les pages.

import 'dart:io';

const String siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const String version = 'biblio29';
const String base = 'https://www.diiwaanu-xassida-yi.com';

class Item {
  final String label;
  final String href;
  final List<Item> children;
  const Item(this.label, this.href, [this.children = const <Item>[]]);
}

const List<Item> navItems = <Item>[
  Item('Accueil', 'index.html'),
  Item('La Voie Mouride', 'voie-mouride.html', <Item>[
    Item('Fondements', 'voie-mouride.html#fondements'),
    Item('La Lumière de Touba', 'voie-mouride.html#lumiere'),
    Item('XAM YOONWI', 'xam-yoonwi.html'),
  ]),
  Item('Livres', 'livres.html', <Item>[
    Item('Bibliothèque', 'bibliotheque.html'),
    Item('Arabe', 'bibliotheque-arabe.html'),
    Item('Français', 'bibliotheque-francais.html'),
    Item('Wolof', 'bibliotheque-wolof.html'),
    Item('Anglais', 'bibliotheque-anglais.html'),
  ]),
  Item('Enseignements', 'enseignements.html', <Item>[
    Item('Nafilas', 'nafilas.html'),
    Item('Nafila du jour', 'nafila-du-jour.html'),
    Item('99 Noms', '99-noms.html'),
  ]),
  Item('Média', 'media.html', <Item>[
    Item('Audio', 'audio.html'),
  ]),
  Item('Guides', 'guides.html', <Item>[
    Item('Prières', 'prieres.html'),
  ]),
  Item('Actualités', 'actualites.html'),
  Item('Contact', 'contact.html'),
  Item('Plan du site', 'rubriques.html'),
];

String currentAttr(String href, String current) =>
    href == current ? ' aria-current="page"' : '';

String flatLinks() {
  final buffer = StringBuffer();
  for (final item in navItems) {
    buffer.writeln('        <a href="${item.href}">${item.label}</a>');
    for (final child in item.children) {
      buffer.writeln('        <a href="${child.href}">${child.label}</a>');
    }
  }
  return buffer.toString().trimRight();
}

String menuLinks(String current) {
  final buffer = StringBuffer();
  for (final item in navItems) {
    final active = currentAttr(item.href, current);
    if (item.children.isEmpty) {
      buffer.writeln('      <li><a href="${item.href}"$active>${item.label}</a></li>');
      continue;
    }
    buffer.writeln('      <li class="menu-group"><a href="${item.href}"$active>${item.label}</a>');
    buffer.writeln('        <ul class="menu-sub">');
    for (final child in item.children) {
      final childActive = currentAttr(child.href, current);
      buffer.writeln('          <li><a href="${child.href}"$childActive>${child.label}</a></li>');
    }
    buffer.writeln('        </ul>');
    buffer.writeln('      </li>');
  }
  return buffer.toString().trimRight();
}

String noscriptBlock() => '''
    <noscript>
      <nav class="noscript-nav" aria-label="Navigation sans JavaScript">
${flatLinks()}
      </nav>
    </noscript>''';

String menuBlock(String current) => '''
<div class="menu-backdrop" data-menu-backdrop aria-hidden="true"></div>
<aside id="site-menu" class="menu-panel" aria-label="Menu du site" aria-hidden="true">
  <div class="menu-panel-head">
    <strong>Diiwaanu Xassida Yi</strong>
    <button class="menu-close" type="button" data-menu-close aria-label="Fermer le menu">×</button>
  </div>
  <nav aria-label="Liens du site">
    <ul>
${menuLinks(current)}
    </ul>
  </nav>
  <p class="menu-note">Application gratuite, sans publicité — audio en ligne.</p>
</aside>''';

const List<String> footerLinks = <String>[
  '<a href="rubriques.html">Plan du site</a>',
  '<a href="voie-mouride.html">La Voie Mouride</a>',
  '<a href="livres.html">Livres</a>',
  '<a href="enseignements.html">Enseignements</a>',
  '<a href="media.html">Média</a>',
  '<a href="guides.html">Guides</a>',
  '<a href="actualites.html">Actualités</a>',
  '<a href="contact.html">Contact</a>',
  '<a href="bibliotheque.html">Bibliothèque</a>',
  '<a href="audio.html">Audio</a>',
  '<a href="prieres.html">Prières</a>',
  '<a href="nafilas.html">Nafilas</a>',
  '<a href="99-noms.html">99 Noms</a>',
  '<a href="xam-yoonwi.html">XAM YOONWI</a>',
];

String footerBlock() => '''
      <div class="foot-links">
        ${footerLinks.join('\n        ')}
      </div>''';

String headBlock(String slug, String title, String description) => '''  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$title</title>
  <meta name="description" content="$description">
  <link rel="canonical" href="$base/$slug">
  <meta property="og:url" content="$base/$slug">
  <meta property="og:type" content="website">
  <meta property="og:title" content="$title">
  <meta property="og:description" content="$description">
  <meta property="og:image" content="$base/assets/app-icon.png">
  <meta name="twitter:card" content="summary">
  <meta name="theme-color" content="#0B1E15">
  <link rel="icon" type="image/png" href="assets/app-icon.png">
  <link rel="stylesheet" href="assets/css/site.css?v=$version">
  <script src="assets/js/site.js?v=$version" defer></script>''';

String footerHtml() => '''
<footer>
  <div class="wrap">
    <div class="foot-grid">
      <div><strong>Diiwaanu Xassida Yi</strong><br>Application Android gratuite, sans publicité — audio en ligne.</div>
${footerBlock()}
    </div>
    <p class="privacy"><a href="https://fgsfalilou.github.io/khassida-privacy/">Politique de confidentialité</a> — aucune donnée personnelle collectée.</p>
    <div class="line">Réalisé par Mouhamadou Falilou Seye. Les traductions et transcriptions restent la propriété de leurs auteurs respectifs ; retrait sur simple demande.</div>
  </div>
</footer>

</body>
</html>
''';

String page({
  required String slug,
  required String title,
  required String description,
  required String eyebrow,
  required String heading,
  required String lead,
  required String body,
}) {
  return '''<!doctype html>
<html lang="fr">
<head>
${headBlock(slug, title, description)}
</head>
<body id="haut">
<a class="skip-link" href="#contenu">Aller au contenu</a>
<header class="site-header">
  <div class="wrap">
    <nav class="site-nav" aria-label="Navigation principale">
      <a class="brand" href="index.html">
        <img src="assets/app-icon.png" alt="Icône de Diiwaanu Xassida Yi">
        <span>Diiwaanu Xassida Yi</span>
      </a>
      <button class="menu-toggle" type="button" data-menu-toggle
              aria-expanded="false" aria-controls="site-menu" aria-label="Ouvrir le menu">
        <span aria-hidden="true">☰</span><span class="menu-label">Menu</span>
      </button>
    </nav>

${noscriptBlock()}

    <div class="hero">
      <p class="eyebrow">$eyebrow</p>
      <h1>$heading</h1>
      <p class="lead">$lead</p>
      <p class="ornament" aria-hidden="true">◆ ◆ ◆</p>
    </div>
  </div>
</header>

${menuBlock(slug)}

<main id="contenu">
  <div class="wrap">
$body
  </div>
</main>
${footerHtml()}''';
}

const String voieMouride = '''
    <section>
      <div class="section-head">
        <span class="kicker">Voie mouride</span>
        <h2>Un savoir transmis par les textes</h2>
        <p>Cette rubrique rassemble les repères déjà présents dans l’application : la vie de Serigne Touba, Touba et le Grand Magal, les Khalifes, les cinq prières et les écrits de la voie mouride. Elle ne remplace ni les ouvrages de référence ni l’enseignement des maîtres : elle sert uniquement de porte d’entrée vers les textes disponibles.</p>
      </div>
      <div class="card-grid">
        <article class="card"><div class="mark" aria-hidden="true">01</div><h3>Serigne Touba</h3><p>La biographie, la famille et les enseignements sont présentés dans les trente chapitres de XAM YOONWI, en texte lisible hors ligne.</p><p><a class="btn btn-gold" href="xam-yoonwi.html">Lire XAM YOONWI →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">02</div><h3>Touba et le Grand Magal</h3><p>Le calendrier mouride affiche les grands repères religieux, avec le réglage « Sénégal / Touba (+1 jour) » pour les événements.</p><p><a class="btn btn-gold" href="prieres.html#calendrier">Voir le calendrier →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">03</div><h3>Les Khalifes</h3><p>Les chapitres consacrés à la succession et aux Khalifes se lisent dans XAM YOONWI, sans compte ni publicité.</p><p><a class="btn btn-gold" href="xam-yoonwi.html">Ouvrir les chapitres →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>Le service et l’adab</h3><p>Les khassaïdes, les nafilas et les invocations forment un parcours de lecture respectueux, à consulter à son rythme.</p><p><a class="btn btn-gold" href="enseignements.html">Voir les enseignements →</a></p></article>
      </div>
    </section>

    <section class="rubrique" id="fondements">
      <div class="shots">
        <figure>
          <a href="assets/screenshots/v2/02_prieres.png" target="_blank" rel="noopener"><img src="assets/screenshots/v2/02_prieres.png" alt="Heures de prière — ouvrir en grand" width="720" height="1560" loading="lazy"></a>
          <figcaption>Les cinq prières</figcaption>
        </figure>
      </div>
      <div class="copy">
        <span class="kicker">Fondements</span>
        <h2>Coran, Sunnah et pratique quotidienne</h2>
        <p>Les fondements sont présentés ici dans leur dimension pratique : les cinq prières, l’intention, la purification, le calendrier religieux et la direction de la Qibla.</p>
        <ul>
          <li>Horaires calculés hors ligne pour une ville choisie manuellement.</li>
          <li>Qibla calculée sans GPS, avec boussole vivante ou repère statique.</li>
          <li>Aucune donnée de position n’est demandée ni enregistrée.</li>
        </ul>
        <div class="links"><a class="btn btn-gold" href="prieres.html">Ouvrir les fondements pratiques →</a></div>
      </div>
    </section>

    <section class="rubrique" id="lumiere">
      <div class="shots">
        <figure>
          <a href="assets/screenshots/v2/09_xam_yoonwi.png" target="_blank" rel="noopener"><img src="assets/screenshots/v2/09_xam_yoonwi.png" alt="XAM YOONWI — ouvrir en grand" width="720" height="1560" loading="lazy"></a>
          <figcaption>XAM YOONWI</figcaption>
        </figure>
      </div>
      <div class="copy">
        <span class="kicker">La Lumière de Touba</span>
        <h2>La vie de Serigne Touba en trente chapitres</h2>
        <p>La Lumière de Touba renvoie aux textes de XAM YOONWI : biographie, chronologie, enseignements, famille, Khalifes et repères du Grand Magal. Les portraits sont présentés dans des cadres ronds cerclés d’or.</p>
        <ul>
          <li>Trente chapitres en texte, consultables sans connexion.</li>
          <li>Lecture confortable, sombre par défaut, avec taille du texte ajustable.</li>
          <li>Aucun contenu inventé : les chapitres sont ceux de l’application.</li>
        </ul>
        <div class="links"><a class="btn btn-gold" href="xam-yoonwi.html">Lire les trente chapitres →</a></div>
      </div>
    </section>

    <section>
      <div class="manifesto">
        <h2>Une porte d’entrée, pas une autorité</h2>
        <p>Les textes présentés ici proviennent de l’application et des ouvrages cités dans ses écrans. Les traductions et transcriptions restent la propriété de leurs auteurs respectifs ; retrait sur simple demande. <a href="contact.html">Écrire pour un signalement →</a></p>
      </div>
    </section>
''';

const String livres = '''
    <section>
      <div class="section-head">
        <span class="kicker">Livres et PDF</span>
        <h2>La bibliothèque des khassaïdes</h2>
        <p>760 khassaïdes répartis en quatre langues, avec recherche, index A → Z et lien direct vers chaque PDF. Aucune création de compte, aucune publicité : les listes sont ouvertes à tous.</p>
      </div>
      <div class="lang-hub">
        <article class="lang-card"><h2>Arabe</h2><p class="lang-count">671 khassaïdes classés par ordre alphabétique</p><a class="btn btn-gold" href="bibliotheque-arabe.html">Ouvrir la liste →</a></article>
        <article class="lang-card"><h2>Français</h2><p class="lang-count">54 khassaïdes classés par ordre alphabétique</p><a class="btn btn-gold" href="bibliotheque-francais.html">Ouvrir la liste →</a></article>
        <article class="lang-card"><h2>Wolof</h2><p class="lang-count">31 khassaïdes classés par ordre alphabétique</p><a class="btn btn-gold" href="bibliotheque-wolof.html">Ouvrir la liste →</a></article>
        <article class="lang-card"><h2>Anglais</h2><p class="lang-count">4 khassaïdes classés par ordre alphabétique</p><a class="btn btn-gold" href="bibliotheque-anglais.html">Ouvrir la liste →</a></article>
      </div>
    </section>

    <section>
      <div class="section-head">
        <span class="kicker">Lecture</span>
        <h2>Comment la bibliothèque fonctionne</h2>
        <p>Chaque langue possède sa page : une recherche, des boutons de lettres de 48 px qui défilent sur téléphone, puis une liste courte pour ne pas perdre sa place.</p>
      </div>
      <div class="card-grid">
        <article class="card"><div class="mark" aria-hidden="true">01</div><h3>Rechercher</h3><p>Tapez un titre : la recherche réinitialise automatiquement la lettre active pour éviter un résultat vide.</p></article>
        <article class="card"><div class="mark" aria-hidden="true">02</div><h3>Parcourir A → Z</h3><p>Cliquer une lettre efface la recherche et affiche uniquement les khassaïdes de cette lettre.</p></article>
        <article class="card"><div class="mark" aria-hidden="true">03</div><h3>Ouvrir le PDF</h3><p>Les fichiers sont hébergés sur le stockage de l’application et s’ouvrent dans un nouvel onglet, avec un libellé explicite.</p><p><a class="btn btn-gold" href="bibliotheque.html">Choisir une langue →</a></p></article>
      </div>
    </section>

    <section>
      <div class="manifesto">
        <h2>Les textes restent la propriété de leurs auteurs</h2>
        <p>La bibliothèque ne revendique aucun droit sur les traductions, transcriptions ou ouvrages numérisés. Pour une correction ou un retrait, utilisez la page <a href="contact.html">Contact</a>.</p>
      </div>
    </section>
''';

const String enseignements = '''
    <section>
      <div class="section-head">
        <span class="kicker">Enseignements</span>
        <h2>Lire, réciter, retenir</h2>
        <p>Les enseignements sont réunis ici par type de lecture : khassaïdes, nafilas du Ramadan, fiche du jour, Noms d’Allah et chapitres de XAM YOONWI.</p>
      </div>
      <div class="card-grid">
        <article class="card"><div class="mark" aria-hidden="true">01</div><h3>Khassaïdes</h3><p>Les textes classés par langue, avec recherche, index alphabétique et PDF accessibles.</p><p><a class="btn btn-gold" href="bibliotheque.html">Ouvrir les livres →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">02</div><h3>Nafilas du Ramadan</h3><p>Les trente nuits en texte seul, avec invocations, répétitions et bienfaits tels qu’ils figurent dans l’application.</p><p><a class="btn btn-gold" href="nafilas.html">Lire les nafilas →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">03</div><h3>Nafila du jour</h3><p>Sept fiches hebdomadaires en français, wolof et anglais. L’écran s’ouvre sur le jour du téléphone.</p><p><a class="btn btn-gold" href="nafila-du-jour.html">Voir la fiche du jour →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>99 Noms d’Allah</h3><p>Chaque Nom est affiché en arabe, en transcription latine et en français, avec son dhikr lorsqu’il figure dans l’application.</p><p><a class="btn btn-gold" href="99-noms.html">Ouvrir les 99 Noms →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">05</div><h3>XAM YOONWI</h3><p>Trente chapitres sur la vie et les enseignements de Serigne Touba, Touba, les Khalifes et sa famille.</p><p><a class="btn btn-gold" href="xam-yoonwi.html">Lire les chapitres →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">06</div><h3>Audio des khassaïdes</h3><p>Vingt-trois enregistrements écoutables en ligne depuis le site, sans compte et sans MP3 enregistré sur l’appareil.</p><p><a class="btn btn-gold" href="audio.html">Écouter en ligne →</a></p></article>
      </div>
    </section>

    <section>
      <div class="manifesto">
        <h2>Un contenu fidèle aux sources</h2>
        <p>Aucune invocation, aucun verset, aucun nom propre et aucun texte arabe n’est modifié pour la présentation. Les corrections typographiques ne portent que sur ce qui est certain. <a href="contact.html">Signaler une erreur →</a></p>
      </div>
    </section>
''';

const String media = '''
    <section>
      <div class="section-head">
        <span class="kicker">Média</span>
        <h2>Audio et images du projet</h2>
        <p>Le média de ce site reste volontairement simple : une page d’écoute en ligne, des captures réelles de l’application et l’icône utilisée sur le site et dans l’application. Aucun lecteur externe, aucune publicité, aucun suivi.</p>
      </div>
      <div class="card-grid">
        <article class="card"><div class="mark" aria-hidden="true">01</div><h3>Audio des khassaïdes</h3><p>Vingt-trois enregistrements diffusés depuis le stockage de l’application. La lecture reste en ligne : aucun fichier n’est enregistré sur le téléphone.</p><p><a class="btn btn-gold" href="audio.html">Ouvrir la page audio →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">02</div><h3>Livres et lecture</h3><p>Les PDF sont consultables depuis la bibliothèque, en ligne ou dans l’application après téléchargement volontaire.</p><p><a class="btn btn-gold" href="livres.html">Ouvrir les livres →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">03</div><h3>Icône du projet</h3><p>La même icône accompagne le site et l’application Android, dans un cadre vert profond et or.</p><p><a class="btn btn-gold" href="assets/app-icon.png" target="_blank" rel="noopener">Voir l’icône →</a></p></article>
      </div>
    </section>

    <section class="shots-section" id="galerie">
      <div class="wrap">
        <div class="section-head">
          <span class="kicker">Galerie</span>
          <h2>L’application en images</h2>
          <p>Six vues prises directement dans l’application. Cliquez sur une capture pour l’ouvrir en grand.</p>
        </div>
        <div class="phone-strip" aria-label="Captures de l’application">
          <figure><a href="assets/screenshots/v2/01_bibliotheque.png" target="_blank" rel="noopener"><span class="phone"><img src="assets/screenshots/v2/01_bibliotheque.png" alt="Bibliothèque des khassaïdes" width="720" height="1560" loading="lazy"></span></a><figcaption>Bibliothèque</figcaption></figure>
          <figure><a href="assets/screenshots/v2/02_prieres.png" target="_blank" rel="noopener"><span class="phone"><img src="assets/screenshots/v2/02_prieres.png" alt="Heures de prière" width="720" height="1560" loading="lazy"></span></a><figcaption>Heures de prière</figcaption></figure>
          <figure><a href="assets/screenshots/v2/06_99_noms.png" target="_blank" rel="noopener"><span class="phone"><img src="assets/screenshots/v2/06_99_noms.png" alt="99 Noms d’Allah" width="720" height="1560" loading="lazy"></span></a><figcaption>99 Noms</figcaption></figure>
          <figure><a href="assets/screenshots/v2/07_nafilas_ramadan.png" target="_blank" rel="noopener"><span class="phone"><img src="assets/screenshots/v2/07_nafilas_ramadan.png" alt="Nafilas du Ramadan" width="720" height="1560" loading="lazy"></span></a><figcaption>Nafilas R</figcaption></figure>
          <figure><a href="assets/screenshots/v2/09_xam_yoonwi.png" target="_blank" rel="noopener"><span class="phone"><img src="assets/screenshots/v2/09_xam_yoonwi.png" alt="XAM YOONWI" width="720" height="1560" loading="lazy"></span></a><figcaption>XAM YOONWI</figcaption></figure>
          <figure><a href="assets/screenshots/v2/11_nafila_du_jour.png" target="_blank" rel="noopener"><span class="phone"><img src="assets/screenshots/v2/11_nafila_du_jour.png" alt="Nafila du jour" width="720" height="1560" loading="lazy"></span></a><figcaption>Nafila du jour</figcaption></figure>
        </div>
        <p class="zoom-hint">Les onze captures sont aussi réunies sur la <a href="rubriques.html">page des aperçus</a>.</p>
      </div>
    </section>
''';

const String guides = '''
    <section>
      <div class="section-head">
        <span class="kicker">Guides pratiques</span>
        <h2>Utiliser le site et l’application</h2>
        <p>Ces guides reprennent le fonctionnement réel du site et de l’application Android. Aucune étape ne demande de compte, de paiement ou d’autorisation de position.</p>
      </div>
      <div class="card-grid">
        <article class="card"><div class="mark" aria-hidden="true">01</div><h3>Choisir une ville pour les prières</h3><p>Dans l’application, ouvrez « Prières » et choisissez la ville dans la liste. Les horaires sont calculés sur le téléphone, sans GPS et sans connexion.</p><p><a class="btn btn-gold" href="prieres.html">Voir la rubrique prières →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">02</div><h3>Lire un khassaïde</h3><p>Choisissez une langue dans « Livres », utilisez la recherche ou une lettre de l’index, puis ouvrez le PDF. Sur téléphone, les boutons de l’index défilent horizontalement.</p><p><a class="btn btn-gold" href="livres.html">Ouvrir les livres →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">03</div><h3>Écouter un enregistrement</h3><p>Ouvrez « Audio » sur le site et lancez un khassaïde. L’écoute se fait en ligne ; aucun MP3 n’est enregistré sur l’appareil.</p><p><a class="btn btn-gold" href="audio.html">Ouvrir l’audio →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>Garder ses PDF hors ligne</h3><p>Dans l’application, « Mes PDF » regroupe les fichiers téléchargés volontairement. Leur lecture ne nécessite pas de réseau et aucun historique n’est envoyé.</p><p><a class="btn btn-gold" href="rubriques.html#mes-pdf">Lire l’aperçu →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">05</div><h3>Comprendre le widget</h3><p>Le widget affiche les cinq prières et la prochaine sur le fond de la Grande Mosquée de Touba. Lecture, pause, arrêt, précédent et suivant restent accessibles, y compris avec les touches du casque ou Bluetooth.</p><p><a class="btn btn-gold" href="prieres.html#widget">Voir le widget →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">06</div><h3>Confidentialité</h3><p>Site et application ne contiennent ni publicité, ni analytics, ni télémétrie. Les préférences restent sur l’appareil. La politique de confidentialité est publique.</p><p><a class="btn btn-gold" href="https://fgsfalilou.github.io/khassida-privacy/" target="_blank" rel="noopener">Lire la politique →</a></p></article>
      </div>
    </section>

    <section>
      <div class="manifesto">
        <h2>Une question qui manque ici ?</h2>
        <p>Consultez les <a href="index.html#faq">questions fréquentes</a> ou <a href="contact.html">écrivez directement</a>. Les retours servent à corriger le site et l’application, pas à alimenter une base de données.</p>
      </div>
    </section>
''';

const String actualites = '''
    <section>
      <div class="section-head">
        <span class="kicker">L’actu</span>
        <h2>Journal du projet</h2>
        <p>Des faits datés et vérifiables : évolutions du site, ajouts de textes et d’audio, corrections de l’application. Aucune annonce n’est publiée avant d’être réelle.</p>
      </div>
      <div class="card-grid">
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Navigation réorganisée</h3><p>La Voie Mouride, Livres, Enseignements, Média, Guides, Actualités et Contact rejoignent le menu principal. Les pages déjà ouvertes restent accessibles depuis le plan du site et les sous-menus.</p><p><a class="btn btn-gold" href="rubriques.html">Voir le plan du site →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Lisibilité et référencement</h3><p>Corrections des tailles de texte, des cibles tactiles, des ancres répétées et des adresses canoniques en www. Le sitemap a été mis à jour.</p><p><a class="btn btn-gold" href="guides.html">Lire les guides →</a></p></article>
        <article class="card"><span class="card-index">Novembre 2026</span><h3>Vingt-trois audio en ligne</h3><p>Les enregistrements de khassaïdes sont hébergés sur le stockage de l’application et écoutables depuis le site. La lecture reste en ligne, sans compte ni enregistrement local.</p><p><a class="btn btn-gold" href="audio.html">Écouter →</a></p></article>
        <article class="card"><span class="card-index">Novembre 2026</span><h3>Application Android 1.0</h3><p>La version 1.0.0+2 a été compilée, signée et installée sur un appareil de test. Les contenus intégrés fonctionnent hors ligne ; la publication sur Google Play attend la validation du compte.</p><p><a class="btn btn-gold" href="index.html#notification">Être informé →</a></p></article>
      </div>
    </section>
''';

const String contact = '''
    <section>
      <div class="section-head">
        <span class="kicker">Contact</span>
        <h2>Écrire, signaler, corriger</h2>
        <p>Pour une question sur le site ou l’application, un signalement de traduction ou une demande liée aux droits, utilisez l’e-mail. WhatsApp est réservé aux questions pratiques et aux avis de sortie.</p>
      </div>
      <div class="contact-grid">
        <div class="panel">
          <h3>E-mails</h3>
          <p>Retours, droits et traductions.</p>
          <ul>
            <li><a href="mailto:beguefallou@gmail.com">beguefallou@gmail.com</a></li>
            <li><a href="mailto:talibeserignefalilou@gmail.com">talibeserignefalilou@gmail.com</a></li>
            <li><a href="mailto:falloubeguefallou@gmail.com">falloubeguefallou@gmail.com</a></li>
          </ul>
        </div>
        <div class="panel">
          <h3>WhatsApp</h3>
          <p>Questions rapides et avis de sortie.</p>
          <ul>
            <li><a href="https://wa.me/13018578776">+1 301 857 8776</a></li>
            <li><a href="https://wa.me/14259543121">+1 425 954 3121</a></li>
            <li><a href="https://wa.me/221770302828">+221 77 030 2828</a></li>
          </ul>
        </div>
        <div class="panel">
          <h3>Confidentialité</h3>
          <p>Aucune donnée personnelle n’est collectée par le site ou l’application. Les formulaires ouvrent uniquement votre messagerie.</p>
          <ul><li><a href="https://fgsfalilou.github.io/khassida-privacy/" target="_blank" rel="noopener">Politique de confidentialité →</a></li></ul>
        </div>
        <div class="panel">
          <h3>Sortie de l’application</h3>
          <p>Pour recevoir une notification par e-mail, utilisez le formulaire de l’accueil. Aucune adresse n’est stockée sur le site.</p>
          <ul><li><a href="index.html#notification">Ouvrir le formulaire →</a></li></ul>
        </div>
      </div>
    </section>

    <section>
      <div class="manifesto">
        <h2>Réalisé par Mouhamadou Falilou Seye</h2>
        <p>But non lucratif — uniquement pour servir Serigne Touba. Les traductions et transcriptions restent la propriété de leurs auteurs respectifs ; retrait sur simple demande.</p>
      </div>
    </section>
''';

void writePage({
  required String file,
  required String title,
  required String description,
  required String eyebrow,
  required String heading,
  required String lead,
  required String body,
}) {
  File('$siteDir/$file').writeAsStringSync(page(
    slug: file,
    title: title,
    description: description,
    eyebrow: eyebrow,
    heading: heading,
    lead: lead,
    body: body,
  ));
  stdout.writeln('Écrit : $file');
}

void main() {
  writePage(
    file: 'voie-mouride.html',
    title: 'La Voie Mouride — Diiwaanu Xassida Yi',
    description: 'Serigne Touba, Touba, les Khalifes, les fondements et la Lumière de Touba : les textes mourides de Diiwaanu Xassida Yi, en accès libre.',
    eyebrow: 'La Voie Mouride',
    heading: 'La voie de Serigne Touba',
    lead: 'Un parcours de lecture fondé sur les textes déjà présents dans l’application : biographie, enseignements, prières et repères mourides.',
    body: voieMouride,
  );
  writePage(
    file: 'livres.html',
    title: 'Livres et PDF de khassaïdes — Diiwaanu Xassida Yi',
    description: '760 khassaïdes en arabe, français, wolof et anglais : recherche, index A → Z et PDF en accès direct, sans compte ni publicité.',
    eyebrow: 'Livres',
    heading: 'Les livres de la bibliothèque',
    lead: 'Quatre langues, 760 khassaïdes, une recherche simple et des PDF accessibles directement depuis le site.',
    body: livres,
  );
  writePage(
    file: 'enseignements.html',
    title: 'Enseignements mourides — Diiwaanu Xassida Yi',
    description: 'Khassaïdes, nafilas, nafila du jour, 99 Noms d’Allah et XAM YOONWI : les enseignements disponibles dans l’application et sur le site.',
    eyebrow: 'Enseignements',
    heading: 'Les enseignements à lire',
    lead: 'Khassaïdes, nafilas, invocations, Noms d’Allah et chapitres de XAM YOONWI, réunis dans un seul parcours de lecture.',
    body: enseignements,
  );
  writePage(
    file: 'media.html',
    title: 'Média — Diiwaanu Xassida Yi',
    description: 'Audio des khassaïdes en ligne, captures réelles de l’application et icône du projet : le média du site Diiwaanu Xassida Yi.',
    eyebrow: 'Média',
    heading: 'Audio et images',
    lead: 'Écoutez les khassaïdes en ligne et parcourez les captures de l’application, sans lecteur externe ni suivi.',
    body: media,
  );
  writePage(
    file: 'guides.html',
    title: 'Guides pratiques — Diiwaanu Xassida Yi',
    description: 'Guides pour choisir une ville, lire un PDF, écouter un khassaïde, utiliser le widget des prières et protéger sa vie privée.',
    eyebrow: 'Guides',
    heading: 'Les guides pratiques',
    lead: 'Étapes courtes et vérifiées pour utiliser le site et l’application Android, sans compte ni position.',
    body: guides,
  );
  writePage(
    file: 'actualites.html',
    title: 'Actualités du projet — Diiwaanu Xassida Yi',
    description: 'Journal daté du site et de l’application Diiwaanu Xassida Yi : rubriques, corrections, audio et version Android 1.0.',
    eyebrow: 'L’actu',
    heading: 'L’actualité du projet',
    lead: 'Les changements réels du site et de l’application, datés et vérifiables.',
    body: actualites,
  );
  writePage(
    file: 'contact.html',
    title: 'Contact — Diiwaanu Xassida Yi',
    description: 'Contactez Mouhamadou Falilou Seye par e-mail ou WhatsApp pour le site et l’application Diiwaanu Xassida Yi.',
    eyebrow: 'Contact',
    heading: 'Écrire au projet',
    lead: 'Retours, corrections de traduction, droits d’auteur ou questions pratiques : choisissez le canal adapté.',
    body: contact,
  );

  final noscript = RegExp(
    r'<noscript>\s*<nav class="noscript-nav".*?</nav>\s*</noscript>',
    dotAll: true,
  );
  final aside = RegExp(r'<aside id="site-menu".*?</aside>', dotAll: true);
  final footLinks = RegExp(r'<div class="foot-links">.*?</div>', dotAll: true);

  final existing = siteDir;
  for (final entity in Directory(existing).listSync()) {
    if (entity is! File || !entity.path.endsWith('.html')) continue;
    final file = File(entity.path);
    var content = file.readAsStringSync();
    final name = file.uri.pathSegments.last;

    content = content.replaceAll(noscript, noscriptBlock());
    content = content.replaceAll(aside, menuBlock(name));
    content = content.replaceAll(footLinks, footerBlock());
    content = content.replaceAll('?v=biblio29', '?v=$version');

    if (name == 'index.html') {
      const startText = '        <article class="card"><div class="mark" aria-hidden="true">01</div><h3>Bibliothèque</h3>';
      const endText = '<p><a class="btn btn-gold-outline" href="audio.html">Écouter les khassaïdes →</a></p></article>';
      final start = content.indexOf(startText);
      final end = content.indexOf(endText, start);
      if (start != -1 && end != -1) {
        const cards = '''
        <article class="card"><div class="mark" aria-hidden="true">01</div><h3>La Voie Mouride</h3><p>Serigne Touba, Touba, Khalifes et fondements, à travers les textes de XAM YOONWI.</p><p><a class="btn btn-gold-outline" href="voie-mouride.html">Découvrir la voie →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">02</div><h3>Livres</h3><p>760 khassaïdes en quatre langues, avec recherche, index A → Z et PDF en accès direct.</p><p><a class="btn btn-gold-outline" href="livres.html">Ouvrir les livres →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">03</div><h3>Enseignements</h3><p>Nafilas, nafila du jour, 99 Noms, dhikr et chapitres de XAM YOONWI.</p><p><a class="btn btn-gold-outline" href="enseignements.html">Lire les enseignements →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>Fondements</h3><p>Cinq prières, intention, purification, calendrier et Qibla sans GPS.</p><p><a class="btn btn-gold-outline" href="voie-mouride.html#fondements">Voir les fondements →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">05</div><h3>La Lumière de Touba</h3><p>La vie de Serigne Touba en trente chapitres, avec portraits et repères du Grand Magal.</p><p><a class="btn btn-gold-outline" href="voie-mouride.html#lumiere">Découvrir Touba →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">06</div><h3>Média</h3><p>Audio en ligne, captures de l’application et icône du projet, sans suivi.</p><p><a class="btn btn-gold-outline" href="media.html">Ouvrir le média →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">07</div><h3>Guides</h3><p>Choisir sa ville, lire un PDF, écouter un audio, utiliser le widget et préserver sa vie privée.</p><p><a class="btn btn-gold-outline" href="guides.html">Lire les guides →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">08</div><h3>Actualités</h3><p>Le journal daté des changements du site et de l’application.</p><p><a class="btn btn-gold-outline" href="actualites.html">Lire l’actu →</a></p></article>
        <article class="card"><div class="mark" aria-hidden="true">09</div><h3>Contact</h3><p>E-mail, WhatsApp, droits d’auteur et politique de confidentialité.</p><p><a class="btn btn-gold-outline" href="contact.html">Contacter →</a></p></article>''';
        content = content.replaceRange(start, end + endText.length, cards);
      }
      content = content.replaceAll(
        '<p class="note-links">Voir aussi <a href="rubriques.html">la page des rubriques et leurs aperçus</a>.</p>',
        '<p class="note-links">Accès directs : <a href="bibliotheque.html">Bibliothèque</a> · <a href="audio.html">Audio</a> · <a href="prieres.html">Prières</a> · <a href="nafilas.html">Nafilas</a> · <a href="99-noms.html">99 Noms</a> · <a href="xam-yoonwi.html">XAM YOONWI</a> · <a href="rubriques.html">Plan du site et aperçus</a>.</p>',
      );
      content = content.replaceAll(
        '<a href="rubriques.html">toutes les rubriques</a>',
        '<a href="rubriques.html">toutes les rubriques</a>',
      );
    }

    if (name == 'rubriques.html') {
      content = content.replaceAll(
        'Rubriques du site — Diiwaanu Xassida Yi',
        'Plan du site — Diiwaanu Xassida Yi',
      );
      content = content.replaceAll(
        '<p class="eyebrow">Les rubriques du site</p>',
        '<p class="eyebrow">Plan du site et aperçus</p>',
      );
      content = content.replaceAll(
        '<h2>Accès direct aux rubriques du site</h2>',
        '<h2>Accès direct aux rubriques</h2>',
      );
    }

    file.writeAsStringSync(content);
    stdout.writeln('Mis à jour : $name');
  }

  // Sitemap : ajout des sept nouvelles URL, toujours en www.
  final sitemapFile = File('$siteDir/sitemap.xml');
  var sitemap = sitemapFile.readAsStringSync();
  const additions = <Map<String, String>>[
    {'loc': 'voie-mouride.html', 'priority': '0.9'},
    {'loc': 'livres.html', 'priority': '0.9'},
    {'loc': 'enseignements.html', 'priority': '0.9'},
    {'loc': 'media.html', 'priority': '0.7'},
    {'loc': 'guides.html', 'priority': '0.8'},
    {'loc': 'actualites.html', 'priority': '0.6'},
    {'loc': 'contact.html', 'priority': '0.7'},
  ];
  final buffer = StringBuffer();
  for (final item in additions) {
    buffer.writeln('''  <url>
    <loc>$base/${item['loc']}</loc>
    <lastmod>2026-11-26</lastmod>
    <changefreq>monthly</changefreq>
    <priority>${item['priority']}</priority>
  </url>''');
  }
  sitemap = sitemap.replaceAll('</urlset>', '${buffer.toString()}</urlset>');
  sitemapFile.writeAsStringSync(sitemap);
  stdout.writeln('Sitemap mis à jour : ${additions.length + 13} URL');
}
