// Construit la page des conférences de Serigne Bousso Seck sur le modèle de
// conferences-saliou-sow.html, puis synchronise navigation, styles, sitemap,
// recherche, audit, mémo et cache des assets (biblio51).

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const appDir = r'C:\Users\akman\Documents\khassida_app';
const photoSource =
    r'C:\Users\akman\Downloads\MediaHuman\Musique\Serigne Bousso Seck\serigneboussoseck.png';
const r2Base = 'https://pub-f07ad970b3b84dfa8539a6cf6ce3f5b3.r2.dev';
const newPage = 'conferences-bousso-seck.html';

// Titres repris des noms de fichiers fournis : seuls les signes typographiques
// évidents ont été nettoyés. Les noms propres et les invocations sont conservés.
const titres = <String>[
  'Waxtaan — SERIGNE FALLOU Mbacke ak KAZU RAJAB Ay Mayam',
  'Wakhtanou Serigne Bousso ci Serigne Fallou ak Mafatihoul Bichri',
  'Waxtaan ci Serigne TOUBA par S BOUSSO SECK — Darou Salam',
  'Magal 2020 — Plateau Jaza^-u Shaku^r du 1er Safar — Thème : Serigne Touba ak Boroomam',
  "Magal 2020 — 3e'me Palataux Jaza^ U Shaku^r — S. TOUBA AK ALXURAAN (S. Allassane Diouf & S. Bousso Seck)",
  'S BOUSSO SECK — Kazou Rajab 2021, part 2',
  'S BOUSSO SECK — Kazou Rajab 2021, part 3',
  'Exposé de Serigne Bousso Seck sur l’importance de faire des prières en faveur du Messager',
  'Safar 1446 — Wakhtaanou Serigne Bousso Seck ci Magalou Touba',
  'Waxtaanu S Bousso SECK — Ziara Dekhele 2025, Dahira (Moukhadamatoul Koubra) ak Dahira (Moukha…)',
  'Serigne Touba ak Graatu Khadiimu-Rassoul — Sr. Bousso SECK, Antenne Magal du 11 Safar 1447H',
  'Waajal Bisub Salaatu Alaa Nabi 2025 — Se“rin~ Buso Sekk, Waxtaan ci Ngene’el i Salaatu ` Alaa Nabi',
  'WAAJAL AJJUMAY TUUBAA — SERIGNE BOUSSO SECK',
  'Serigne Touba ak Khassida yi — par Serigne Bousso Seck',
];

