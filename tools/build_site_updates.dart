// Ajouts à la demande : à la une, agenda, sous-rubriques mourides,
// playlist audio et recherche globale statique. Aucune dépendance externe.

import 'dart:convert';
import 'dart:io';

const String siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const String generatorDir = r'C:\Users\akman\Documents\khassida_app';
const String version = 'biblio29';
const String base = 'https://www.diiwaanu-xassida-yi.com';

final HtmlEscape _esc = HtmlEscape();
String h(String value) => _esc.convert(value);

class NavItem {
  final String label;
  final String href;
  final List<NavItem> children;
  const NavItem(this.label, this.href, [this.children = const <NavItem>[]]);
}

const List<NavItem> navItems = <NavItem>[
  NavItem('Accueil', 'index.html'),
  NavItem('La Voie Mouride', 'voie-mouride.html', <NavItem>[
    NavItem('Fondements', 'voie-mouride.html#fondements'),
    NavItem('La Lumière de Touba', 'voie-mouride.html#lumiere'),
    NavItem('Sous-rubriques mourides', 'voie-mouride.html#sous-rubriques'),
    NavItem('XAM YOONWI', 'xam-yoonwi.html'),
  ]),
  NavItem('Livres', 'livres.html', <NavItem>[
    NavItem('Bibliothèque', 'bibliotheque.html'),
    NavItem('Arabe', 'bibliotheque-arabe.html'),
    NavItem('Français', 'bibliotheque-francais.html'),
    NavItem('Wolof', 'bibliotheque-wolof.html'),
    NavItem('Anglais', 'bibliotheque-anglais.html'),
  ]),
  NavItem('Enseignements', 'enseignements.html', <NavItem>[
    NavItem('Nafilas', 'nafilas.html'),
    NavItem('Nafila du jour', 'nafila-du-jour.html'),
    NavItem('99 Noms', '99-noms.html'),
  ]),
  NavItem('Média', 'media.html', <NavItem>[
    NavItem('Audio', 'audio.html'),
  ]),
  NavItem('Guides', 'guides.html', <NavItem>[
    NavItem('Prières', 'prieres.html'),
  ]),
  NavItem('Actualités', 'actualites.html', <NavItem>[
    NavItem('Journal du projet', 'actualites.html'),
    NavItem('Agenda mouride', 'agenda.html'),
  ]),
  NavItem('Contact', 'contact.html'),
  NavItem('Plan du site', 'rubriques.html', <NavItem>[
    NavItem('Recherche globale', 'recherche.html'),
  ]),
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

String asideBlock(String current) => '''
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
  '<a href="recherche.html">Recherche globale</a>',
  '<a href="voie-mouride.html">La Voie Mouride</a>',
  '<a href="livres.html">Livres</a>',
  '<a href="enseignements.html">Enseignements</a>',
  '<a href="media.html">Média</a>',
  '<a href="guides.html">Guides</a>',
  '<a href="actualites.html">Actualités</a>',
  '<a href="agenda.html">Agenda</a>',
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

String pageShell({
  required String slug,
  required String title,
  required String description,
  required String eyebrow,
  required String heading,
  required String lead,
  required String body,
  String extraHead = '',
}) {
  final scripts = extraHead.trim().isEmpty
      ? '  <script src="assets/js/site.js?v=$version" defer></script>'
      : '  $extraHead\n  <script src="assets/js/site.js?v=$version" defer></script>';
  return '''<!doctype html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${h(title)}</title>
  <meta name="description" content="${h(description)}">
  <link rel="canonical" href="$base/$slug">
  <meta property="og:url" content="$base/$slug">
  <meta property="og:type" content="website">
  <meta property="og:title" content="${h(title)}">
  <meta property="og:description" content="${h(description)}">
  <meta property="og:image" content="$base/assets/app-icon.png">
  <meta name="twitter:card" content="summary">
  <meta name="theme-color" content="#0B1E15">
  <link rel="icon" type="image/png" href="assets/app-icon.png">
  <link rel="stylesheet" href="assets/css/site.css?v=$version">
$scripts
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
      <p class="eyebrow">${h(eyebrow)}</p>
      <h1>$heading</h1>
      <p class="lead">${h(lead)}</p>
      <p class="ornament" aria-hidden="true">◆ ◆ ◆</p>
    </div>
  </div>
</header>

<div class="menu-backdrop" data-menu-backdrop aria-hidden="true"></div>
${asideBlock(slug)}

<main id="contenu">
  <div class="wrap">
$body
  </div>
</main>
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
}

List<File> htmlFiles() {
  return Directory(siteDir)
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.html'))
      .toList()
    ..sort((a, b) => a.uri.pathSegments.last.compareTo(b.uri.pathSegments.last));
}

void writeFile(String name, String content) {
  File('$siteDir/$name').writeAsStringSync(content, flush: true);
  stdout.writeln('Écrit : $name');
}

void updateShells() {
  for (final file in htmlFiles()) {
    final name = file.uri.pathSegments.last;
    var html = file.readAsStringSync();
    final before = html;

    html = html.replaceAll(RegExp(r'\?v=biblio\d+'), '?v=$version');
    html = html.replaceAll(
      RegExp(r'    <noscript>\s*<nav class="noscript-nav"[^>]*>.*?</nav>\s*</noscript>',
          dotAll: true),
      noscriptBlock(),
    );
    html = html.replaceAll(
      RegExp(r'<aside id="site-menu".*?</aside>', dotAll: true),
      asideBlock(name),
    );
    html = html.replaceAll(
      RegExp(r'<div class="foot-links">.*?</div>', dotAll: true),
      footerBlock(),
    );

    if (html != before) {
      file.writeAsStringSync(html, flush: true);
      stdout.writeln('Coque mise à jour : $name');
    }
  }
}

