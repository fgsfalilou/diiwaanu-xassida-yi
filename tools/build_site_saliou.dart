// Construit la page des conférences de Serigne Saliou Sow sur le modèle de
// conferences.html (Serigne Moustapha Saliou), puis synchronise navigation,
// styles, sitemap, recherche, audit et mémo.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const r2Base = 'https://pub-f07ad970b3b84dfa8539a6cf6ce3f5b3.r2.dev';
const newPage = 'conferences-saliou-sow.html';

const titres = <String>[
  'Renouveau de Khadimou Rassoul',
  'Magal Serigne Abdou Khadr 2015',
  'Magal Serigne Abdou Khadre Mbacke 2016',
  'L’histoire des prophètes',
  'La place de la femme dans l’islam 1/3',
  'Waxtanu Serigne Saliou Sow — Gamou Touba Fall Saloum',
  'Koungueul 28.12.2017 — 01',
  'Koungueul 28.12.2017 — 02',
  'Koungueul 28.12.2017 — 03',
  'Koungueul 28.12.2017 — 04',
  'Koungueul 28.12.2017 — 05',
  'Koungueul 28.12.2017 — 06',
  'Koungueul 28.12.2017 — 07',
  'Koungueul 28.12.2017 — 08',
  'Koungueul 28.12.2017 — 09',
  'Yawmal Qiyyam — 1re partie',
  'Yawmal Qiyyam — 2e partie',
  'Yawmal Qiyyam — 3e partie',
  'Keurmassar 2013',
  'Gambie 2011',
  'Norvège 2008',
  'Louga 2012',
  'Louga 2012 — 02',
  'Mbacke 2003 — 01',
  'Mbacke 2003 — 02',
  'Dakar S. Fallou 98',
  'Amérique 2009 — 02',
  'Kaolack 2011 — 01',
  'Waxtanu Serigne Saliou Sow — Gamou Touba Fall Saloum',
  'Rahmatoul lahi halay hi — Mame Mor Diaara USA',
  'Magal Nietty Gouddi Ndakarou 2012 — 02',
  'Magal Nietty Gouddi Ndakarou 2012 — 03',
  'Goudi Cheikh Ibre Fall USA 2009',
  'L’islam et la médecine — Université Cheikh Anta Diop',
  'Réw Mawo 2011 — 01',
  'Réw Mawo 2011 — 02',
];

String esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

String read(String name) => File('$siteDir\\$name').readAsStringSync(encoding: utf8);

void write(String name, String content) {
  File('$siteDir\\$name').writeAsStringSync(content, encoding: utf8, flush: true);
  stdout.writeln('Écrit : $name');
}

List<File> htmlFiles() => Directory(siteDir)
    .listSync()
    .whereType<File>()
    .where((f) => f.path.toLowerCase().endsWith('.html'))
    .toList();

String playlistRows() => List<String>.generate(titres.length, (i) {
      final n = (i + 1).toString().padLeft(2, '0');
      final titre = titres[i];
      final full = 'Conférence $n — Serigne Saliou Sow : $titre';
      return '''        <li class="playlist-row" id="saliou-piste-$n"
            data-title="${esc(full)}" data-src="$r2Base/CONFERENCES_SALIOU_SOW/s._saliou_sow_-_$n.mp3">
          <button class="playlist-play" type="button" aria-label="Lire : ${esc(full)}"><span aria-hidden="true">▶</span></button>
          <div class="playlist-copy">
            <h3><span class="playlist-num" aria-hidden="true">$n</span>${esc(titre)}</h3>
            <p class="playlist-duration">Serigne Saliou Sow · MP3</p>
          </div>
        </li>''';
    }).join('\n');