String esc(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

String read(String path) => File(path).readAsStringSync(encoding: utf8);

String readSite(String name) => read('$siteDir\\$name');

void write(String path, String content) {
  File(path).writeAsStringSync(content, encoding: utf8, flush: true);
  stdout.writeln('Écrit : ${File(path).uri.pathSegments.last}');
}

void writeSite(String name, String content) => write('$siteDir\\$name', content);

List<File> htmlFiles() => Directory(siteDir)
    .listSync()
    .whereType<File>()
    .where((f) => f.path.toLowerCase().endsWith('.html'))
    .toList();

String replaceOne(String source, String from, String to, String label) {
  if (!source.contains(from)) {
    throw StateError('Marqueur introuvable : $label');
  }
  return source.replaceFirst(from, to);
}

String playlistRows() => List<String>.generate(titres.length, (i) {
      final n = (i + 1).toString().padLeft(2, '0');
      final titre = titres[i];
      final full = 'Conférence $n — Serigne Bousso Seck : $titre';
      final src = '$r2Base/CONFERENCES_BOUSSO_SECK/s._bousso_seck_-_$n.mp3';
      return '''        <li class="playlist-row" id="bousso-piste-$n"
             data-title="${esc(full)}" data-src="$src">
           <button class="playlist-play" type="button" aria-label="Lire : ${esc(full)}"><span aria-hidden="true">▶</span></button>
           <div class="playlist-copy">
             <h3><span class="playlist-num" aria-hidden="true">$n</span>${esc(titre)}</h3>
             <p class="playlist-duration">Serigne Bousso Seck · MP3</p>
           </div>
         </li>''';
    }).join('\n');

void dedupeNavigation() {
  for (final file in htmlFiles()) {
    final html = file.readAsStringSync(encoding: utf8);
    final eol = html.contains('\r\n') ? '\r\n' : '\n';
    final output = <String>[];
    for (final line in html.split(RegExp(r'\r?\n'))) {
      if (output.isNotEmpty &&
          line.contains('conferences-bousso-seck.html') &&
          output.last.contains('conferences-bousso-seck.html') &&
          line.trim() == output.last.trim()) {
        continue;
      }
      output.add(line);
    }
    file.writeAsStringSync(output.join(eol), encoding: utf8, flush: true);
  }
  stdout.writeln('Navigation : doublons de liens Bousso Seck retirés');
}

void patchNavigation() {
  const boussoLink =
      '<a href="conferences-bousso-seck.html">Conférences — S. Bousso Seck</a>';
  final saliouAnchor = RegExp(
    r'<a href="conferences-saliou-sow\.html"(?: aria-current="page")?>Conférences — S\. Saliou Sow</a>',
  );

  for (final file in htmlFiles()) {
    final name = file.uri.pathSegments.last;
    if (name == newPage) continue;
    var html = file.readAsStringSync(encoding: utf8);
    final eol = html.contains('\r\n') ? '\r\n' : '\n';
    final lines = html.split(RegExp(r'\r?\n'));
    final output = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      output.add(line);
      if (line.contains('conferences-bousso-seck.html')) continue;
      if (i + 1 < lines.length &&
          lines[i + 1].contains('conferences-bousso-seck.html')) {
        continue;
      }
      final isSubmenu = line.contains('href="conferences-saliou-sow.html"') &&
          line.contains('Serigne Saliou Sow');
      final match = saliouAnchor.firstMatch(line);
      if (!isSubmenu && match == null) continue;
      final indent = RegExp(r'^\s*').firstMatch(line)?.group(0) ?? '';

      if (isSubmenu) {
        output.add(
          '$indent<a href="conferences-bousso-seck.html">'
          '<span class="mouride-sub-num" aria-hidden="true">03</span>'
          '<span>Serigne Bousso Seck</span></a>',
        );
        continue;
      }
      final anchor = match!.group(0)!;
      if (line.trimLeft().startsWith('<li>')) {
        output.add('$indent<li>$boussoLink</li>');
      } else if (line.contains('$anchor · ')) {
        output[output.length - 1] =
            line.replaceFirst(anchor, '$anchor · $boussoLink');
      } else {
        output.add('$indent$boussoLink');
      }
    }

    file.writeAsStringSync(output.join(eol), encoding: utf8, flush: true);
  }

  // Liens internes des deux pages de conférences déjà publiées.
  var moustapha = readSite('conferences.html');
  const moustaphaIntro =
      '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a></div>';
  if (moustapha.contains(moustaphaIntro)) {
    moustapha = moustapha.replaceFirst(
      moustaphaIntro,
      '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a> '
      '<a class="btn btn-gold-outline" href="$newPage">Conférences de S. Bousso Seck →</a></div>',
    );
    writeSite('conferences.html', moustapha);
  }

  var saliou = readSite('conferences-saliou-sow.html');
  const saliouIntro =
      '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a></div>';
  if (saliou.contains(saliouIntro)) {
    saliou = saliou.replaceFirst(
      saliouIntro,
      '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a> '
      '<a class="btn btn-gold-outline" href="conferences.html">Conférences de S. Moustapha Saliou →</a> '
      '<a class="btn btn-gold-outline" href="$newPage">Conférences de S. Bousso Seck →</a></div>',
    );
    writeSite('conferences-saliou-sow.html', saliou);
  }

  // La rubrique « Conférences » de La Voie Mouride présente les trois séries.
  var voie = readSite('voie-mouride.html');
  const voieLinks =
      '<div class="links"><a class="btn btn-gold" href="conferences.html">Ouvrir la page Conférences →</a></div>';
  if (voie.contains(voieLinks)) {
    voie = voie.replaceFirst(
      voieLinks,
      '<div class="links"><a class="btn btn-gold" href="conferences.html">S. Moustapha Saliou →</a> '
      '<a class="btn btn-gold-outline" href="conferences-saliou-sow.html">S. Saliou Sow →</a> '
      '<a class="btn btn-gold-outline" href="$newPage">S. Bousso Seck →</a></div>',
    );
    writeSite('voie-mouride.html', voie);
  }
}