const String actualitesBody = '''
    <section>
      <div class="section-head">
        <span class="kicker">L’actu</span>
        <h2>Journal du projet</h2>
        <p>Des faits datés et vérifiables : évolutions du site, ajouts de textes et d’audio, corrections de l’application. Aucune annonce n’est publiée avant d’être réelle.</p>
      </div>
      <div class="card-grid">
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Agenda mouride</h3><p>Les dates calculées dans l’application sont réunies dans une page datée : Ramadan, Aïd, Achoura, Mawlid et Grand Magal de Touba.</p><p><a class="btn btn-gold" href="agenda.html">Ouvrir l’agenda →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Recherche globale</h3><p>Un seul champ interroge un index publié avec le site : pages, khassaïdes et enregistrements audio. Aucune frappe n’est envoyée à un serveur.</p><p><a class="btn btn-gold" href="recherche.html">Chercher →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Playlist audio</h3><p>Les vingt-trois enregistrements se lancent depuis une liste unique, avec lecture, pause, précédent et suivant. L’écoute reste en ligne.</p><p><a class="btn btn-gold" href="audio.html">Écouter →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Sous-rubriques mourides</h3><p>Khalifes, famille, grands disciples, exils et Sanoussi sont désormais signalés dans La Voie Mouride, à partir des chapitres de XAM YOONWI.</p><p><a class="btn btn-gold" href="voie-mouride.html#sous-rubriques">Voir les sous-rubriques →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Navigation réorganisée</h3><p>La Voie Mouride, Livres, Enseignements, Média, Guides, Actualités et Contact rejoignent le menu principal. Les pages déjà ouvertes restent accessibles depuis le plan du site et les sous-menus.</p><p><a class="btn btn-gold" href="rubriques.html">Voir le plan du site →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Lisibilité et référencement</h3><p>Corrections des tailles de texte, des cibles tactiles, des ancres répétées et des adresses canoniques en www. Le sitemap a été mis à jour.</p><p><a class="btn btn-gold" href="guides.html">Lire les guides →</a></p></article>
        <article class="card"><span class="card-index">Novembre 2026</span><h3>Vingt-trois audio en ligne</h3><p>Les enregistrements de khassaïdes sont hébergés sur le stockage de l’application et écoutables depuis le site. La lecture reste en ligne, sans compte ni enregistrement local.</p><p><a class="btn btn-gold" href="audio.html">Écouter →</a></p></article>
        <article class="card"><span class="card-index">Novembre 2026</span><h3>Application Android 1.0</h3><p>La version 1.0.0+2 a été compilée, signée et installée sur un appareil de test. Les contenus intégrés fonctionnent hors ligne ; la publication sur Google Play attend la validation du compte.</p><p><a class="btn btn-gold" href="index.html#notification">Être informé →</a></p></article>
      </div>
    </section>
''';

const String agendaBody = '''
    <section>
      <div class="section-head">
        <span class="kicker">Agenda mouride</span>
        <h2>Les dates déjà calculées dans l’application</h2>
        <p>Cette page reprend les repères du calendrier de l’application, avec le réglage « Sénégal / Touba (+1 jour) ». Elle n’invente aucune date et n’annonce aucune cérémonie : elle sert de repère de lecture.</p>
      </div>
      <div class="section-head">
        <span class="kicker">À venir</span>
        <h2>Repères 2027</h2>
        <p>Dates grégoriennes calculées par l’application, avec la date hijri et le nom français utilisé dans l’application.</p>
      </div>
      <ul class="agenda-list">
        <li class="agenda-row"><span class="agenda-date">6 janvier 2027</span><div><strong>Isra et Miraj</strong><p>27 Rajab</p></div></li>
        <li class="agenda-row"><span class="agenda-date">9 février 2027</span><div><strong>Début du Ramadan</strong><p>1 Ramadan</p></div></li>
        <li class="agenda-row"><span class="agenda-date">7 mars 2027</span><div><strong>Laylat al-Qadr</strong><p>27 Ramadan</p></div></li>
        <li class="agenda-row"><span class="agenda-date">10 mars 2027</span><div><strong>Aïd al-Fitr</strong><p>1 Chawwal</p></div></li>
        <li class="agenda-row"><span class="agenda-date">17 mai 2027</span><div><strong>Aïd al-Adha</strong><p>10 Dhou al-Hijja</p></div></li>
        <li class="agenda-row"><span class="agenda-date">7 juin 2027</span><div><strong>Nouvel an islamique</strong><p>1 Mouharram</p></div></li>
        <li class="agenda-row"><span class="agenda-date">16 juin 2027</span><div><strong>Achoura</strong><p>10 Mouharram</p></div></li>
        <li class="agenda-row"><span class="agenda-date">23 juillet 2027</span><div><strong>Grand Magal de Touba</strong><p>18 Safar · repère mouride</p></div></li>
        <li class="agenda-row"><span class="agenda-date">15 août 2027</span><div><strong>Mawlid — Naissance du Prophète</strong><p>12 Rabi al-awwal</p></div></li>
      </ul>
      <details class="agenda-past">
        <summary>Repères 2026 déjà passés</summary>
        <ul class="agenda-list">
          <li class="agenda-row"><span class="agenda-date">17 janvier 2026</span><div><strong>Isra et Miraj</strong><p>27 Rajab</p></div></li>
          <li class="agenda-row"><span class="agenda-date">19 février 2026</span><div><strong>Début du Ramadan</strong><p>1 Ramadan</p></div></li>
          <li class="agenda-row"><span class="agenda-date">17 mars 2026</span><div><strong>Laylat al-Qadr</strong><p>27 Ramadan</p></div></li>
          <li class="agenda-row"><span class="agenda-date">21 mars 2026</span><div><strong>Aïd al-Fitr</strong><p>1 Chawwal</p></div></li>
          <li class="agenda-row"><span class="agenda-date">28 mai 2026</span><div><strong>Aïd al-Adha</strong><p>10 Dhou al-Hijja</p></div></li>
          <li class="agenda-row"><span class="agenda-date">17 juin 2026</span><div><strong>Nouvel an islamique</strong><p>1 Mouharram</p></div></li>
          <li class="agenda-row"><span class="agenda-date">26 juin 2026</span><div><strong>Achoura</strong><p>10 Mouharram</p></div></li>
          <li class="agenda-row"><span class="agenda-date">2 août 2026</span><div><strong>Grand Magal de Touba</strong><p>18 Safar · repère mouride</p></div></li>
          <li class="agenda-row"><span class="agenda-date">26 août 2026</span><div><strong>Mawlid — Naissance du Prophète</strong><p>12 Rabi al-awwal</p></div></li>
        </ul>
      </details>
      <p class="agenda-note">Mise à jour le 26 novembre 2026. Pour le Grand Magal, se tenir à la date annoncée par les autorités compétentes. Le même calendrier est consultable hors ligne dans l’application, avec compte à rebours et réglage Touba. <a href="prieres.html#calendrier">Voir le calendrier →</a></p>
    </section>

    <section>
      <div class="manifesto">
        <h2>Lire les repères mourides</h2>
        <p>Le Grand Magal, Touba, l’exil, les Khalifes, la famille et les disciples sont présentés dans les chapitres de XAM YOONWI. <a href="voie-mouride.html#sous-rubriques">Ouvrir les sous-rubriques →</a></p>
      </div>
    </section>
''';

