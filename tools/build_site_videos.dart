// Script historique (novembre 2026) : les trois vidéos ont été retirées du site
// et leurs MP4 supprimés de R2 le 27 novembre 2026. Ne pas relancer.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const oldVersion = 'biblio31';
const version = 'biblio51';
const r2Base = 'https://pub-f07ad970b3b84dfa8539a6cf6ce3f5b3.r2.dev';

final videos = <Map<String, String>>[
  {
    'id': 'video-promo-site',
    'title': 'Le site en 28 secondes',
    'text': 'La bibliothèque, la voie mouride, l’audio et la recherche globale en un parcours rapide.',
    'file': 'promo-site.mp4',
    'poster': 'assets/prayer_background.jpg',
    'duration': '≈ 28 s',
  },
  {
    'id': 'video-promo-app',
    'title': 'L’application en 33 secondes',
    'text': 'Les khassaïdes, les prières, les widgets et XAM YOONWI tels qu’ils apparaissent sur le téléphone.',
    'file': 'promo-app.mp4',
    'poster': 'assets/feature-graphic.png',
    'duration': '≈ 33 s',
  },
  {
    'id': 'video-promo-site-et-app',
    'title': 'Le site et l’application',
    'text': 'Les deux projets réunis : le site vitrine et l’application Android, en trente secondes.',
    'file': 'promo-site-et-app.mp4',
    'poster': 'assets/prayer_background.jpg',
    'duration': '≈ 30 s',
  },
];

List<File> htmlFiles() => Directory(siteDir)
    .listSync()
    .whereType<File>()
    .where((f) => f.path.endsWith('.html'))
    .toList();

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

String videoCards() => videos.map((v) {
      return '''        <article class="video-card" id="${v['id']}">
          <div class="video-card-head"><span class="card-index">${v['duration']}</span><h3>${v['title']}</h3></div>
          <video controls playsinline preload="metadata" controlsList="nodownload"
                 poster="${v['poster']}" aria-label="${v['title']} — vidéo de présentation">
            <source src="$r2Base/VIDEOS/${v['file']}" type="video/mp4">
            Votre navigateur ne lit pas les vidéos MP4. Ouvrez cette page avec un navigateur récent.
          </video>
          <p>${v['text']}</p>
        </article>''';
    }).join('\n');

const newSection = r'''
    <section class="nos-videos" id="nos-videos">
      <div class="section-head">
        <span class="kicker">Vidéos</span>
        <h2>Nos vidéos de présentation</h2>
        <p>Trois vidéos réalisées pour le projet et hébergées sur notre stockage R2. Le bouton play est celui du lecteur du navigateur : aucun lecteur Google, aucune publicité, aucun cookie de suivi.</p>
      </div>
      <div class="video-grid">
__CARDS__
      </div>
      <p class="video-note">Les fichiers restent en ligne : aucun téléchargement n’est proposé et aucune donnée n’est envoyée à un service tiers.</p>
    </section>
''';

void patchMedia() {
  final file = File('$siteDir/media.html');
  var html = file.readAsStringSync();
  if (html.contains('id="nos-videos"')) return;

  html = html.replaceFirst(
    'Écoutez les khassaïdes en ligne, parcourez les captures de l’application et trouvez les directs mourides sur YouTube, sans lecteur intégré ni suivi.',
    'Écoutez les khassaïdes en ligne, parcourez les captures de l’application et regardez nos vidéos de présentation avec le bouton play, sans lecteur externe ni suivi.',
  );
  html = html.replaceFirst(
    'Le média de ce site reste volontairement simple : une page d’écoute en ligne, des captures réelles de l’application et l’icône utilisée sur le site et dans l’application. Aucun lecteur externe, aucune publicité, aucun suivi.',
    'Le média de ce site reste volontairement simple : une page d’écoute en ligne, des captures réelles de l’application et trois vidéos hébergées chez nous. Aucun lecteur externe, aucune publicité, aucun suivi.',
  );
  html = html.replaceFirst(
    '''        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>En direct sur YouTube</h3><p>Les chaînes mourides et la Grande Mosquée de Touba, en simples liens externes : aucun lecteur Google intégré.</p><p><a class="btn btn-gold" href="#direct-youtube">Voir les chaînes →</a></p></article>''',
    '''        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>Vidéos du projet</h3><p>Trois présentations hébergées sur notre stockage, lisibles ici avec le bouton play du navigateur.</p><p><a class="btn btn-gold" href="#nos-videos">Voir les vidéos →</a></p></article>''',
  );

  final sectionRe = RegExp(
    r'<section class="video-direct" id="direct-youtube">.*?</section>\s*</div>\s*</main>',
    dotAll: true,
  );
  if (!sectionRe.hasMatch(html)) {
    stdout.writeln('MÉDIA : section YouTube introuvable');
    return;
  }
  html = html.replaceFirst(
    sectionRe,
    '${newSection.replaceAll('__CARDS__', videoCards())}  </div>\n</main>',
  );
  write(file.path, html);
  stdout.writeln('Média : lecteur vidéo intégré installé');
}

