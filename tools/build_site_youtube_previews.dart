// Ajoute sept aperçus de chaînes YouTube cliquables dans media.html.
// Les miniatures sont stockées localement : aucun appel à Google au chargement,
// aucun lecteur intégré, aucun cookie. Chaque aperçu ouvre YouTube dans un nouvel onglet.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const oldVersion = 'biblio32';
const version = 'biblio40';

final channels = <Map<String, Object>>[
  {
    'name': 'GMT -Tv — Grande Mosquée de Touba',
    'text': 'Chaîne officielle IP-TV de la Grande Mosquée de Touba, par Moukhaddamatoul Khidma : prières, conférences et directs depuis la mosquée.',
    'url': 'https://www.youtube.com/@GMTTv/streams',
    'img': 'gmt-tv',
    'index': '01',
  },
  {
    'name': 'Rafah TV International',
    'text': 'Chaîne culturelle et religieuse basée à Touba, près de la Grande Mosquée : directs, reportages et actualités mourides.',
    'url': 'https://www.youtube.com/@rafahtvinternational3478/streams',
    'img': 'rafah-tv',
    'index': '02',
  },
  {
    'name': 'Bichri TV International - HD',
    'text': 'Télévision islamique au service de Wakeur Xaadimu Rassoul : directs des Jataayu Mouride, Magal, Gamous et Ziarras.',
    'url': 'https://www.youtube.com/@bichritv/streams',
    'img': 'bichri-tv',
    'index': '03',
  },
  {
    'name': 'As-Samadiyya TV',
    'text': 'Dahira Yi du Dimanche : enseignements, rencontres et retransmissions en direct en haute définition.',
    'url': 'https://www.youtube.com/@as-samadiyyatv7927/streams',
    'img': 'as-samadiyya-tv',
    'index': '04',
  },
  {
    'name': 'Al Khadimiyyah TV',
    'text': 'Chaîne dédiée au patrimoine mouride : khassaïdes en continu, enseignements et directs depuis Touba.',
    'url': 'https://www.youtube.com/channel/UCqbQTS505CVDNNmPI0KwoYA/streams',
    'img': 'al-khadimiyyah-tv',
    'index': '05',
  },
  {
    'name': 'Al Mouridiyyah TV',
    'text': 'Chaîne d’Hizbut Tarqiyyah, « À la découverte de l’Univers Touba » : matinale As-Sabaah et directs.',
    'url': 'https://www.youtube.com/@Almouridiyyah_Tv_Officiel/streams',
    'img': 'al-mouridiyyah-tv',
    'index': '06',
  },
  {
    'name': 'Touba TV Officiel',
    'text': 'Directs et événements de Touba : discours du Khalife général, Magal et rencontres de la cité sainte.',
    'url': 'https://www.youtube.com/channel/UCavUkP6uhnT8wJpFgu-Q3kg/streams',
    'img': 'touba-tv',
    'index': '07',
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
    '$siteDir\\tools\\build_site_videos.dart',
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

String previewCards() => channels.map((c) {
      final nom = c['name'] as String;
      final img = c['img'] as String;
      final url = c['url'] as String;
      final idx = c['index'] as String;
      return '''        <article class="youtube-card">
          <a class="youtube-preview" href="$url" target="_blank" rel="noopener noreferrer" aria-label="Ouvrir les directs de $nom sur YouTube">
            <img src="assets/youtube-previews/$img.jpg" width="480" height="360" loading="lazy" alt="Aperçu vidéo de $nom">
            <span class="play-badge" aria-hidden="true">▶</span>
            <span class="preview-cta" aria-hidden="true">Voir sur YouTube ↗</span>
          </a>
          <div class="youtube-card-head"><span class="card-index">$idx</span><h3>$nom</h3></div>
          <p>${c['text']}</p>
          <p><a class="btn btn-gold" href="$url" target="_blank" rel="noopener noreferrer">Regarder sur YouTube ↗</a></p>
        </article>''';
    }).join('\n');

const youtubeSection = r'''
    <section class="youtube-direct" id="direct-youtube">
      <div class="section-head">
        <span class="kicker">En direct</span>
        <h2>Les chaînes mourides sur YouTube</h2>
        <p>Sept aperçus pour rejoindre les directs de la Grande Mosquée de Touba et des chaînes mourides. Cliquez sur un aperçu : YouTube s’ouvre dans un nouvel onglet. Aucun lecteur Google n’est chargé sur cette page.</p>
      </div>
      <div class="youtube-grid">
__CARDS__
      </div>
      <p class="video-note">Les aperçus sont enregistrés sur notre site : aucune image n’est demandée à Google pendant votre visite. Les directs dépendent des chaînes externes ; leur disponibilité n’est pas contrôlée par Diiwaanu Xassida Yi.</p>
    </section>
''';

void patchMedia() {
  final file = File('$siteDir/media.html');
  var html = file.readAsStringSync();
  if (html.contains('id="direct-youtube"')) return;

  const card04 = '''        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>Vidéos du projet</h3><p>Trois présentations hébergées sur notre stockage, lisibles ici avec le bouton play du navigateur.</p><p><a class="btn btn-gold" href="#nos-videos">Voir les vidéos →</a></p></article>''';
  if (!html.contains(card04)) {
    stdout.writeln('MÉDIA : carte 04 introuvable');
    return;
  }
  html = html.replaceFirst(card04, '''$card04
        <article class="card"><div class="mark" aria-hidden="true">05</div><h3>En direct sur YouTube</h3><p>Sept chaînes mourides en aperçus cliquables : un clic ouvre directement la chaîne sur YouTube, sans lecteur intégré ici.</p><p><a class="btn btn-gold" href="#direct-youtube">Voir les chaînes →</a></p></article>''');

  html = html.replaceFirst('        <section class="nos-videos" id="nos-videos">', '    <section class="nos-videos" id="nos-videos">');

  final fin = RegExp(r'  </div>\r?\n</main>');
  if (!fin.hasMatch(html)) {
    stdout.writeln('MÉDIA : fin de main introuvable');
    return;
  }
  html = html.replaceFirst(fin, '${youtubeSection.replaceAll('__CARDS__', previewCards())}  </div>\n</main>');
  write(file.path, html);
  stdout.writeln('Média : 7 aperçus YouTube installés');
}

const cssNew = r'''
/* ---------- Aperçus YouTube : miniatures locales, aucun lecteur tiers chargé ---------- */
.youtube-direct { margin-top: 26px; scroll-margin-top: 24px; }
.youtube-direct .section-head { margin-bottom: 14px; }
.youtube-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}
.youtube-card {
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
.youtube-preview {
  position: relative;
  display: block;
  overflow: hidden;
  border: 1px solid rgba(201, 154, 46, .55);
  border-radius: 12px;
  background: var(--deep);
}
.youtube-preview::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(6, 30, 19, 0) 45%, rgba(6, 30, 19, .82));
}
.youtube-preview img {
  display: block;
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
}
.play-badge {
  position: absolute;
  top: 50%;
  left: 50%;
  z-index: 1;
  display: grid;
  place-items: center;
  width: 64px;
  height: 64px;
  transform: translate(-50%, -50%);
  border: 2px solid rgba(201, 154, 46, .95);
  border-radius: 50%;
  background: rgba(6, 30, 19, .72);
  color: var(--gold-light);
  font-size: 1.5rem;
  padding-left: 4px;
}
.preview-cta {
  position: absolute;
  right: 10px;
  bottom: 10px;
  z-index: 1;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(201, 154, 46, .92);
  color: #061E13;
  font-size: 1rem;
  font-weight: 800;
}
.youtube-preview:hover .play-badge,
.youtube-preview:focus-visible .play-badge {
  background: rgba(201, 154, 46, .95);
  color: #061E13;
}
.youtube-card-head { display: flex; align-items: baseline; gap: 10px; }
.youtube-card h3 { margin: 0; color: #FFF7E2; font-size: 1.12rem; line-height: 1.35; }
.youtube-card p { margin: 0; color: #E7F0E6; }
.youtube-card .btn { margin-top: auto; align-self: flex-start; }
@media (min-width: 860px) {
  .youtube-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
}
''';

void patchCss() {
  final file = File('$siteDir/assets/css/site.css');
  var css = file.readAsStringSync();
  if (css.contains('.youtube-direct')) return;
  css = css.trimRight() + '\n\n' + cssNew;
  write(file.path, css);
}

void patchSearch() {
  final file = File('$siteDir/assets/js/search-data.js');
  var js = file.readAsStringSync();
  if (js.contains('"kind":"Chaîne YouTube"')) return;
  const prefix = 'window.DIIWAANU_SEARCH_INDEX = ';
  if (!js.startsWith(prefix)) {
    stdout.writeln('INDEX : préfixe inattendu');
    return;
  }
  final raw = js.substring(prefix.length).replaceFirst(RegExp(r';\s*$'), '');
  final list = jsonDecode(raw) as List<dynamic>;
  for (final c in channels) {
    list.add(<String, dynamic>{
      'kind': 'Chaîne YouTube',
      'title': c['name'],
      'text': "${c['text']} Aperçu vidéo cliquable : ouvre la chaîne sur YouTube.",
      'url': c['url'],
      'external': true,
    });
  }
  write(file.path, '$prefix${jsonEncode(list)};');
  stdout.writeln('Index recherche : ${channels.length} chaînes ajoutées (total ${list.length})');
}

void patchRecherche() {
  final file = File('$siteDir/recherche.html');
  var html = file.readAsStringSync();
  if (html.contains('data-search-kind="Chaîne YouTube"')) return;
  const marker = '''          <button type="button" data-search-kind="Vidéo" aria-pressed="false">Vidéos</button>''';
  if (!html.contains(marker)) {
    stdout.writeln('RECHERCHE : bouton Vidéos introuvable');
    return;
  }
  html = html.replaceFirst(marker, '''$marker
          <button type="button" data-search-kind="Chaîne YouTube" aria-pressed="false">Chaînes</button>''');
  write(file.path, html);
}

const auditNew = r'''
  final youtubePreviews = 'class="youtube-preview"'.allMatches(media).length;
  if (youtubePreviews != 7) {
    stdout.writeln('MEDIA aperçus YouTube : $youtubePreviews (attendu 7)');
    problems++;
  }
  for (final marker in [
    'id="direct-youtube"',
    'assets/youtube-previews/gmt-tv.jpg',
    'assets/youtube-previews/touba-tv.jpg',
    'target="_blank" rel="noopener noreferrer"',
  ]) {
    if (!media.contains(marker)) {
      stdout.writeln('MEDIA $marker : absent');
      problems++;
    }
  }
  if (media.contains('i.ytimg.com') || media.contains('youtube.com/embed') || media.contains('<iframe')) {
    stdout.writeln('MEDIA : chargement tiers ou lecteur intégré détecté');
    problems++;
  }
  final indexChaines = '"kind":"Chaîne YouTube"'.allMatches(indexJs).length;
  if (indexChaines != 7) {
    stdout.writeln('INDEX chaînes : $indexChaines (attendu 7)');
    problems++;
  }
  if (!recherche.contains('data-search-kind="Chaîne YouTube"')) {
    stdout.writeln('RECHERCHE filtre chaînes : absent');
    problems++;
  }
''';

void patchAudits() {
  const finalMarker = "  stdout.writeln('Pages : \${files.length}";
  for (final path in <String>[
    '$siteDir\\tools\\audit_site.dart',
    r'C:\Users\akman\AppData\Local\Temp\opencode\audit_site_sections.dart',
  ]) {
    final file = File(path);
    if (!file.existsSync()) continue;
    var text = file.readAsStringSync();
    if (text.contains('MEDIA aperçus YouTube')) continue;
    if (!text.contains(finalMarker)) {
      stdout.writeln('AUDIT : marqueur final introuvable dans ${file.uri.pathSegments.last}');
      continue;
    }
    text = text.replaceFirst(finalMarker, auditNew + finalMarker);
    write(file.path, text);
  }
}

void patchMemo() {
  final file = File('$siteDir/DEMARRAGE.md');
  var text = file.readAsStringSync();
  text = text.replaceAll('807 entrées', '814 entrées');
  text = text.replaceFirst(
    'Toute modification CSS/JS doit passer à `$version` puis mettre à jour',
    'Toute modification CSS/JS doit passer à `$version` (prochaine valeur : `biblio41`) puis mettre à jour',
  );
  const marker = '- `media.html#nos-videos` : trois vidéos du projet';
  if (!text.contains(marker)) {
    stdout.writeln('MÉMO : section nos-videos introuvable');
    return;
  }
  text = text.replaceFirst(
    '- `index.html` : quatre boutons mourides juste au-dessus de la grille « À la une ».',
    '- `media.html#direct-youtube` : sept chaînes mourides en aperçus cliquables ; miniatures stockées dans `assets/youtube-previews/`, téléchargées une seule fois. Un clic ouvre YouTube dans un nouvel onglet : aucun lecteur intégré, aucun appel à Google au chargement de la page.\n- `index.html` : quatre boutons mourides juste au-dessus de la grille « À la une ».',
  );
  text = text.replaceFirst(
    '`tools/build_site_youtube.dart` et `tools/build_site_videos.dart` : scripts historiques des ajouts de novembre 2026 ;',
    '`tools/build_site_youtube.dart`, `tools/build_site_videos.dart` et `tools/build_site_youtube_previews.dart` : scripts historiques des ajouts de novembre 2026 ;',
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