const String rechercheBody = '''
    <section>
      <div class="section-head">
        <span class="kicker">Recherche globale</span>
        <h2>Chercher sans serveur</h2>
        <p>L’index est publié avec le site, comme les pages et les listes. La recherche s’effectue dans votre navigateur : aucune lettre, aucun mot et aucun résultat ne sont envoyés.</p>
      </div>
      <div class="search-panel">
        <label for="global-search">Titre, langue, chapitre ou khassaïde</label>
        <input id="global-search" type="search" autocomplete="off" spellcheck="false" placeholder="Ex. : Grand Magal, Mbacké, Ramadan">
        <div class="search-filters" role="group" aria-label="Filtrer les résultats">
          <button type="button" data-search-kind="Tous" aria-pressed="true">Tous</button>
          <button type="button" data-search-kind="Page" aria-pressed="false">Pages</button>
          <button type="button" data-search-kind="Livre" aria-pressed="false">Livres</button>
          <button type="button" data-search-kind="Audio" aria-pressed="false">Audio</button>
        </div>
        <p class="audio-status" id="search-status" role="status" aria-live="polite"></p>
        <div class="search-results" id="search-results"></div>
      </div>
      <p class="search-note">Les PDF s’ouvrent dans un nouvel onglet. Les pages, les chapitres et les pistes audio restent sur ce site.</p>
    </section>
''';

const String homeInsert = '''
  <section id="actualites-accueil">
    <div class="wrap">
      <div class="section-head">
        <span class="kicker">À la une</span>
        <h2>Ce qui a changé récemment</h2>
        <p>Trois ajouts réels et datés, sans annonce anticipée. Le journal complet reste accessible dans les actualités.</p>
      </div>
      <div class="card-grid">
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Agenda mouride</h3><p>Les dates calculées dans l’application réunies dans une page claire, avec le réglage Sénégal / Touba.</p><p><a class="btn btn-gold" href="agenda.html">Ouvrir l’agenda →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Recherche globale</h3><p>Pages, khassaïdes et audio dans un seul champ, sans serveur et sans suivi.</p><p><a class="btn btn-gold" href="recherche.html">Chercher →</a></p></article>
        <article class="card"><span class="card-index">26 novembre 2026</span><h3>Playlist audio</h3><p>Vingt-trois enregistrements en écoute directe, avec lecture, pause, précédent et suivant.</p><p><a class="btn btn-gold" href="audio.html">Écouter →</a></p></article>
      </div>
      <p class="note-links">Lire aussi <a href="actualites.html">toutes les actualités</a>.</p>
    </div>
  </section>

  <section id="agenda-accueil">
    <div class="wrap">
      <div class="section-head">
        <span class="kicker">Agenda</span>
        <h2>Prochains repères mourides</h2>
        <p>Dates calculées par l’application avec le réglage « Sénégal / Touba (+1 jour) ».</p>
      </div>
      <ul class="agenda-list">
        <li class="agenda-row"><span class="agenda-date">6 janvier 2027</span><div><strong>Isra et Miraj</strong><p>27 Rajab</p></div></li>
        <li class="agenda-row"><span class="agenda-date">9 février 2027</span><div><strong>Début du Ramadan</strong><p>1 Ramadan</p></div></li>
        <li class="agenda-row"><span class="agenda-date">23 juillet 2027</span><div><strong>Grand Magal de Touba</strong><p>18 Safar · repère mouride</p></div></li>
      </ul>
      <p class="note-links">Voir <a href="agenda.html">tout l’agenda</a> et <a href="prieres.html#calendrier">le calendrier de l’application</a>.</p>
    </div>
  </section>

''';

