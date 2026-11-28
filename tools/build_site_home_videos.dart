// Script historique (novembre 2026) : les trois vidéos du projet ont été retirées
// du site le 27 novembre 2026 ; seuls les sept aperçus YouTube restent.
// Ne pas relancer tel quel : il réintroduirait les vidéos supprimées.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const oldVersion = 'biblio33';
const version = 'biblio52';

List<File> htmlFiles() => Directory(siteDir)
    .listSync()
    .whereType<File>()
    .where((f) => f.path.endsWith('.html'))
    .toList();

String read(String name) => File('$siteDir\\$name').readAsStringSync();

void write(String path, String content) {
  File(path).writeAsStringSync(content, flush: true);
  stdout.writeln('Écrit : ${File(path).uri.pathSegments.last}');
}

void bumpVersion() {
  var pages = 0;
  for (final file in htmlFiles()) {
    final before = file.readAsStringSync();
    final after = before.replaceAll(oldVersion, version);
    if (after != before) {
      file.writeAsStringSync(after, flush: true);
      pages++;
    }
  }
  for (final path in <String>[
    r'C:\Users\akman\Documents\khassida_app\tools\generate_site_pages.dart',
    '$siteDir\\DEMARRAGE.md',
    '$siteDir\\tools\\audit_site.dart',
    '$siteDir\\tools\\build_site_videos.dart',
    '$siteDir\\tools\\build_site_youtube_previews.dart',
    r'C:\Users\akman\AppData\Local\Temp\opencode\audit_site_sections.dart',
    r'C:\Users\akman\AppData\Local\Temp\opencode\build_site_updates.dart',
    r'C:\Users\akman\AppData\Local\Temp\opencode\build_site_mouride.dart',
    r'C:\Users\akman\AppData\Local\Temp\opencode\build_site_youtube.dart',
  ]) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final before = file.readAsStringSync();
    final after = before.replaceAll(oldVersion, version);
    if (after != before) {
      file.writeAsStringSync(after, flush: true);
      stdout.writeln('Version : ${file.uri.pathSegments.last}');
    }
  }
  stdout.writeln('Cache mis à jour sur $pages pages');
}

void patchHome() {
  final path = '$siteDir\\index.html';
  var home = File(path).readAsStringSync();
  if (home.contains('id="videos-accueil"')) return;

  final media = read('media.html');
  final videos = RegExp(r'    <section class="nos-videos" id="nos-videos">.*?    </section>\r?\n', dotAll: true)
      .firstMatch(media);
  final chaines = RegExp(r'    <section class="youtube-direct" id="direct-youtube">.*?    </section>\r?\n', dotAll: true)
      .firstMatch(media);
  final oldBloc = RegExp(r'  <section id="actualites-accueil">.*?  </section>\r?\n', dotAll: true)
      .firstMatch(home);
  final nav = RegExp(r'      <nav class="mouride-actions".*?</nav>\r?\n', dotAll: true)
      .firstMatch(home);

  if (videos == null || chaines == null || oldBloc == null || nav == null) {
    stdout.writeln('ACCUEIL : bloc source introuvable');
    return;
  }

  String sansTitre(String bloc) => bloc.replaceFirst(
        RegExp(r'      <div class="section-head">.*?</div>\r?\n', dotAll: true),
        '',
      );

  final nouveau = '''  <section id="videos-accueil">
    <div class="wrap">
      <div class="section-head">
        <span class="kicker">Vidéos</span>
        <h2>Nos vidéos et les directs mourides</h2>
        <p>Regardez les présentations du projet avec le bouton play, puis ouvrez en un clic les directs des chaînes mourides. Aucun lecteur externe n’est chargé sur cette page.</p>
      </div>
${nav.group(0)}${sansTitre(videos.group(0))}${sansTitre(chaines.group(0))}      <p class="note-links">Retrouvez aussi <a href="actualites.html">toutes les actualités</a> et la <a href="media.html">page média</a>.</p>
    </div>
  </section>
''';

  home = home.replaceRange(oldBloc.start, oldBloc.end, nouveau);
  write(path, home);
  stdout.writeln('Accueil : « À la une » remplacé par les vidéos');
}