void patchNavigation() {
  const menuOld = '<li><a href="conferences.html">Conférences</a></li>';
  const menuOldCurrent = '<li><a href="conferences.html" aria-current="page">Conférences</a></li>';
  const linkOld = '<a href="conferences.html">Conférences</a>';

  for (final file in htmlFiles()) {
    var h = file.readAsStringSync(encoding: utf8);
    final name = file.uri.pathSegments.last;
    if (name == newPage) continue;
    if (!h.contains(newPage)) {
      final menuNew = name == 'conferences.html'
          ? '''<li><a href="conferences.html" aria-current="page">Conférences — S. Moustapha Saliou</a></li>
          <li><a href="$newPage">Conférences — S. Saliou Sow</a></li>'''
          : '''<li><a href="conferences.html">Conférences — S. Moustapha Saliou</a></li>
          <li><a href="$newPage">Conférences — S. Saliou Sow</a></li>''';
      h = h.replaceAll(menuOldCurrent, menuNew).replaceAll(menuOld, menuNew);
      h = h.replaceAll(linkOld, '''<a href="conferences.html">Conférences — S. Moustapha Saliou</a>
        <a href="$newPage">Conférences — S. Saliou Sow</a>''');
      file.writeAsStringSync(h, encoding: utf8, flush: true);
    }
  }

  // Lien interne dans l'introduction de la page Moustapha Saliou.
  var conf = read('conferences.html');
  const introLink = '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a></div>';
  const introLinkNew = '''<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a> <a class="btn btn-gold-outline" href="$newPage">Conférences de S. Saliou Sow →</a></div>''';
  if (!conf.contains('href="$newPage"') || conf.contains('Conférences de S. Saliou Sow')) {
    conf = conf.replaceAll(introLink, introLinkNew);
    write('conferences.html', conf);
  }
}

String buildPage() {
  var h = read('conferences.html');

  h = h.replaceAll(
    '<title>Conférences — Serigne Moustapha Saliou — Diiwaanu Xassida Yi</title>',
    '<title>Conférences — Serigne Saliou Sow — Diiwaanu Xassida Yi</title>',
  );
  h = h.replaceAll(
    '<meta name="description" content="Les conférences de Serigne Moustapha Saliou à écouter en ligne, sans compte ni publicité.">',
    '<meta name="description" content="Les conférences de Serigne Saliou Sow à écouter en ligne, sans compte ni publicité.">',
  );
  h = h.replaceAll(
    'https://www.diiwaanu-xassida-yi.com/conferences.html',
    'https://www.diiwaanu-xassida-yi.com/$newPage',
  );
  h = h.replaceAll(
    '<meta property="og:title" content="Conférences — Serigne Moustapha Saliou — Diiwaanu Xassida Yi">',
    '<meta property="og:title" content="Conférences — Serigne Saliou Sow — Diiwaanu Xassida Yi">',
  );
  h = h.replaceAll(
    '<meta property="og:description" content="Les conférences de Serigne Moustapha Saliou à écouter en ligne, sans compte ni publicité.">',
    '<meta property="og:description" content="Les conférences de Serigne Saliou Sow à écouter en ligne, sans compte ni publicité.">',
  );
  h = h.replaceAll(
    '<meta property="og:image" content="https://www.diiwaanu-xassida-yi.com/assets/conferences/serigne-moustapha-saliou.jpg">',
    '<meta property="og:image" content="https://www.diiwaanu-xassida-yi.com/assets/conferences/serigne-saliou-sow.png">',
  );
  h = h.replaceAll('<body id="haut" class="conf-page">', '<body id="haut" class="conf-page conf-saliou">');

  h = h.replaceAll(
    '<h1>Serigne Moustapha Saliou<br><span>en conférences</span></h1>',
    '<h1>Serigne Saliou Sow<br><span>en conférences</span></h1>',
  );
  h = h.replaceAll(
    '<p class="lead">Écoutez les enregistrements de Serigne Moustapha Saliou en ligne, sans compte ni publicité.</p>',
    '<p class="lead">Écoutez les enregistrements de Serigne Saliou Sow en ligne, sans compte ni publicité.</p>',
  );
  h = h.replaceAll(
    '<a class="btn btn-gold-outline" href="media.html">Voir les autres médias</a>',
    '<a class="btn btn-gold-outline" href="conferences.html">Conférences de S. Moustapha Saliou</a>',
  );

  h = h.replaceAll(
    '<li><a href="conferences.html" aria-current="page">Conférences — S. Moustapha Saliou</a></li>',
    '<li><a href="conferences.html">Conférences — S. Moustapha Saliou</a></li>',
  );
  h = h.replaceAll(
    '<li><a href="$newPage">Conférences — S. Saliou Sow</a></li>',
    '<li><a href="$newPage" aria-current="page">Conférences — S. Saliou Sow</a></li>',
  );

  h = h.replaceAll(
    '<img src="assets/conferences/serigne-moustapha-saliou.jpg" alt="Portrait de Serigne Moustapha Saliou">',
    '<img src="assets/conferences/serigne-saliou-sow.png" alt="Portrait de Serigne Saliou Sow">',
  );
  h = h.replaceAll(
    '<h2>Les conférences de Serigne Moustapha Saliou</h2>',
    '<h2>Les conférences de Serigne Saliou Sow</h2>',
  );
  h = h.replaceAll(
    '<p>Retrouvez ici les enregistrements de Serigne Moustapha Saliou, réunis pour une écoute calme et sans distraction.</p>',
    '<p>Retrouvez ici trente-six enregistrements de Serigne Saliou Sow, réunis pour une écoute calme et sans distraction.</p>',
  );
  h = h.replaceAll(
    '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a> <a class="btn btn-gold-outline" href="$newPage">Conférences de S. Saliou Sow →</a></div>',
    '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a> <a class="btn btn-gold-outline" href="conferences.html">Conférences de S. Moustapha Saliou →</a></div>',
  );
  h = h.replaceAll(
    'aria-label="Lecteur des conférences de Serigne Moustapha Saliou"',
    'aria-label="Lecteur des conférences de Serigne Saliou Sow"',
  );
  h = h.replaceAll(
    'aria-label="Playlist des conférences de Serigne Moustapha Saliou"',
    'aria-label="Playlist des conférences de Serigne Saliou Sow"',
  );

  h = h.replaceAll(RegExp(r'<ol id="playlist".*?</ol>', dotAll: true), '''<ol id="playlist" class="playlist conf-playlist" aria-label="Playlist des conférences de Serigne Saliou Sow">
${playlistRows()}
      </ol>''');
  return h;
}