const String sousRubriquesInsert = '''
    <section class="rubrique" id="sous-rubriques">
      <div class="copy">
        <span class="kicker">Sous-rubriques mourides</span>
        <h2>Les repères, chapitre par chapitre</h2>
        <p>Ces entrées ne sont pas de nouveaux textes : elles pointent vers les chapitres déjà présents dans XAM YOONWI. Aucun nom propre, aucun verset et aucune invocation n’a été modifié.</p>
        <div class="links"><a class="btn btn-gold" href="xam-yoonwi.html">Lire les trente chapitres →</a></div>
      </div>
      <div class="shots">
        <figure>
          <a href="assets/screenshots/v2/09_xam_yoonwi.png" target="_blank" rel="noopener"><img src="assets/screenshots/v2/09_xam_yoonwi.png" alt="XAM YOONWI — ouvrir en grand" width="720" height="1560" loading="lazy"></a>
          <figcaption>Sommaire des chapitres</figcaption>
        </figure>
      </div>
    </section>

    <section>
      <div class="section-head">
        <span class="kicker">Sous-rubriques</span>
        <h2>Khalifes, famille, disciples, exils, Sanoussi</h2>
        <p>Cinq portes de lecture, toutes issues du sommaire de XAM YOONWI.</p>
      </div>
      <div class="card-grid">
        <article class="card"><span class="card-index">01</span><h3>Les Khalifes</h3><p>Chapitre 9 : les Khalifes généraux, puis les chapitres 10 à 17 pour chaque succession.</p><p><a class="btn btn-gold" href="xam-yoonwi.html#chapitre-9">Ouvrir le chapitre 9 →</a></p></article>
        <article class="card"><span class="card-index">02</span><h3>La famille</h3><p>Chapitres 18 et 19 : Serigne Mame Mor Anta Saly Mbacké et Sokhna Diaratoul Lahi Bousso.</p><p><a class="btn btn-gold" href="xam-yoonwi.html#chapitre-19">Ouvrir le chapitre 19 →</a></p></article>
        <article class="card"><span class="card-index">03</span><h3>Les grands disciples</h3><p>Chapitres 20 à 29 : Cheikh Ibrahima Fall, Mame Cheikh Anta Mbacké, Mame Thierno Birahim et les autres disciples.</p><p><a class="btn btn-gold" href="xam-yoonwi.html#chapitre-21">Ouvrir le chapitre 21 →</a></p></article>
        <article class="card"><span class="card-index">04</span><h3>Les exils</h3><p>Chapitre 7 : le Gabon, la Mauritanie et la résidence surveillée de Diourbel, tels que racontés dans l’application.</p><p><a class="btn btn-gold" href="xam-yoonwi.html#chapitre-7">Ouvrir le chapitre 7 →</a></p></article>
        <article class="card"><span class="card-index">05</span><h3>Sanoussi</h3><p>Le chapitre 29 est consacré à Serigne Sonhibou Mbacké, dit Sanoussi, dans le texte de XAM YOONWI.</p><p><a class="btn btn-gold" href="xam-yoonwi.html#chapitre-29">Ouvrir le chapitre 29 →</a></p></article>
        <article class="card"><span class="card-index">06</span><h3>Témoignages</h3><p>Chapitre 30 : ce que disent les disciples, les fils et les proches de Serigne Touba.</p><p><a class="btn btn-gold" href="xam-yoonwi.html#chapitre-30">Ouvrir le chapitre 30 →</a></p></article>
      </div>
    </section>

''';

const String cssInsert = r'''
/* ---------- Actu, agenda, playlist et recherche ---------- */
#actualites-accueil .card-grid, #agenda-accueil .agenda-list,
#sous-rubriques + section .card-grid { margin-top: 18px; }
.actualite-card .card-index { display: block; margin-bottom: 8px; }

.agenda-list {
  display: grid;
  gap: 10px;
  margin: 16px 0 0;
  padding: 0;
  list-style: none;
}
.agenda-row {
  display: grid;
  grid-template-columns: minmax(0, 1fr);
  gap: 6px;
  padding: 14px;
  border: 1px solid rgba(201, 154, 46, .42);
  border-radius: 14px;
  background: rgba(9, 45, 29, .86);
}
.agenda-date { color: var(--gold-light); font-size: 1rem; font-weight: 800; }
.agenda-row strong { color: #FFF7E2; }
.agenda-row p { margin: 0; color: #E7F0E6; }
.agenda-past {
  margin-top: 18px;
  padding: 14px;
  border: 1px solid rgba(201, 154, 46, .42);
  border-radius: 16px;
  background: rgba(6, 30, 19, .62);
}
.agenda-past summary {
  display: flex;
  align-items: center;
  min-height: 48px;
  color: var(--gold-light);
  font-weight: 800;
  cursor: pointer;
}
.agenda-note, .search-note { margin-top: 18px; color: #E7F0E6; }
.agenda-note a, .search-note a { color: var(--gold-light); font-weight: 700; }
@media (min-width: 720px) {
  .agenda-row { grid-template-columns: 190px minmax(0, 1fr); align-items: center; }
}

/* Lecteur unique et playlist des vingt-trois MP3. */
.player-panel {
  position: sticky;
  top: 10px;
  z-index: 2;
  padding: clamp(16px, 2.4vw, 22px);
  border: 1px solid rgba(201, 154, 46, .62);
  border-radius: 18px;
  background: rgba(6, 30, 19, .94);
  box-shadow: 0 16px 36px rgba(3, 20, 12, .30);
}
.player-panel h2 { margin: 0 0 10px; color: #FFF7E2; font-size: 1.22rem; }
.player-panel audio { display: block; width: 100%; height: 54px; }
.player-controls { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px; }
.player-controls button {
  min-width: 48px;
  min-height: 48px;
  padding: 0 14px;
  border: 1px solid var(--gold);
  border-radius: 999px;
  background: rgba(201, 154, 46, .18);
  color: #FFF7E2;
  font-size: 1rem;
  cursor: pointer;
}
.player-controls button:hover { background: rgba(201, 154, 46, .30); }
.playlist { display: grid; gap: 10px; margin: 18px 0 0; padding: 0; list-style: none; }
.playlist-row {
  display: grid;
  grid-template-columns: 48px minmax(0, 1fr);
  gap: 12px;
  align-items: center;
  padding: 12px;
  border: 1px solid rgba(201, 154, 46, .40);
  border-radius: 16px;
  background: rgba(9, 45, 29, .86);
}
.playlist-row.is-current {
  border-color: var(--gold);
  box-shadow: inset 0 0 0 1px rgba(247, 230, 168, .18);
}
.playlist-play {
  width: 48px;
  height: 48px;
  border: 1px solid var(--gold);
  border-radius: 50%;
  background: rgba(201, 154, 46, .20);
  color: #FFF7E2;
  font-size: 1.05rem;
  cursor: pointer;
}
.playlist-play:hover { background: rgba(201, 154, 46, .32); }
.playlist-row h3 {
  margin: 0 0 4px;
  color: #FFF7E2;
  font-size: 1.05rem;
  line-height: 1.35;
  overflow-wrap: anywhere;
}
.playlist-num { margin-right: 8px; color: var(--gold-light); font-size: 1rem; font-weight: 800; }
.playlist-duration { margin: 0; color: #E7F0E6; font-size: 1rem; }
.audio-status { min-height: 1.5em; margin: 10px 0 0; color: var(--gold-light); font-size: 1rem; }
.audio-note { margin-top: 18px; }

/* Recherche statique : aucun appel réseau, aucun formulaire envoyé. */
.search-panel {
  margin-top: 18px;
  padding: clamp(18px, 3vw, 28px);
  border: 1px solid rgba(201, 154, 46, .58);
  border-radius: 20px;
  background: rgba(6, 30, 19, .86);
}
.search-panel label { display: block; margin-bottom: 8px; color: #FFF7E2; font-weight: 800; }
.search-panel input {
  width: 100%;
  min-height: 52px;
  padding: 12px 14px;
  border: 1px solid rgba(201, 154, 46, .55);
  border-radius: 12px;
  background: rgba(6, 30, 19, .70);
  color: #FFF7E2;
  font-size: 1rem;
}
.search-panel input::placeholder { color: rgba(231, 240, 230, .70); }
.search-filters { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 14px; }
.search-filters button {
  min-height: 48px;
  padding: 0 16px;
  border: 1px solid rgba(201, 154, 46, .58);
  border-radius: 999px;
  background: rgba(201, 154, 46, .14);
  color: #FFF7E2;
  font-size: 1rem;
  cursor: pointer;
}
.search-filters button[aria-pressed="true"] {
  background: var(--gold-light);
  color: var(--deep);
  font-weight: 800;
}
.search-results { display: grid; gap: 10px; margin-top: 16px; }
.search-item {
  display: block;
  padding: 14px;
  border: 1px solid rgba(201, 154, 46, .40);
  border-radius: 14px;
  background: rgba(9, 45, 29, .86);
  color: #FFF7E2;
  text-decoration: none;
}
.search-item:hover { border-color: var(--gold); }
.search-kind {
  display: inline-block;
  margin-right: 8px;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(201, 154, 46, .20);
  color: var(--gold-light);
  font-size: 1rem;
  font-weight: 800;
}
.search-title { font-weight: 800; }
.search-snippet {
  display: block;
  margin-top: 6px;
  color: #E7F0E6;
  overflow-wrap: anywhere;
}
.search-empty { margin: 0; padding: 18px; color: #E7F0E6; }
''';