const cssNew = r'''
/* ---------- Vidéos du projet : lecteur HTML5 natif, sans service tiers ---------- */
.nos-videos { margin-top: 26px; scroll-margin-top: 24px; }
.nos-videos .section-head { margin-bottom: 14px; }
.video-note {
  margin: 16px 0 0;
  padding: 12px 16px;
  border-left: 3px solid rgba(201, 154, 46, .7);
  border-radius: 0 12px 12px 0;
  background: rgba(201, 154, 46, .10);
  color: #E7F0E6;
}
.video-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}
.video-card {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 16px;
  border: 1px solid rgba(201, 154, 46, .42);
  border-top: 3px solid rgba(201, 154, 46, .72);
  border-radius: var(--radius);
  background: rgba(6, 30, 19, .78);
  scroll-margin-top: 24px;
}
.video-card-head { display: flex; align-items: baseline; gap: 10px; }
.video-card h3 { margin: 0; color: #FFF7E2; font-size: 1.12rem; line-height: 1.35; }
.video-card .card-index { white-space: nowrap; }
.video-card p { margin: 0; color: #E7F0E6; }
.video-card video {
  display: block;
  width: 100%;
  aspect-ratio: 16 / 9;
  border: 1px solid rgba(201, 154, 46, .55);
  border-radius: 12px;
  background: var(--deep);
  object-fit: contain;
}
@media (min-width: 860px) {
  .video-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .video-card:last-child { grid-column: 1 / -1; max-width: 620px; }
}
''';

void patchCss() {
  final file = File('$siteDir/assets/css/site.css');
  var css = file.readAsStringSync();
  final marker = '/* ---------- Chaînes YouTube en direct : liens simples, aucun lecteur intégré ---------- */';
  final index = css.indexOf(marker);
  if (index != -1) css = css.substring(0, index);
  if (css.contains('/* ---------- Vidéos du projet')) return;
  css = css.trimRight() + '\n\n' + cssNew;
  write(file.path, css);
}

void patchSearch() {
  final file = File('$siteDir/assets/js/search-data.js');
  var js = file.readAsStringSync();
  if (js.contains('"kind":"Vidéo"')) return;
  final prefix = 'window.DIIWAANU_SEARCH_INDEX = ';
  if (!js.startsWith(prefix)) {
    stdout.writeln('INDEX : préfixe inattendu');
    return;
  }
  final raw = js.substring(prefix.length).replaceFirst(RegExp(r';\s*$'), '');
  final list = jsonDecode(raw) as List<dynamic>;
  list.removeWhere((item) => item is Map && item['kind'] == 'Chaîne YouTube');
  for (final v in videos) {
    list.add(<String, dynamic>{
      'kind': 'Vidéo',
      'title': v['title'],
      'text': "${v['text']} Vidéo de présentation du projet, lisible directement sur le site.",
      'url': 'media.html#${v['id']}',
      'external': false,
    });
  }
  write(file.path, '$prefix${jsonEncode(list)};');
  stdout.writeln('Index recherche : 7 chaînes retirées, ${videos.length} vidéos ajoutées (total ${list.length})');
}

