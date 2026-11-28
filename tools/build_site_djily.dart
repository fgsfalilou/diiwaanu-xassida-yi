// Construit la page des conférences de Serigne Djily Mbacke sur le
// modèle de conferences-bousso-seck.html, puis synchronise navigation, styles,
// sitemap, recherche, audit, mémo et cache des assets (biblio52).

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const appDir = r'C:\Users\akman\Documents\khassida_app';
const photoSource =
    r"C:\Users\akman\Downloads\MediaHuman\Musique\Serigne Djily Kosso Mbacke\Capture d'écran 2026-11-28 094349.png";
const r2Base = 'https://pub-f07ad970b3b84dfa8539a6cf6ce3f5b3.r2.dev';
const newPage = 'conferences-djily-mbacke.html';
const speaker = 'Serigne Djily Mbacke';
const shortSpeaker = 'S. Djily Mbacke';
const photoName = 'serignedjilymbacke.png';
const prefix = 'CONFERENCES_DJILY_MBACKE';

const titresDjilyMbacke = <String>[
  "Thiey! Wakhtane wou ye'me' si Serigne Touba Pr Serigne Djily Mbacke' Chez Serigne Hamzatou Dialibatou",
  "WAKHTANE SERIGNE DJILY MBACKE' KOSSO JOURNE'E KHASSIDA NGAYE 2024",
  "Thiey! Wakhtane Serigne Touba Ak Khassida par. Serigne Djily Mbacke' Kosso Bissou Khassida UCAD 2025",
  "Thieyy Wakhtane Wu am solo Serigne Djily Mbacke' Kosso — Journe'e Xassida Touba Koul — Edition 2025",
  "THIEY! WAKHTANE SERIGNE DJILY KOSSO, SERIGNE TOUBA LIM DEF SI KHASSIDA YI HISTOIRE JAMAIS RACONTE",
  "Allahou Akbar — Serigne Djily Mbacke Koso — Les secrets cache's derrie`re les Khassida",
  "Allahou Akbar Serigne Djily Mbacke Koso Waxtaan wu Ye'eme ci Serigne Touba Thiey",
  "Thieyy Borom Touba Ye'eme' na Wakhtane Serigne Djily Mbacke' Kosso — Journe'e Xassida Touba Risso....",
  "Ndeysan serigne djily koso waxtaan bu am solo si serigne touba",
  "Alahou Akbar Serigne Touba ak Zikar Wakhtane Serigne Djily Mbacke' Kosso Pre' Grande Journe'e Khassida",
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

final bassirouPlain = RegExp(
  r'<a href="conferences-bassirou-mbacke\.html"(?: aria-current="page")?>Conférences — S\. Bassirou Mbacke</a>',
);
const bassirouSub =
    '<a href="conferences-bassirou-mbacke.html"><span class="mouride-sub-num" aria-hidden="true">04</span><span>Serigne Bassirou Mbacke Xelcome</span></a>';
const newPlain =
    '<a href="conferences-djily-mbacke.html">Conférences — S. Djily Mbacke</a>';
const newSub =
    '<a href="conferences-djily-mbacke.html"><span class="mouride-sub-num" aria-hidden="true">05</span><span>Serigne Djily Mbacke</span></a>';

String addLinks(String html) {
  final lines = html.split(RegExp(r'\r?\n'));
  final output = <String>[];
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    output.add(line);
    if (line.contains(newPage)) continue;
    if (i + 1 < lines.length && lines[i + 1].contains(newPage)) continue;
    if (line.contains('<div class="links">')) continue;

    final indent = RegExp(r'^\s*').firstMatch(line)?.group(0) ?? '';
    if (line.contains(bassirouSub)) {
      output.add('$indent$newSub');
      continue;
    }
    final match = bassirouPlain.firstMatch(line);
    if (match == null) continue;
    if (line.trimLeft().startsWith('<li>')) {
      output.add('$indent<li>$newPlain</li>');
    } else if (line.contains('${match.group(0)} · ')) {
      output[output.length - 1] =
          line.replaceFirst(match.group(0)!, '${match.group(0)} · $newPlain');
    } else {
      output.add('$indent$newPlain');
    }
  }
  return output.join('\n');
}

String playlistRows() => List<String>.generate(titresDjilyMbacke.length, (i) {
      final n = (i + 1).toString().padLeft(2, '0');
      final titre = titresDjilyMbacke[i];
      final full = 'Conférence $n — $speaker : $titre';
      final src = '$r2Base/$prefix/s._djily_mbacke_-_$n.mp3';
      return '''        <li class="playlist-row" id="djily-piste-$n"
             data-title="${esc(full)}" data-src="$src">
           <button class="playlist-play" type="button" aria-label="Lire : ${esc(full)}"><span aria-hidden="true">▶</span></button>
           <div class="playlist-copy">
             <h3><span class="playlist-num" aria-hidden="true">$n</span>${esc(titre)}</h3>
             <p class="playlist-duration">$speaker · MP3</p>
           </div>
         </li>''';
    }).join('\n');