const String jsInsert = r'''

  /* ---------- Playlist audio : lecture en ligne, aucun téléchargement ---------- */
  function initAudioPlaylist() {
    const player = $('#audio-player');
    const list = $('#playlist');
    const status = $('#audio-status');
    if (!player || !list) return;
    const rows = $$('.playlist-row', list);
    if (!rows.length) return;
    let current = -1;

    const titleOf = (row) => row.dataset.title || 'cet enregistrement';

    const reflect = () => {
      rows.forEach((row, index) => {
        const playing = index === current && !player.paused;
        row.classList.toggle('is-current', index === current);
        const button = $('.playlist-play', row);
        if (button) {
          button.textContent = playing ? '❚❚' : '▶';
          button.setAttribute('aria-label', (playing ? 'Mettre en pause : ' : 'Lire : ') + titleOf(row));
        }
      });
    };

    const announce = (message) => {
      if (status) status.textContent = message;
    };

    const setTrack = (index, play) => {
      if (index < 0 || index >= rows.length) return;
      current = index;
      player.src = rows[index].dataset.src;
      player.load();
      announce('En cours : ' + titleOf(rows[index]));
      reflect();
      if (play) {
        const pending = player.play();
        if (pending && pending.catch) {
          pending.catch(() => announce('Lecture bloquée par le navigateur : utilisez le bouton du lecteur.'));
        }
      }
    };

    const toggle = (index) => {
      if (index !== current) {
        setTrack(index, true);
        return;
      }
      if (player.paused) {
        const pending = player.play();
        if (pending && pending.catch) pending.catch(() => announce('Lecture indisponible.'));
      } else {
        player.pause();
      }
    };

    rows.forEach((row, index) => {
      const button = $('.playlist-play', row);
      if (button) button.addEventListener('click', () => toggle(index));
    });

    const previous = $('[data-audio-prev]');
    const next = $('[data-audio-next]');
    if (previous) previous.addEventListener('click', () => {
      setTrack(current <= 0 ? rows.length - 1 : current - 1, true);
    });
    if (next) next.addEventListener('click', () => {
      setTrack(current >= rows.length - 1 ? 0 : current + 1, true);
    });

    player.addEventListener('play', reflect);
    player.addEventListener('pause', reflect);
    player.addEventListener('ended', () => {
      if (current < rows.length - 1) {
        setTrack(current + 1, true);
      } else {
        announce('Fin de la playlist.');
        reflect();
      }
    });
  }

  /* ---------- Recherche globale : index local, aucun envoi ---------- */
  function initGlobalSearch() {
    const input = $('#global-search');
    const results = $('#search-results');
    const status = $('#search-status');
    if (!input || !results || !status) return;
    const index = window.DIIWAANU_SEARCH_INDEX || [];
    let selected = 'Tous';

    const normalise = (value) => String(value || '')
      .toLocaleLowerCase('fr')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');

    const escapeHtml = (value) => String(value || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');

    const render = () => {
      const query = normalise(input.value.trim());
      status.textContent = query
        ? ''
        : index.length + ' entrées disponibles — tapez un mot pour chercher.';
      if (!query) {
        results.innerHTML = '';
        return;
      }
      const found = index.filter((item) => {
        if (selected !== 'Tous' && item.kind !== selected) return false;
        return normalise(String(item.title) + ' ' + String(item.text)).includes(query);
      }).slice(0, 40);

      status.textContent = found.length
        ? found.length + ' résultat' + (found.length > 1 ? 's' : '') + ' affiché' + (found.length > 1 ? 's' : '') + ' sur ' + index.length + ' entrées (40 maximum).'
        : 'Aucun résultat pour cette recherche.';

      if (!found.length) {
        results.innerHTML = '<p class="search-empty">Essayez un autre mot : un titre, une langue, un nom ou un chapitre.</p>';
        return;
      }
      results.innerHTML = found.map((item) => {
        const target = item.external ? ' target="_blank" rel="noopener"' : '';
        return '<a class="search-item" href="' + escapeHtml(item.url) + '"' + target + '>'
          + '<span class="search-kind">' + escapeHtml(item.kind) + '</span>'
          + '<span class="search-title">' + escapeHtml(item.title) + '</span>'
          + '<span class="search-snippet">' + escapeHtml(item.text) + '</span>'
          + '</a>';
      }).join('');
    };

    $$('[data-search-kind]').forEach((button) => {
      button.addEventListener('click', () => {
        selected = button.dataset.searchKind;
        $$('[data-search-kind]').forEach((other) => {
          other.setAttribute('aria-pressed', String(other === button));
        });
        render();
      });
    });

    input.addEventListener('input', render);
    input.addEventListener('search', render);
    render();
  }
''';