void patchRecherche() {
  final file = File('$siteDir/recherche.html');
  var html = file.readAsStringSync();
  if (html.contains('data-search-kind="Vidéo"')) return;
  const old = '''          <button type="button" data-search-kind="Chaîne YouTube" aria-pressed="false">Chaînes</button>''';
  if (!html.contains(old)) {
    stdout.writeln('RECHERCHE : bouton Chaînes introuvable');
    return;
  }
  html = html.replaceFirst(old, '''          <button type="button" data-search-kind="Vidéo" aria-pressed="false">Vidéos</button>''');
  write(file.path, html);
}

const auditNew = r'''
  final media = read('media.html');
  for (final marker in ['id="nos-videos"', '<video controls', 'controlsList="nodownload"']) {
    if (!media.contains(marker)) {
      stdout.writeln('MEDIA $marker : absent');
      problems++;
    }
  }
  final lecteursVideo = '<video'.allMatches(media).length;
  if (lecteursVideo != 3) {
    stdout.writeln('MEDIA lecteurs vidéo : $lecteursVideo (attendu 3)');
    problems++;
  }
  if (!media.contains('VIDEOS/promo-site.mp4') ||
      !media.contains('VIDEOS/promo-app.mp4') ||
      !media.contains('VIDEOS/promo-site-et-app.mp4')) {
    stdout.writeln('MEDIA : URLs R2 vidéo manquantes');
    problems++;
  }
  if (media.contains('youtube.com/embed') || media.contains('youtube-nocookie') || media.contains('<iframe')) {
    stdout.writeln('MEDIA : lecteur YouTube intégré détecté');
    problems++;
  }
  final indexVideos = '"kind":"Vidéo"'.allMatches(indexJs).length;
  if (indexVideos != 3) {
    stdout.writeln('INDEX vidéos : $indexVideos (attendu 3)');
    problems++;
  }
  if (!recherche.contains('data-search-kind="Vidéo"')) {
    stdout.writeln('RECHERCHE filtre vidéos : absent');
    problems++;
  }
''';

void patchAudits() {
  final startRe = RegExp(r'  final media = read\(.media\.html.\);');
  final endMarker = "  stdout.writeln('Pages : \${files.length}";
  for (final path in <String>[
    '$siteDir\\tools\\audit_site.dart',
    r'C:\Users\akman\AppData\Local\Temp\opencode\audit_site_sections.dart',
  ]) {
    final file = File(path);
    if (!file.existsSync()) continue;
    var text = file.readAsStringSync();
    if (text.contains('MEDIA lecteurs vidéo')) continue;
    final start = startRe.firstMatch(text);
    final end = text.indexOf(endMarker);
    if (start == null || end == -1 || end <= start.start) {
      stdout.writeln('AUDIT : bloc média introuvable dans ${file.uri.pathSegments.last}');
      continue;
    }
    text = text.substring(0, start.start) + auditNew + text.substring(end);
    write(file.path, text);
  }
}

void patchMemo() {
  final file = File('$siteDir/DEMARRAGE.md');
  var text = file.readAsStringSync();
  text = text.replaceAll('811 entrées', '807 entrées');
  text = text.replaceAll('804 entrées', '807 entrées');
  text = text.replaceFirst(
    '- `media.html#direct-youtube` : sept chaînes mourides en liens simples « Regarder sur YouTube » (GMT-Tv, Rafah TV, Bichri TV, As-Samadiyya TV, Al Khadimiyyah TV, Al Mouridiyyah TV, Touba TV). Aucun iframe, aucun cookie Google.\n',
    '- `media.html#nos-videos` : trois vidéos du projet (`promo-site`, `promo-app`, `promo-site-et-app`) hébergées dans le bucket R2 sous `VIDEOS/`, lues avec le lecteur HTML5 natif. Aucun lecteur tiers, aucun iframe, aucun cookie.\n',
  );
  write(file.path, text);
}

void main() {
  bumpVersion();
  patchMedia();
  patchCss();
  patchSearch();
  patchRecherche();
  patchAudits();
  patchMemo();
  stdout.writeln('Terminé : $version');
}