void patchNavigation() {
  for (final file in htmlFiles()) {
    final name = file.uri.pathSegments.last;
    if (name == newPage) continue;
    final html = file.readAsStringSync(encoding: utf8);
    final updated = addLinks(html);
    if (updated != html) {
      file.writeAsStringSync(updated, encoding: utf8, flush: true);
    }
  }
  stdout.writeln('Navigation : lien $newPage ajouté sur les pages existantes');

  const newBtn =
      '<a class="btn btn-gold-outline" href="conferences-djily-mbacke.html">Conférences de S. Djily Mbacke →</a>';
  for (final page in [
    'conferences.html',
    'conferences-saliou-sow.html',
    'conferences-bousso-seck.html',
    'conferences-bassirou-mbacke.html',
  ]) {
    var html = readSite(page);
    if (html.contains(newPage)) continue;
    final lines = html.split(RegExp(r'\r?\n'));
    var done = false;
    for (var i = 0; i < lines.length; i++) {
      if (!lines[i].contains('<div class="links">') ||
          !lines[i].contains('href="audio.html"')) {
        continue;
      }
      lines[i] = lines[i].replaceFirst('</div>', ' $newBtn</div>');
      done = true;
      break;
    }
    if (!done) throw StateError('Liens intro introuvables dans $page');
    writeSite(page, lines.join('\n'));
  }

  var voie = readSite('voie-mouride.html');
  const voieAnchor =
      '<a class="btn btn-gold-outline" href="conferences-bassirou-mbacke.html">S. Bassirou Mbacke →</a>';
  if (voie.contains(voieAnchor) && !voie.contains(newPage)) {
    voie = voie.replaceFirst(
      voieAnchor,
      '$voieAnchor <a class="btn btn-gold-outline" href="$newPage">S. Djily Mbacke →</a>',
    );
    writeSite('voie-mouride.html', voie);
  }
}