void patchCss() {
  final file = File('$siteDir\\assets\\css\\site.css');
  var css = file.readAsStringSync(encoding: utf8);
  if (css.contains('.conf-saliou .conf-header')) return;
  css += r'''

/* ---------- Conférences de Serigne Saliou Sow : même structure, photo dédiée ---------- */
.conf-saliou .conf-header {
  background-image:
    radial-gradient(circle at 88% 0%, rgba(201,154,46,.22), transparent 42%),
    linear-gradient(180deg, rgba(6, 30, 19, .34), rgba(6, 30, 19, .76)),
    url("../conferences/serigne-saliou-sow.png"),
    linear-gradient(155deg, var(--night), var(--green-2) 70%, var(--night-2));
  background-position: center, center, center 38%, center;
}
.conf-saliou .conf-stage {
  background-image:
    linear-gradient(180deg, rgba(6, 30, 19, .30), rgba(6, 30, 19, .78) 62%, rgba(6, 30, 19, .90)),
    url("../conferences/serigne-saliou-sow.png");
}
''';
  file.writeAsStringSync(css, encoding: utf8, flush: true);
  stdout.writeln('CSS : variante conf-saliou ajoutée');
}

void patchSitemap() {
  final file = File('$siteDir\\sitemap.xml');
  var xml = file.readAsStringSync(encoding: utf8);
  if (xml.contains(newPage)) return;
  xml = xml.replaceFirst('</urlset>', '''  <url>
    <loc>https://www.diiwaanu-xassida-yi.com/$newPage</loc>
    <lastmod>2026-11-26</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>
</urlset>''');
  file.writeAsStringSync(xml, encoding: utf8, flush: true);
  stdout.writeln('Sitemap : $newPage ajouté');
}

void patchSearch() {
  final file = File('$siteDir\\assets\\js\\search-data.js');
  var js = file.readAsStringSync(encoding: utf8);
  if (js.contains('"url":"$newPage"')) return;
  js = js.replaceFirst(
    'window.DIIWAANU_SEARCH_INDEX = [',
    'window.DIIWAANU_SEARCH_INDEX = [{"kind":"Page","title":"Conférences — Serigne Saliou Sow","text":"Trente-six conférences de Serigne Saliou Sow à écouter en ligne, sans compte ni publicité.","url":"$newPage","external":false},',
  );
  file.writeAsStringSync(js, encoding: utf8, flush: true);
  stdout.writeln('Recherche : entrée Serigne Saliou Sow ajoutée');
}