String formatDuration(int seconds) {
  final minutes = seconds ~/ 60;
  final hours = minutes ~/ 60;
  if (hours > 0) return '${hours} h ${minutes % 60} min';
  return '$minutes min';
}

String decodeHtml(String value) {
  var text = value.replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
    return String.fromCharCode(int.parse(m.group(1)!));
  });
  text = text
      .replaceAll('&quot;', '"')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&');
  return text;
}

String compact(String value) => value.replaceAll(RegExp(r'\s+'), ' ').trim();
String stripTags(String value) => value.replaceAll(RegExp(r'<[^>]+>'), ' ');

String firstGroup(String html, RegExp pattern) {
  final match = pattern.firstMatch(html);
  return match == null ? '' : decodeHtml(match.group(1)!);
}

void generateAudioPage() {
  final manifestFile = File('$siteDir/assets/audio/manifest.json');
  final tracks = json.decode(manifestFile.readAsStringSync()) as List<dynamic>;
  final rows = StringBuffer();

  for (var i = 0; i < tracks.length; i++) {
    final track = tracks[i] as Map<String, dynamic>;
    final title = (track['title'] ?? track['file'] ?? 'Enregistrement ${i + 1}').toString();
    final url = (track['url'] ?? '').toString();
    final seconds = track['duration'] is int ? track['duration'] as int : 0;
    final duration = formatDuration(seconds);
    rows.writeln('''        <li class="playlist-row" id="piste-${i + 1}"
            data-title="${h(title)}" data-src="${h(url)}" data-duration="${h(duration)}">
          <button class="playlist-play" type="button" aria-label="Lire : ${h(title)}"><span aria-hidden="true">▶</span></button>
          <div class="playlist-copy">
            <h3><span class="playlist-num" aria-hidden="true">${(i + 1).toString().padLeft(2, '0')}</span>${h(title)}</h3>
            <p class="playlist-duration">Durée : ${h(duration)}</p>
          </div>
        </li>''');
  }

  final body = '''
    <section>
      <div class="section-head">
        <span class="kicker">À écouter</span>
        <h2>Lecture en ligne, sans téléchargement</h2>
        <p>Les enregistrements sont hébergés avec les fichiers du projet. Choisissez une piste dans la liste : elle se charge dans le lecteur ci-dessus. Aucun MP3 n’est enregistré sur l’appareil, aucun suivi n’est ajouté.</p>
      </div>
      <div class="player-panel">
        <h2 id="player-title">Lecteur des khassaïdes</h2>
        <audio id="audio-player" controls preload="none" aria-label="Lecteur audio des khassaïdes"></audio>
        <div class="player-controls" role="group" aria-label="Contrôles de la playlist">
          <button type="button" data-audio-prev aria-label="Piste précédente">‹ Précédent</button>
          <button type="button" data-audio-next aria-label="Piste suivante">Suivant ›</button>
        </div>
        <p class="audio-status" id="audio-status" role="status" aria-live="polite">Choissez une piste pour commencer l’écoute.</p>
      </div>
      <ol class="playlist" id="playlist" aria-label="Playlist des khassaïdes">
${rows.toString()}
      </ol>
    </section>

    <section>
      <div class="manifesto">
        <h2>Écoute directe, sans compte</h2>
        <p>Les MP3 sont diffusés depuis le même stockage que les PDF. Pas de publicité, pas de formulaire, pas d’historique : la lecture dépend uniquement du lecteur de votre navigateur. <a href="bibliotheque.html">Voir la bibliothèque →</a></p>
      </div>
    </section>
''';

  writeFile(
    'audio.html',
    pageShell(
      slug: 'audio.html',
      title: 'Audio — Diiwaanu Xassida Yi',
      description: 'Écoutez les khassaïdes en ligne au format MP3, directement sur le site, sans compte ni publicité ni enregistrement sur l’appareil.',
      eyebrow: 'Audio',
      heading: 'Les khassaïdes<br><span>à écouter</span>',
      lead: 'Vingt-trois enregistrements dans une seule playlist, avec lecture en ligne, sans inscription ni suivi.',
      body: body,
    ),
  );
}