String buildPage() {
  var h = readSite('conferences-saliou-sow.html');

  h = h.replaceAll(
    'https://www.diiwaanu-xassida-yi.com/conferences-saliou-sow.html',
    'https://www.diiwaanu-xassida-yi.com/$newPage',
  );
  h = replaceOne(
    h,
    '<title>Conférences — Serigne Saliou Sow — Diiwaanu Xassida Yi</title>',
    '<title>Conférences — Serigne Bousso Seck — Diiwaanu Xassida Yi</title>',
    'title',
  );
  h = replaceOne(
    h,
    '<meta name="description" content="Les conférences de Serigne Saliou Sow à écouter en ligne, sans compte ni publicité.">',
    '<meta name="description" content="Les conférences de Serigne Bousso Seck à écouter en ligne, sans compte ni publicité.">',
    'description',
  );
  h = replaceOne(
    h,
    '<meta property="og:title" content="Conférences — Serigne Saliou Sow — Diiwaanu Xassida Yi">',
    '<meta property="og:title" content="Conférences — Serigne Bousso Seck — Diiwaanu Xassida Yi">',
    'og:title',
  );
  h = replaceOne(
    h,
    '<meta property="og:description" content="Les conférences de Serigne Saliou Sow à écouter en ligne, sans compte ni publicité.">',
    '<meta property="og:description" content="Les conférences de Serigne Bousso Seck à écouter en ligne, sans compte ni publicité.">',
    'og:description',
  );
  h = replaceOne(
    h,
    '<meta property="og:image" content="https://www.diiwaanu-xassida-yi.com/assets/conferences/serigne-saliou-sow.png">',
    '<meta property="og:image" content="https://www.diiwaanu-xassida-yi.com/assets/conferences/serigneboussoseck.png">',
    'og:image',
  );
  h = replaceOne(
    h,
    '<body id="haut" class="conf-page conf-saliou">',
    '<body id="haut" class="conf-page conf-bousso">',
    'body',
  );
  h = replaceOne(
    h,
    '<h1>Serigne Saliou Sow<br><span>en conférences</span></h1>',
    '<h1>Serigne Bousso Seck<br><span>en conférences</span></h1>',
    'h1',
  );
  h = replaceOne(
    h,
    '<p class="lead">Écoutez les enregistrements de Serigne Saliou Sow en ligne, sans compte ni publicité.</p>',
    '<p class="lead">Écoutez les enregistrements de Serigne Bousso Seck en ligne, sans compte ni publicité.</p>',
    'lead',
  );
  h = replaceOne(
    h,
    '<li><a href="conferences-saliou-sow.html" aria-current="page">Conférences — S. Saliou Sow</a></li>',
    '<li><a href="conferences-saliou-sow.html">Conférences — S. Saliou Sow</a></li>',
    'menu Saliou',
  );
  h = replaceOne(
    h,
    '<li><a href="conferences-bousso-seck.html">Conférences — S. Bousso Seck</a></li>',
    '<li><a href="conferences-bousso-seck.html" aria-current="page">Conférences — S. Bousso Seck</a></li>',
    'menu Bousso',
  );
  h = replaceOne(
    h,
    '<img src="assets/conferences/serigne-saliou-sow.png" alt="Portrait de Serigne Saliou Sow">',
    '<img src="assets/conferences/serigneboussoseck.png" alt="Portrait de Serigne Bousso Seck">',
    'portrait',
  );
  h = replaceOne(
    h,
    '<h2>Les conférences de Serigne Saliou Sow</h2>',
    '<h2>Les conférences de Serigne Bousso Seck</h2>',
    'intro h2',
  );
  h = replaceOne(
    h,
    '<p>Retrouvez ici trente-six enregistrements de Serigne Saliou Sow, réunis pour une écoute calme et sans distraction.</p>',
    '<p>Retrouvez ici quatorze enregistrements de Serigne Bousso Seck, réunis pour une écoute calme et sans distraction.</p>',
    'intro texte',
  );
  h = replaceOne(
    h,
    ' <a class="btn btn-gold-outline" href="conferences-bousso-seck.html">Conférences de S. Bousso Seck →</a>',
    ' <a class="btn btn-gold-outline" href="conferences-saliou-sow.html">Conférences de S. Saliou Sow →</a>',
    'intro lien',
  );
  h = replaceOne(
    h,
    'aria-label="Lecteur des conférences de Serigne Saliou Sow"',
    'aria-label="Lecteur des conférences de Serigne Bousso Seck"',
    'lecteur',
  );
  h = replaceOne(
    h,
    'aria-label="Playlist des conférences de Serigne Saliou Sow"',
    'aria-label="Playlist des conférences de Serigne Bousso Seck"',
    'playlist',
  );

  final playlist = RegExp(r'<ol id="playlist".*?</ol>', dotAll: true);
  if (!playlist.hasMatch(h)) throw StateError('Playlist introuvable');
  h = h.replaceFirst(
    playlist,
    '<ol id="playlist" class="playlist conf-playlist" aria-label="Playlist des conférences de Serigne Bousso Seck">\n'
    '${playlistRows()}\n      </ol>',
  );
  return h;
}