void patchAudit() {
  final file = File('$siteDir\\tools\\audit_site.dart');
  var dart = file.readAsStringSync(encoding: utf8);
  dart = dart.replaceAll("if (files.length != 24)", "if (files.length != 25)")
      .replaceAll("PAGES ATTENDUES : 24, trouvé", "PAGES ATTENDUES : 25, trouvé")
      .replaceAll("if (locs.length != 24)", "if (locs.length != 25)")
      .replaceAll("SITEMAP ATTENDU : 24 URL, trouvé", "SITEMAP ATTENDU : 25 URL, trouvé");
  if (!dart.contains("saliouPage")) {
    const anchor = '''  if (RegExp(r'<audio\\b').allMatches(confPage).length != 1) {
    stdout.writeln('CONFERENCES : le lecteur unique est attendu');
    problems++;
  }
''';
    const addition = '''  if (RegExp(r'<audio\\b').allMatches(confPage).length != 1) {
    stdout.writeln('CONFERENCES : le lecteur unique est attendu');
    problems++;
  }
  final saliouPage = read('conferences-saliou-sow.html');
  final saliouCount = 'class="playlist-row"'.allMatches(saliouPage).length;
  if (saliouCount != 36) {
    stdout.writeln('SALIOU SOW pistes : \$saliouCount (attendu 36)');
    problems++;
  }
  final saliouCss = read('assets/css/site.css');
  if (!saliouPage.contains('id="conferences"') ||
      !saliouPage.contains('id="playlist"') ||
      !saliouPage.contains('id="saliou-piste-01"') ||
      !saliouPage.contains('id="saliou-piste-36"') ||
      !saliouPage.contains('assets/conferences/serigne-saliou-sow.png') ||
      !saliouCss.contains('.conf-saliou .conf-header') ||
      !saliouCss.contains('serigne-saliou-sow.png')) {
    stdout.writeln('SALIOU SOW : page dédiée incomplète');
    problems++;
  }
  if (!saliouPage.contains('/CONFERENCES_SALIOU_SOW/s._saliou_sow_-_01.mp3') ||
      !saliouPage.contains('/CONFERENCES_SALIOU_SOW/s._saliou_sow_-_36.mp3')) {
    stdout.writeln('SALIOU SOW : URLs R2 manquantes');
    problems++;
  }
  if (RegExp(r'<audio\\b').allMatches(saliouPage).length != 1) {
    stdout.writeln('SALIOU SOW : le lecteur unique est attendu');
    problems++;
  }
''';
    dart = dart.replaceFirst(anchor, addition);
  }
  file.writeAsStringSync(dart, encoding: utf8, flush: true);
  stdout.writeln('Audit : attentes 25 pages et 36 pistes Saliou Sow');
}

void patchMemo() {
  final file = File('$siteDir\\DEMARRAGE.md');
  var md = file.readAsStringSync(encoding: utf8);
  md = md.replaceAll('Navigation déployée sur les 24 pages', 'Navigation déployée sur les 25 pages');
  md = md.replaceAll('838 entrées générées', '839 entrées générées');
  if (!md.contains('`conferences-saliou-sow.html`')) {
    md = md.replaceFirst(
      '- `index.html` : six boutons mourides',
      '- `conferences-saliou-sow.html` : trente-six conférences de Serigne Saliou Sow, même structure que `conferences.html` (photo dédiée, un seul lecteur, playlist R2 `CONFERENCES_SALIOU_SOW/`, aucun téléchargement).\n- `index.html` : six boutons mourides',
    );
  }
  file.writeAsStringSync(md, encoding: utf8, flush: true);
  stdout.writeln('Mémo : page Saliou Sow documentée');
}

void patchHomeButton() {
  final file = File('$siteDir\\index.html');
  var html = file.readAsStringSync(encoding: utf8);
  if (html.contains('href="$newPage"') &&
      html.contains('mouride-btn-num" aria-hidden="true">07')) return;
  const conferenceButton = '<a class="mouride-btn" href="conferences.html"><span class="mouride-btn-num" aria-hidden="true">06</span><span>Conférences</span></a>';
  if (!html.contains(conferenceButton)) {
    stdout.writeln('ACCUEIL : bouton Conférences introuvable');
    return;
  }
  html = html.replaceFirst(conferenceButton, '''$conferenceButton
        <a class="mouride-btn" href="$newPage" aria-label="Conférences de Serigne Saliou Sow"><span class="mouride-btn-num" aria-hidden="true">07</span><span>Conférences — S. Saliou Sow</span></a>''');
  file.writeAsStringSync(html, encoding: utf8, flush: true);
  stdout.writeln('Accueil : bouton « Conférences — S. Saliou Sow » ajouté');
}

void main() {
  patchNavigation();
  patchHomeButton();
  write(newPage, buildPage());
  patchCss();
  patchSitemap();
  patchSearch();
  patchAudit();
  patchMemo();
  stdout.writeln('Terminé : ${titres.length} pistes Serigne Saliou Sow');
}