void generateSearchIndex() {
  final entries = <Map<String, dynamic>>[];

  for (final file in htmlFiles()) {
    final name = file.uri.pathSegments.last;
    if (name == 'recherche.html') continue;
    final html = file.readAsStringSync();
    final rawTitle = firstGroup(html, RegExp(r'<title>(.*?)</title>', dotAll: true));
    final title = compact(stripTags(rawTitle)).split('—').first.trim();
    final description = firstGroup(
      html,
      RegExp(r'<meta name="description" content="([^"]*)"'),
    );
    final headings = RegExp(r'<h[123][^>]*>(.*?)</h[123]>', dotAll: true)
        .allMatches(html)
        .map((m) => compact(stripTags(m.group(1)!)))
        .where((value) => value.isNotEmpty)
        .take(30)
        .toList();
    final text = compact(<String>[description, ...headings].join(' '));
    entries.add(<String, dynamic>{
      'kind': 'Page',
      'title': title.isEmpty ? name : title,
      'text': text,
      'url': name,
      'external': false,
    });
  }

  var books = 0;
  for (final name in <String>[
    'bibliotheque-arabe.html',
    'bibliotheque-francais.html',
    'bibliotheque-wolof.html',
    'bibliotheque-anglais.html',
  ]) {
    final html = File('$siteDir/$name').readAsStringSync();
    final rowRe = RegExp(
      r'<li class="book-row"\s+data-title="([^"]*)"\s+data-arabic="([^"]*)"\s+data-lang="([^"]*)"',
      dotAll: true,
    );
    for (final match in rowRe.allMatches(html)) {
      final end = html.indexOf('</li>', match.end);
      final chunk = html.substring(match.start, end < 0 ? html.length : end + 5);
      final link = RegExp(r'class="read" href="([^"]+)"').firstMatch(chunk);
      final url = link == null ? name : decodeHtml(link.group(1)!);
      final title = decodeHtml(match.group(1)!);
      final arabic = decodeHtml(match.group(2)!);
      final lang = decodeHtml(match.group(3)!);
      entries.add(<String, dynamic>{
        'kind': 'Livre',
        'title': title,
        'text': compact('$lang $arabic khassaïde PDF'),
        'url': url,
        'external': true,
      });
      books++;
    }
  }

  final manifest = json.decode(File('$siteDir/assets/audio/manifest.json').readAsStringSync())
      as List<dynamic>;
  for (var i = 0; i < manifest.length; i++) {
    final track = manifest[i] as Map<String, dynamic>;
    final title = (track['title'] ?? track['file'] ?? 'Enregistrement ${i + 1}').toString();
    final seconds = track['duration'] is int ? track['duration'] as int : 0;
    entries.add(<String, dynamic>{
      'kind': 'Audio',
      'title': title,
      'text': compact('Enregistrement audio des khassaïdes. Durée : ${formatDuration(seconds)}.'),
      'url': 'audio.html#piste-${i + 1}',
      'external': false,
    });
  }

  final output = 'window.DIIWAANU_SEARCH_INDEX = ${json.encode(entries)};\n';
  File('$siteDir/assets/js/search-data.js').writeAsStringSync(output, flush: true);
  stdout.writeln('Index de recherche : ${entries.length} entrées (dont $books livres et ${manifest.length} audio).');
}

void updateSitemap() {
  final file = File('$siteDir/sitemap.xml');
  var sitemap = file.readAsStringSync();
  const blocks = <String, String>{
    'agenda.html': '''
  <url>
    <loc>$base/agenda.html</loc>
    <lastmod>2026-11-26</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>
''',
    'recherche.html': '''
  <url>
    <loc>$base/recherche.html</loc>
    <lastmod>2026-11-26</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.6</priority>
  </url>
''',
  };
  blocks.forEach((name, block) {
    if (!sitemap.contains('$base/$name')) {
      sitemap = sitemap.replaceFirst('</urlset>', '$block</urlset>');
      stdout.writeln('Sitemap : $name ajouté');
    }
  });
  file.writeAsStringSync(sitemap, flush: true);
}

void appendCssAndJs() {
  final cssFile = File('$siteDir/assets/css/site.css');
  var css = cssFile.readAsStringSync();
  if (!css.contains('/* ---------- Actu, agenda, playlist et recherche ---------- */')) {
    css = css.trimRight() + '\n\n' + cssInsert;
    cssFile.writeAsStringSync(css, flush: true);
    stdout.writeln('CSS complété');
  }

  final jsFile = File('$siteDir/assets/js/site.js');
  var js = jsFile.readAsStringSync();
  if (!js.contains('function initAudioPlaylist()')) {
    js = js.replaceFirst(
      '  document.addEventListener(\'DOMContentLoaded\', () => {',
      jsInsert + '\n  document.addEventListener(\'DOMContentLoaded\', () => {',
    );
    js = js.replaceFirst(
      RegExp(r'    initLibrary\(\);\s+initToTop\(\);'),
      '    initLibrary();\n    initAudioPlaylist();\n    initGlobalSearch();\n    initToTop();',
    );
    jsFile.writeAsStringSync(js, flush: true);
    stdout.writeln('JavaScript complété');
  }
}

void patchHome() {
  final file = File('$siteDir/index.html');
  var html = file.readAsStringSync();
  if (!html.contains('id="actualites-accueil"')) {
    html = html.replaceFirst(
      '  <section id="fonctionnalites">',
      homeInsert + '  <section id="fonctionnalites">',
    );
    file.writeAsStringSync(html, flush: true);
    stdout.writeln('Accueil complété');
  }
}

void patchVoieMouride() {
  final file = File('$siteDir/voie-mouride.html');
  var html = file.readAsStringSync();
  if (!html.contains('id="sous-rubriques"')) {
    html = html.replaceFirst(
      '    <section class="rubrique" id="fondements">',
      sousRubriquesInsert + '    <section class="rubrique" id="fondements">',
    );
    file.writeAsStringSync(html, flush: true);
    stdout.writeln('Voie Mouride complétée');
  }
}

void patchRubriques() {
  final file = File('$siteDir/rubriques.html');
  var html = file.readAsStringSync();
  if (!html.contains('href="agenda.html"')) {
    html = html.replaceFirst(
      '        <a href="xam-yoonwi.html">XAM YOONWI</a>\n      </nav>',
      '        <a href="xam-yoonwi.html">XAM YOONWI</a>\n'
      '        <a href="agenda.html">Agenda mouride</a>\n'
      '        <a href="recherche.html">Recherche globale</a>\n      </nav>',
    );
    file.writeAsStringSync(html, flush: true);
    stdout.writeln('Plan du site complété');
  }
}