void copyPhoto() {
  final source = File(photoSource);
  if (!source.existsSync()) throw StateError('Photo introuvable : $photoSource');
  source.copySync('$siteDir\\assets\\conferences\\serigneboussoseck.png');
  source.copySync('$appDir\\assets\\conferences\\serigneboussoseck.png');
  stdout.writeln('Photo copiée dans le site et dans l’application');
}

void patchCss() {
  final path = '$siteDir\\assets\\css\\site.css';
  var css = read(path);
  if (css.contains('.conf-bousso .conf-header')) return;
  css += r'''

/* ---------- Conférences de Serigne Bousso Seck : même structure, photo dédiée ---------- */
.conf-bousso .conf-header {
  background-image:
    radial-gradient(circle at 88% 0%, rgba(201,154,46,.22), transparent 42%),
    linear-gradient(180deg, rgba(6, 30, 19, .34), rgba(6, 30, 19, .76)),
    url("../conferences/serigneboussoseck.png"),
    linear-gradient(155deg, var(--night), var(--green-2) 70%, var(--night-2));
  background-position: center, center, center 38%, center;
}
.conf-bousso .conf-stage {
  background-image:
    linear-gradient(180deg, rgba(6, 30, 19, .30), rgba(6, 30, 19, .78) 62%, rgba(6, 30, 19, .90)),
    url("../conferences/serigneboussoseck.png");
}
''';
  write(path, css);
  stdout.writeln('CSS : variante conf-bousso ajoutée');
}

void patchSitemap() {
  final path = '$siteDir\\sitemap.xml';
  var xml = read(path);
  if (xml.contains(newPage)) return;
  xml = xml.replaceFirst(
    '</urlset>',
    '''  <url>
    <loc>https://www.diiwaanu-xassida-yi.com/$newPage</loc>
    <lastmod>2026-11-28</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>
</urlset>''',
  );
  write(path, xml);
  stdout.writeln('Sitemap : $newPage ajouté');
}

void patchSearch() {
  final path = '$siteDir\\assets\\js\\search-data.js';
  var js = read(path);
  if (js.contains('"url":"$newPage"')) return;
  final entry = jsonEncode({
    'kind': 'Page',
    'title': 'Conférences — Serigne Bousso Seck',
    'text':
        'Quatorze conférences de Serigne Bousso Seck à écouter en ligne, sans compte ni publicité.',
    'url': newPage,
    'external': false,
  });
  js = js.replaceFirst(
    'window.DIIWAANU_SEARCH_INDEX = [',
    'window.DIIWAANU_SEARCH_INDEX = [$entry,',
  );
  write(path, js);
  stdout.writeln('Recherche : entrée Serigne Bousso Seck ajoutée');
}

void patchAudit() {
  final path = '$siteDir\\tools\\audit_site.dart';
  var dart = read(path);
  dart = dart
      .replaceAll('if (files.length != 25)', 'if (files.length != 26)')
      .replaceAll('PAGES ATTENDUES : 25, trouvé', 'PAGES ATTENDUES : 26, trouvé')
      .replaceAll('if (locs.length != 25)', 'if (locs.length != 26)')
      .replaceAll('SITEMAP ATTENDU : 25 URL, trouvé', 'SITEMAP ATTENDU : 26 URL, trouvé');
  if (!dart.contains('final boussoPage')) {
    const anchor = "  if (!voieInfos.contains('href=\"conferences.html\"')) {";
    const addition = r'''  final boussoPage = read('conferences-bousso-seck.html');
  final boussoCount = 'class="playlist-row"'.allMatches(boussoPage).length;
  if (boussoCount != 14) {
    stdout.writeln('BOUSSO SECK pistes : $boussoCount (attendu 14)');
    problems++;
  }
  final boussoCss = read('assets/css/site.css');
  if (!boussoPage.contains('id="conferences"') ||
      !boussoPage.contains('id="playlist"') ||
      !boussoPage.contains('id="bousso-piste-01"') ||
      !boussoPage.contains('id="bousso-piste-14"') ||
      !boussoPage.contains('assets/conferences/serigneboussoseck.png') ||
      !boussoCss.contains('.conf-bousso .conf-header') ||
      !boussoCss.contains('serigneboussoseck.png')) {
    stdout.writeln('BOUSSO SECK : page dédiée incomplète');
    problems++;
  }
  if (!boussoPage.contains('/CONFERENCES_BOUSSO_SECK/s._bousso_seck_-_01.mp3') ||
      !boussoPage.contains('/CONFERENCES_BOUSSO_SECK/s._bousso_seck_-_14.mp3')) {
    stdout.writeln('BOUSSO SECK : URLs R2 manquantes');
    problems++;
  }
  if (RegExp(r'<audio\b').allMatches(boussoPage).length != 1) {
    stdout.writeln('BOUSSO SECK : le lecteur unique est attendu');
    problems++;
  }
''';
    dart = dart.replaceFirst(anchor, '$addition$anchor');
  }
  write(path, dart);
  stdout.writeln('Audit : attentes 26 pages et 14 pistes Bousso Seck');
}