String buildPage() {
  var h = readSite('conferences-bousso-seck.html');

  h = h.replaceAll(
    'https://www.diiwaanu-xassida-yi.com/conferences-bousso-seck.html',
    'https://www.diiwaanu-xassida-yi.com/$newPage',
  );
  h = replaceOne(
    h,
    '<title>Conférences — Serigne Bousso Seck — Diiwaanu Xassida Yi</title>',
    '<title>Conférences — $speaker — Diiwaanu Xassida Yi</title>',
    'title',
  );
  for (final meta in [
    '<meta name="description" content="Les conférences de Serigne Bousso Seck à écouter en ligne, sans compte ni publicité.">',
    '<meta property="og:title" content="Conférences — Serigne Bousso Seck — Diiwaanu Xassida Yi">',
    '<meta property="og:description" content="Les conférences de Serigne Bousso Seck à écouter en ligne, sans compte ni publicité.">',
  ]) {
    h = replaceOne(
      h,
      meta,
      meta.replaceAll('Serigne Bousso Seck', speaker),
      'meta',
    );
  }
  h = replaceOne(
    h,
    'https://www.diiwaanu-xassida-yi.com/assets/conferences/serigneboussoseck.png',
    'https://www.diiwaanu-xassida-yi.com/assets/conferences/$photoName',
    'og:image',
  );
  h = replaceOne(
    h,
    '<body id="haut" class="conf-page conf-bousso">',
    '<body id="haut" class="conf-page conf-djily">',
    'body',
  );
  h = replaceOne(
    h,
    '<h1>Serigne Bousso Seck<br><span>en conférences</span></h1>',
    '<h1>$speaker<br><span>en conférences</span></h1>',
    'h1',
  );
  h = replaceOne(
    h,
    '<p class="lead">Écoutez les enregistrements de Serigne Bousso Seck en ligne, sans compte ni publicité.</p>',
    '<p class="lead">Écoutez les enregistrements de $speaker en ligne, sans compte ni publicité.</p>',
    'lead',
  );
  h = replaceOne(
    h,
    '<h2>Les conférences de Serigne Bousso Seck</h2>',
    '<h2>Les conférences de $speaker</h2>',
    'intro h2',
  );
  h = replaceOne(
    h,
    '<p>Retrouvez ici quatorze enregistrements de Serigne Bousso Seck, réunis pour une écoute calme et sans distraction.</p>',
    '<p>Retrouvez ici dix enregistrements de $speaker, réunis pour une écoute calme et sans distraction.</p>',
    'intro texte',
  );
  h = replaceOne(
    h,
    'aria-label="Lecteur des conférences de Serigne Bousso Seck"',
    'aria-label="Lecteur des conférences de $speaker"',
    'lecteur',
  );
  h = replaceOne(
    h,
    'aria-label="Playlist des conférences de Serigne Bousso Seck"',
    'aria-label="Playlist des conférences de $speaker"',
    'playlist',
  );
  h = replaceOne(
    h,
    '<img src="assets/conferences/serigneboussoseck.png" alt="Portrait de Serigne Bousso Seck">',
    '<img src="assets/conferences/$photoName" alt="Portrait de $speaker">',
    'portrait',
  );

  final introLinks = RegExp(
    r'<div class="links">.*?</div>',
    dotAll: true,
  ).firstMatch(h);
  if (introLinks == null) throw StateError('Liens intro introuvables');
  h = h.replaceRange(
    introLinks.start,
    introLinks.end,
    '<div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a> '
    '<a class="btn btn-gold-outline" href="conferences.html">Conférences de S. Moustapha Saliou →</a> '
    '<a class="btn btn-gold-outline" href="conferences-saliou-sow.html">Conférences de S. Saliou Sow →</a> '
    '<a class="btn btn-gold-outline" href="conferences-bousso-seck.html">Conférences de S. Bousso Seck →</a> '
    '<a class="btn btn-gold-outline" href="conferences-bassirou-mbacke.html">Conférences de S. Bassirou Mbacke →</a></div>',
  );

  h = addLinks(h);
  h = h.replaceFirst(
    '<li><a href="conferences-bousso-seck.html" aria-current="page">Conférences — S. Bousso Seck</a></li>',
    '<li><a href="conferences-bousso-seck.html">Conférences — S. Bousso Seck</a></li>',
  );
  h = replaceOne(
    h,
    '<li>$newPlain</li>',
    '<li><a href="$newPage" aria-current="page">Conférences — $shortSpeaker</a></li>',
    'menu courant',
  );

  final playlist = RegExp(r'<ol id="playlist".*?</ol>', dotAll: true);
  if (!playlist.hasMatch(h)) throw StateError('Playlist introuvable');
  h = h.replaceFirst(
    playlist,
    '<ol id="playlist" class="playlist conf-playlist" aria-label="Playlist des conférences de $speaker">\n'
    '${playlistRows()}\n      </ol>',
  );
  return h;
}

void copyPhoto() {
  final source = File(photoSource);
  if (!source.existsSync()) throw StateError('Photo introuvable : $photoSource');
  source.copySync('$siteDir\\assets\\conferences\\$photoName');
  source.copySync('$appDir\\assets\\conferences\\$photoName');
  stdout.writeln('Photo copiée dans le site et dans l’application');
}

void patchCss() {
  final path = '$siteDir\\assets\\css\\site.css';
  var css = read(path);
  if (css.contains('.conf-djily .conf-header')) return;
  css += '''

/* ---------- Conférences de Serigne Djily Mbacke ---------- */
.conf-djily .conf-header {
  background-image:
    radial-gradient(circle at 88% 0%, rgba(201,154,46,.22), transparent 42%),
    linear-gradient(180deg, rgba(6, 30, 19, .34), rgba(6, 30, 19, .76)),
    url("../conferences/$photoName"),
    linear-gradient(155deg, var(--night), var(--green-2) 70%, var(--night-2));
  background-position: center, center, center 38%, center;
}
.conf-djily .conf-stage {
  background-image:
    linear-gradient(180deg, rgba(6, 30, 19, .30), rgba(6, 30, 19, .78) 62%, rgba(6, 30, 19, .90)),
    url("../conferences/$photoName");
}
''';
  write(path, css);
  stdout.writeln('CSS : variante conf-djily ajoutée');
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
    'title': 'Conférences — $speaker',
    'text':
        'Dix conférences de $speaker à écouter en ligne, sans compte ni publicité.',
    'url': newPage,
    'external': false,
  });
  js = js.replaceFirst(
    'window.DIIWAANU_SEARCH_INDEX = [',
    'window.DIIWAANU_SEARCH_INDEX = [$entry,',
  );
  write(path, js);
  stdout.writeln('Recherche : entrée $speaker ajoutée');
}