const String generatorMenu = r'''const List<MenuItem> kMenuItems = [
  MenuItem('Accueil', 'index.html'),
  MenuItem('La Voie Mouride', 'voie-mouride.html', [
    MenuItem('Fondements', 'voie-mouride.html#fondements'),
    MenuItem('La Lumière de Touba', 'voie-mouride.html#lumiere'),
    MenuItem('Sous-rubriques mourides', 'voie-mouride.html#sous-rubriques'),
    MenuItem('XAM YOONWI', 'xam-yoonwi.html'),
  ]),
  MenuItem('Livres', 'livres.html', [
    MenuItem('Bibliothèque', 'bibliotheque.html'),
    MenuItem('Arabe', 'bibliotheque-arabe.html'),
    MenuItem('Français', 'bibliotheque-francais.html'),
    MenuItem('Wolof', 'bibliotheque-wolof.html'),
    MenuItem('Anglais', 'bibliotheque-anglais.html'),
  ]),
  MenuItem('Enseignements', 'enseignements.html', [
    MenuItem('Nafilas', 'nafilas.html'),
    MenuItem('Nafila du jour', 'nafila-du-jour.html'),
    MenuItem('99 Noms', '99-noms.html'),
  ]),
  MenuItem('Média', 'media.html', [
    MenuItem('Audio', 'audio.html'),
  ]),
  MenuItem('Guides', 'guides.html', [
    MenuItem('Prières', 'prieres.html'),
  ]),
  MenuItem('Actualités', 'actualites.html', [
    MenuItem('Journal du projet', 'actualites.html'),
    MenuItem('Agenda mouride', 'agenda.html'),
  ]),
  MenuItem('Contact', 'contact.html'),
  MenuItem('Plan du site', 'rubriques.html', [
    MenuItem('Recherche globale', 'recherche.html'),
  ]),
];''';

const String generatorFooter = r'''      <div class="foot-links">
        <a href="rubriques.html">Plan du site</a>
        <a href="recherche.html">Recherche globale</a>
        <a href="voie-mouride.html">La Voie Mouride</a>
        <a href="livres.html">Livres</a>
        <a href="enseignements.html">Enseignements</a>
        <a href="media.html">Média</a>
        <a href="guides.html">Guides</a>
        <a href="actualites.html">Actualités</a>
        <a href="agenda.html">Agenda</a>
        <a href="contact.html">Contact</a>
        <a href="bibliotheque.html">Bibliothèque</a>
        <a href="audio.html">Audio</a>
        <a href="prieres.html">Prières</a>
        <a href="nafilas.html">Nafilas</a>
        <a href="99-noms.html">99 Noms</a>
        <a href="xam-yoonwi.html">XAM YOONWI</a>
      </div>''';

void patchGenerators() {
  final generator = File('$generatorDir/tools/generate_site_pages.dart');
  if (generator.existsSync()) {
    var text = generator.readAsStringSync();
    text = text.replaceAll('biblio28', version);
    text = text.replaceAll(
      RegExp(r'const List<MenuItem> kMenuItems = \[.*?\n\];', dotAll: true),
      generatorMenu,
    );
    text = text.replaceAll(
      RegExp(r'<div class="foot-links">.*?</div>', dotAll: true),
      generatorFooter,
    );
    generator.writeAsStringSync(text, flush: true);
    stdout.writeln('Générateur/application mis à jour');
  }

  final older = File(r'C:\Users\akman\AppData\Local\Temp\opencode\build_site_sections.dart');
  if (older.existsSync()) {
    var text = older.readAsStringSync().replaceAll('biblio28', version);
    text = text.replaceAll('biblio27', version);
    older.writeAsStringSync(text, flush: true);
    stdout.writeln('Ancien script de rubriques synchronisé');
  }

  final audit = File(r'C:\Users\akman\AppData\Local\Temp\opencode\audit_site_sections.dart');
  if (audit.existsSync()) {
    var text = audit.readAsStringSync().replaceAll('biblio28', version);
    text = text.replaceAll('biblio27', version);
    audit.writeAsStringSync(text, flush: true);
    stdout.writeln('Audit synchronisé');
  }
}

void main() {
  updateShells();

  writeFile(
    'actualites.html',
    pageShell(
      slug: 'actualites.html',
      title: 'Actualités du projet — Diiwaanu Xassida Yi',
      description: 'Journal daté du site et de l’application Diiwaanu Xassida Yi : rubriques, corrections, audio, agenda et version Android 1.0.',
      eyebrow: 'L’actu',
      heading: 'L’actualité du projet',
      lead: 'Les changements réels du site et de l’application, datés et vérifiables.',
      body: actualitesBody,
    ),
  );

  writeFile(
    'agenda.html',
    pageShell(
      slug: 'agenda.html',
      title: 'Agenda mouride — Diiwaanu Xassida Yi',
      description: 'Dates mourides et religieuses calculées dans l’application : Ramadan, Aïd, Achoura, Mawlid et Grand Magal de Touba.',
      eyebrow: 'Agenda mouride',
      heading: 'Les repères<br><span>datés</span>',
      lead: 'Les dates du calendrier de l’application, avec le réglage Sénégal / Touba (+1 jour), sans annonce ni invention.',
      body: agendaBody,
    ),
  );

  writeFile(
    'recherche.html',
    pageShell(
      slug: 'recherche.html',
      title: 'Recherche globale — Diiwaanu Xassida Yi',
      description: 'Recherche locale dans les pages, les khassaïdes et les enregistrements audio, sans serveur ni suivi.',
      eyebrow: 'Recherche globale',
      heading: 'Chercher<br><span>sans serveur</span>',
      lead: 'Un index publié avec le site : aucune lettre saisie n’est envoyée, aucun résultat n’est suivi.',
      extraHead: '<script src="assets/js/search-data.js?v=$version" defer></script>',
      body: rechercheBody,
    ),
  );

  generateAudioPage();
  patchHome();
  patchVoieMouride();
  patchRubriques();
  updateShells();
  appendCssAndJs();
  generateSearchIndex();
  updateSitemap();
  patchGenerators();

  stdout.writeln('Terminé : $version');
}