void patchMemo() {
  final path = '$siteDir\\DEMARRAGE.md';
  var md = read(path);
  md = md.replaceAll('25 pages, 25 URL', '26 pages, 26 URL');
  md = md.replaceAll('25 pages · 25 URL', '26 pages · 26 URL');
  md = md.replaceAll('23 pages · 23 URL', '26 pages · 26 URL');
  md = md.replaceAll('836 entrées générées', '837 entrées générées');
  md = md.replaceAll('Navigation déployée sur les 25 pages', 'Navigation déployée sur les 26 pages');
  if (!md.contains('`conferences-bousso-seck.html`')) {
    md = md.replaceFirst(
      '- `index.html` : six boutons mourides',
      '- `conferences-bousso-seck.html` : quatorze conférences de Serigne Bousso Seck, même structure que '
      '`conferences.html` (photo fournie dans le dossier audio, un seul lecteur, playlist R2 '
      '`CONFERENCES_BOUSSO_SECK/`, aucun téléchargement).\n'
      '- `index.html` : six boutons mourides',
    );
  }
  md = md.replaceAll(
    'deux entrées : « Serigne Moustapha Saliou » (`conferences.html`, 22 MP3, préfixe R2 `CONFERENCES/`) et « Serigne Saliou Sow » (`conferences-saliou-sow.html`, 36 MP3, préfixe R2 `CONFERENCES_SALIOU_SOW/`) ; lecteur unique et aucun téléchargement.',
    'trois entrées : « Serigne Moustapha Saliou » (`conferences.html`, 22 MP3, préfixe R2 `CONFERENCES/`), '
    '« Serigne Saliou Sow » (`conferences-saliou-sow.html`, 36 MP3, préfixe R2 `CONFERENCES_SALIOU_SOW/`) et '
    '« Serigne Bousso Seck » (`conferences-bousso-seck.html`, 14 MP3, préfixe R2 `CONFERENCES_BOUSSO_SECK/`) ; '
    'lecteur unique et aucun téléchargement.',
  );
  write(path, md);
  stdout.writeln('Mémo : page Bousso Seck documentée');
}

void bumpCache() {
  final extensions = {'html', 'dart', 'js', 'md'};
  var changed = 0;
  for (final entity in Directory(siteDir).listSync(recursive: true)) {
    if (entity is! File ||
        !extensions.contains(entity.uri.pathSegments.last.split('.').last)) {
      continue;
    }
    if (entity.path.contains('${Platform.pathSeparator}pdfs${Platform.pathSeparator}') ||
        entity.path.contains('${Platform.pathSeparator}build${Platform.pathSeparator}')) {
      continue;
    }
    final content = entity.readAsStringSync(encoding: utf8);
    if (!content.contains('biblio51')) continue;
    entity.writeAsStringSync(
      content.replaceAll('biblio51', 'biblio51'),
      encoding: utf8,
      flush: true,
    );
    changed++;
  }
  for (final relative in <String>[
    'tools\\generate_site_pages.dart',
    'store\\site\\nafila-du-jour.html',
    'store\\site\\99-noms.html',
    'DEMARRAGE.md',
  ]) {
    final file = File('$appDir\\$relative');
    if (!file.existsSync()) continue;
    final content = file.readAsStringSync(encoding: utf8);
    if (!content.contains('biblio51')) continue;
    file.writeAsStringSync(
      content.replaceAll('biblio51', 'biblio51'),
      encoding: utf8,
      flush: true,
    );
    changed++;
  }
  stdout.writeln('Cache : biblio51 sur $changed fichiers');
}

void main() {
  if (titres.length != 14) throw StateError('14 pistes attendues');
  copyPhoto();
  dedupeNavigation();
  patchNavigation();
  writeSite(newPage, buildPage());
  patchCss();
  patchSitemap();
  patchSearch();
  patchAudit();
  patchMemo();
  bumpCache();
  stdout.writeln('Terminé : 14 pistes Serigne Bousso Seck');
}