void patchAudit() {
  final path = '$siteDir\\tools\\audit_site.dart';
  var dart = read(path);
  dart = dart
      .replaceAll('if (files.length != 27)', 'if (files.length != 28)')
      .replaceAll('PAGES ATTENDUES : 27, trouvé', 'PAGES ATTENDUES : 28, trouvé')
      .replaceAll('if (locs.length != 27)', 'if (locs.length != 28)')
      .replaceAll('SITEMAP ATTENDU : 27 URL, trouvé', 'SITEMAP ATTENDU : 28 URL, trouvé');
  if (!dart.contains('final djilyPage')) {
    const anchor = "  if (!voieInfos.contains('href=\"conferences.html\"')) {";
    const addition = r'''  final djilyPage = read('conferences-djily-mbacke.html');
  final djilyCount = 'class="playlist-row"'.allMatches(djilyPage).length;
  if (djilyCount != 10) {
    stdout.writeln('DJILY MBACKE pistes : $djilyCount (attendu 10)');
    problems++;
  }
  final djilyCss = read('assets/css/site.css');
  if (!djilyPage.contains('id="conferences"') ||
      !djilyPage.contains('id="playlist"') ||
      !djilyPage.contains('id="djily-piste-01"') ||
      !djilyPage.contains('id="djily-piste-10"') ||
      !djilyPage.contains('assets/conferences/serignedjilymbacke.png') ||
      !djilyCss.contains('.conf-djily .conf-header') ||
      !djilyCss.contains('serignedjilymbacke.png')) {
    stdout.writeln('DJILY MBACKE : page dédiée incomplète');
    problems++;
  }
  if (!djilyPage.contains('/CONFERENCES_DJILY_MBACKE/s._djily_mbacke_-_01.mp3') ||
      !djilyPage.contains('/CONFERENCES_DJILY_MBACKE/s._djily_mbacke_-_10.mp3')) {
    stdout.writeln('DJILY MBACKE : URLs R2 manquantes');
    problems++;
  }
  if (RegExp(r'<audio\b').allMatches(djilyPage).length != 1) {
    stdout.writeln('DJILY MBACKE : le lecteur unique est attendu');
    problems++;
  }
''';
    dart = dart.replaceFirst(anchor, '$addition$anchor');
  }
  write(path, dart);
  stdout.writeln('Audit : attentes 28 pages et 10 pistes Djily Mbacke');
}

void patchMemo() {
  final path = '$siteDir\\DEMARRAGE.md';
  var md = read(path);
  md = md
      .replaceAll('27 pages, 27 URL', '28 pages, 28 URL')
      .replaceAll('27 pages · 27 URL', '28 pages · 28 URL')
      .replaceAll('838 entrées', '839 entrées')
      .replaceAll('Navigation déployée sur les 27 pages', 'Navigation déployée sur les 28 pages')
      .replaceAll(
        'quatre entrées : « Serigne Moustapha Saliou »',
        'cinq entrées : « Serigne Moustapha Saliou »',
      );
  if (!md.contains('`conferences-djily-mbacke.html`')) {
    md = md.replaceFirst(
      '- `index.html` : six boutons mourides dans l’ordre',
      '- `conferences-djily-mbacke.html` : dix conférences de Serigne Djily Mbacke, '
      'même structure que `conferences.html` (photo fournie dans le dossier audio, un '
      'seul lecteur, playlist R2 `CONFERENCES_DJILY_MBACKE/`, aucun téléchargement).\n'
      '- `index.html` : six boutons mourides dans l’ordre',
    );
    md = md.replaceFirst(
      '`CONFERENCES_BASSIROU_MBACKE/`) ; lecteur unique et aucun téléchargement.',
      '`CONFERENCES_BASSIROU_MBACKE/`) et « Serigne Djily Mbacke » '
      '(`conferences-djily-mbacke.html`, 10 MP3, préfixe R2 `CONFERENCES_DJILY_MBACKE/`) ; '
      'lecteur unique et aucun téléchargement.',
    );
  }
  write(path, md);
  stdout.writeln('Mémo : page Djily Mbacke documentée');
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
    if (!content.contains('biblio52')) continue;
    entity.writeAsStringSync(
      content.replaceAll('biblio52', 'biblio52'),
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
    if (!content.contains('biblio52')) continue;
    file.writeAsStringSync(
      content.replaceAll('biblio52', 'biblio52'),
      encoding: utf8,
      flush: true,
    );
    changed++;
  }
  stdout.writeln('Cache : biblio52 sur $changed fichiers');
}

void main() {
  if (titresDjilyMbacke.length != 10) {
    throw StateError('10 titres attendus');
  }
  copyPhoto();
  patchNavigation();
  writeSite(newPage, buildPage());
  patchCss();
  patchSitemap();
  patchSearch();
  patchAudit();
  patchMemo();
  bumpCache();
  stdout.writeln('Terminé : 10 conférences $speaker');
}