void patchSearch() {
  final path = '$siteDir\\assets\\js\\search-data.js';
  var js = File(path).readAsStringSync();
  const prefix = 'window.DIIWAANU_SEARCH_INDEX = ';
  if (!js.startsWith(prefix)) {
    stdout.writeln('INDEX : préfixe inattendu');
    return;
  }
  final raw = js.substring(prefix.length).replaceFirst(RegExp(r';\s*$'), '');
  final list = jsonDecode(raw) as List<dynamic>;
  var modifies = 0;
  for (final item in list) {
    if (item is! Map) continue;
    final kind = item['kind'];
    if (kind != 'Vidéo' && kind != 'Chaîne YouTube') continue;
    final url = item['url'] as String?;
    if (url != null && url.startsWith('media.html#')) {
      item['url'] = 'index.html#${url.substring('media.html#'.length)}';
      modifies++;
    }
  }
  write(path, '$prefix${jsonEncode(list)};');
  stdout.writeln('Index recherche : $modifies URL vidéos/chaînes redirigées vers l’accueil');
}

void patchAudit() {
  final path = '$siteDir\\tools\\audit_site.dart';
  var text = File(path).readAsStringSync();
  const oldMarkers = "['id=\"actualites-accueil\"', 'id=\"agenda-accueil\"', 'href=\"agenda.html\"', 'href=\"recherche.html\"']";
  const newMarkers = "['id=\"videos-accueil\"', 'id=\"nos-videos\"', 'id=\"direct-youtube\"', 'id=\"agenda-accueil\"', 'href=\"actualites.html\"', 'href=\"recherche.html\"']";
  if (!text.contains(oldMarkers)) {
    stdout.writeln('AUDIT : marqueurs accueil introuvables');
    return;
  }
  text = text.replaceFirst(oldMarkers, newMarkers);
  const before = "  final voie = read('voie-mouride.html');";
  const ajout = """  if (home.contains('<span class="kicker">À la une</span>')) {
    stdout.writeln('ACCUEIL : bloc « À la une » toujours présent');
    problems++;
  }
  final homeApercus = 'class="youtube-preview"'.allMatches(home).length;
  if (homeApercus != 7) {
    stdout.writeln('ACCUEIL aperçus YouTube : \$homeApercus (attendu 7)');
    problems++;
  }
  if (home.contains('<iframe')) {
    stdout.writeln('ACCUEIL : lecteur intégré détecté');
    problems++;
  }
""";
  if (!text.contains(ajout.split('\n').first.trim())) {
    text = text.replaceFirst(before, ajout + before);
  }
  write(path, text);
}

void patchMemo() {
  final path = '$siteDir\\DEMARRAGE.md';
  var text = File(path).readAsStringSync();
  const marker = '- `media.html#nos-videos` : trois vidéos du projet';
  if (!text.contains(marker)) {
    stdout.writeln('MÉMO : marqueur vidéos introuvable');
    return;
  }
  text = text.replaceFirst(
    marker,
    '- `index.html#videos-accueil` : à la place de l’ancien bloc « À la une », les trois vidéos du projet et les sept aperçus YouTube ; les quatre boutons mourides sont conservés au-dessus. `media.html` garde les mêmes sections.\n$marker',
  );
  text = text.replaceFirst(
    '`tools/build_site_youtube_previews.dart` : scripts historiques',
    '`tools/build_site_youtube_previews.dart`, `tools/build_site_home_videos.dart` : scripts historiques',
  );
  write(path, text);
}

void main() {
  bumpVersion();
  patchHome();
  patchSearch();
  patchAudit();
  patchMemo();
  stdout.writeln('Terminé : $version');
}
