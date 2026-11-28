// Construit la page Rajaz (khassaïdes chantées par un seul interprète) à
// partir du catalogue généré par l'application, puis synchronise navigation,
// styles, script, sitemap, recherche, audit, mémo et cache des assets.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const appDir = r'C:\Users\akman\Documents\khassida_app';
const newPage = 'rajaz.html';
const oldVersion = 'biblio52';
const newVersion = 'biblio52';
const unknownArtist = 'Sans interprète indiqué';

String read(String path) => File('$siteDir\\$path').readAsStringSync(encoding: utf8);
void write(String path, String content) =>
    File('$siteDir\\$path').writeAsStringSync(content, encoding: utf8, flush: true);

String escapeHtml(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

String replaceOne(String source, String from, String to, String label) {
  if (!source.contains(from)) throw StateError('Marqueur introuvable : $label');
  return source.replaceFirst(from, to);
}

Map<String, Object> loadData() {
  final decoded = jsonDecode(read('tools\\rajaz_data.json'));
  if (decoded is! Map) throw StateError('rajaz_data.json invalide');
  return decoded.cast<String, Object>();
}

String options(List<dynamic> artists) {
  final buffer = StringBuffer()
    ..writeln('        <option value="">Tous les interprètes</option>');
  for (final artist in artists) {
    buffer.writeln(
      '        <option value="${escapeHtml(artist.toString())}">'
      '${escapeHtml(artist.toString())}</option>',
    );
  }
  return buffer.toString();
}

String rows(List<dynamic> tracks) {
  final buffer = StringBuffer();
  for (final entry in tracks) {
    final track = entry as Map;
    final number = track['number'].toString();
    final title = track['title'].toString();
    final artist = track['artist'].toString();
    final url = track['url'].toString();
    final haystack = '$number $title $artist'.toLowerCase();
    buffer.writeln('        <li class="playlist-row" id="rajaz-piste-$number"');
    buffer.writeln(
      '            data-artist="${escapeHtml(artist)}" '
      'data-title="${escapeHtml(title)}" '
      'data-search="${escapeHtml(haystack)}" '
      'data-src="${escapeHtml(url)}">',
    );
    buffer.writeln(
      '          <button class="playlist-play" type="button" '
      'aria-label="Lire : ${escapeHtml(title)}"><span aria-hidden="true">▶</span></button>',
    );
    buffer.writeln('          <div class="playlist-copy">');
    buffer.writeln(
      '            <h3><span class="playlist-num" aria-hidden="true">$number</span>'
      '${escapeHtml(title)}</h3>',
    );
    buffer.writeln(
      '            <p class="playlist-duration">'
      '${artist == unknownArtist ? 'Interprète non indiqué' : 'Interprète : ${escapeHtml(artist)}'}</p>',
    );
    buffer.writeln('          </div>');
    buffer.writeln('        </li>');
  }
  return buffer.toString();
}

void buildPage(Map<String, Object> data) {
  var h = read('audio.html');
  final tracks = data['tracks'] as List<dynamic>;
  final artists = data['artists'] as List<dynamic>;

  h = h.replaceAll(
    'https://www.diiwaanu-xassida-yi.com/audio.html',
    'https://www.diiwaanu-xassida-yi.com/$newPage',
  );
  h = replaceOne(
    h,
    '<title>Audio — Diiwaanu Xassida Yi</title>',
    '<title>Rajaz — Khassaïdes en solistes — Diiwaanu Xassida Yi</title>',
    'title',
  );
  h = h.replaceAll(
    'Écoutez les khassaïdes en ligne au format MP3, directement sur le site, sans compte ni publicité ni enregistrement sur l’appareil.',
    'Écoutez ${tracks.length} khassaïdes chantées par un seul interprète, en ligne, sans compte ni publicité.',
  );
  h = replaceOne(
    h,
    '<meta property="og:title" content="Audio — Diiwaanu Xassida Yi">',
    '<meta property="og:title" content="Rajaz — Khassaïdes en solistes — Diiwaanu Xassida Yi">',
    'og:title',
  );
  h = replaceOne(h, '<p class="eyebrow">Audio</p>', '<p class="eyebrow">Rajaz</p>', 'eyebrow');
  h = replaceOne(
    h,
    '<h1>Les khassaïdes<br><span>à écouter</span></h1>',
    '<h1>RAJAZ<br><span>en solistes</span></h1>',
    'h1',
  );
  h = replaceOne(
    h,
    '<p class="lead">Vingt-trois enregistrements à écouter en ligne, avec lecture, pause, précédent et suivant, sans inscription.</p>',
    '<p class="lead">${tracks.length} enregistrements, ${artists.length - 1} interprètes nommés. Filtrez par interprète et écoutez en ligne, sans inscription.</p>',
    'lead',
  );
  h = replaceOne(
    h,
    '<span class="kicker">À écouter</span>',
    '<span class="kicker">À écouter en solo</span>',
    'kicker',
  );
  h = replaceOne(
    h,
    '<p>Choisissez une piste dans la liste : elle se lance dans le lecteur ci-dessus. Les MP3 restent en ligne et ne sont pas enregistrés sur l’appareil.</p>',
    '<p>Choisissez un interprète, puis une piste : elle se lance dans le lecteur ci-dessus. Les MP3 restent en ligne et ne sont pas enregistrés sur l’appareil.</p>',
    'section intro',
  );

  final filters = '''
      <div class="rajaz-filters" role="group" aria-label="Filtrer les khassaïdes Rajaz">
        <label for="rajaz-artist">Interprète
          <select id="rajaz-artist">
${options(artists)}          </select>
        </label>
        <label for="rajaz-search">Rechercher
          <input id="rajaz-search" type="search" autocomplete="off" placeholder="Titre ou interprète">
        </label>
        <p id="rajaz-count" role="status" aria-live="polite">${tracks.length} enregistrements</p>
      </div>
''';
  final playlist = RegExp(r'<ol class="playlist" id="playlist".*?</ol>', dotAll: true);
  if (!playlist.hasMatch(h)) throw StateError('Playlist audio introuvable');
  h = h.replaceFirst(
    playlist,
    '$filters      <ol class="rajaz-playlist playlist" id="rajaz-playlist" '
        'aria-label="Playlist Rajaz">\n${rows(tracks)}      </ol>',
  );

  h = h.replaceAll('<h2 id="player-title">Lecteur des khassaïdes</h2>',
      '<h2 id="rajaz-player-title">Lecteur Rajaz</h2>');
  h = h.replaceAll(
    '<audio id="audio-player" controls preload="none" aria-label="Lecteur audio des khassaïdes"></audio>',
    '<audio id="rajaz-player" controls preload="none" aria-label="Lecteur audio Rajaz"></audio>',
  );
  h = h.replaceAll('data-audio-prev', 'data-rajaz-prev');
  h = h.replaceAll('data-audio-next', 'data-rajaz-next');
  h = h.replaceAll(
    '<p class="audio-status" id="audio-status" role="status" aria-live="polite">Choissez une piste pour commencer l’écoute.</p>',
    '<p class="audio-status" id="rajaz-status" role="status" aria-live="polite">Choisissez une khassida pour commencer l’écoute.</p>',
  );
  h = h.replaceAll(
    '<p>Pas de publicité, pas de formulaire, pas d’historique : la lecture s’ouvre dans votre navigateur. <a href="bibliotheque.html">Voir la bibliothèque →</a></p>',
    '<p>Pas de publicité, pas de formulaire, pas d’historique : la lecture s’ouvre dans votre navigateur. <a href="audio.html">Revenir aux khassaïdes collectives →</a></p>',
  );
  write(newPage, h);
  stdout.writeln('Écrit : $newPage (${tracks.length} pistes)');
}

void patchNavigation() {
  var touched = 0;
  for (final entity in Directory(siteDir).listSync()) {
    if (entity is! File || !entity.path.endsWith('.html')) continue;
    var html = entity.readAsStringSync(encoding: utf8);
    if (html.contains('href="$newPage"')) continue;
    const audioLi = '<li><a href="audio.html">Audio</a></li>';
    if (html.contains(audioLi)) {
      html = html.replaceAll(audioLi, '@@RAJAZ_LI@@');
    }
    html = html.replaceAll(
      '<a href="audio.html">Audio</a>',
      '<a href="audio.html">Audio</a>\n        <a href="$newPage">Rajaz</a>',
    );
    html = html.replaceAll(
      '@@RAJAZ_LI@@',
      '$audioLi\n          <li><a href="$newPage">Rajaz</a></li>',
    );
    entity.writeAsStringSync(html, encoding: utf8, flush: true);
    touched++;
  }
  stdout.writeln('Navigation : lien Rajaz ajouté sur $touched pages');
}

void patchCss() {
  var css = read('assets\\css\\site.css');
  if (!css.contains('.rajaz-filters')) {
    css += '''

/* Filtres de la page Rajaz : cibles larges, texte lisible sur mobile. */
.rajaz-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: flex-end;
  margin: 0 0 18px;
  padding: 16px;
  border: 1px solid rgba(201, 154, 46, 0.45);
  border-radius: 18px;
  background: rgba(6, 30, 19, 0.35);
}
.rajaz-filters label {
  display: flex;
  flex: 1 1 240px;
  flex-direction: column;
  gap: 6px;
  font-size: 14px;
  font-weight: 700;
  color: #F7E6A8;
}
.rajaz-filters select,
.rajaz-filters input {
  min-height: 48px;
  padding: 10px 12px;
  border: 1px solid rgba(201, 154, 46, 0.55);
  border-radius: 12px;
  background: #061E13;
  color: #FFF7E2;
  font: inherit;
  font-size: 16px;
}
.rajaz-filters p {
  flex-basis: 100%;
  margin: 0;
  font-size: 14px;
  color: #E7F0E6;
}
.playlist-row[hidden] { display: none; }
''';
    write('assets\\css\\site.css', css);
    stdout.writeln('CSS : filtres Rajaz ajoutés');
  }
}

const rajazJs = r'''
  /* ---------- Rajaz : un seul lecteur, filtres locaux, aucun téléchargement ---------- */
  function initRajazPlaylist() {
    const player = $('#rajaz-player');
    const list = $('#rajaz-playlist');
    const status = $('#rajaz-status');
    const select = $('#rajaz-artist');
    const search = $('#rajaz-search');
    const count = $('#rajaz-count');
    if (!player || !list) return;
    const rows = $$('.playlist-row', list);
    if (!rows.length) return;
    let current = null;

    const titleOf = (row) => row.dataset.title || 'cette khassida';
    const visible = () => rows.filter((row) => !row.hidden);

    const reflect = () => {
      rows.forEach((row) => {
        const playing = row === current && !player.paused;
        row.classList.toggle('is-current', row === current);
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

    const setTrack = (row, play) => {
      if (!row) return;
      current = row;
      player.src = row.dataset.src;
      player.load();
      announce('En cours : ' + titleOf(row));
      reflect();
      if (play) {
        const pending = player.play();
        if (pending && pending.catch) {
          pending.catch(() => announce('Lecture bloquée par le navigateur : utilisez le bouton du lecteur.'));
        }
      }
    };

    const step = (offset) => {
      const shown = visible();
      if (!shown.length) return;
      const index = shown.indexOf(current);
      const next = index < 0 ? 0 : (index + offset + shown.length) % shown.length;
      setTrack(shown[next], true);
    };

    const applyFilters = () => {
      const artist = select ? select.value : '';
      const query = search ? search.value.trim().toLowerCase() : '';
      let shown = 0;
      rows.forEach((row) => {
        const artistOk = !artist || row.dataset.artist === artist;
        const textOk = !query || (row.dataset.search || '').includes(query);
        row.hidden = !(artistOk && textOk);
        if (!row.hidden) shown++;
      });
      if (count) {
        count.textContent = shown + ' enregistrement' + (shown > 1 ? 's' : '');
      }
      if (current && current.hidden) {
        current = null;
        player.pause();
        player.removeAttribute('src');
        player.load();
        announce('Choisissez une khassida pour commencer l’écoute.');
      }
      reflect();
    };

    rows.forEach((row) => {
      const button = $('.playlist-play', row);
      if (button) button.addEventListener('click', () => setTrack(row, true));
    });
    const previous = $('[data-rajaz-prev]');
    const next = $('[data-rajaz-next]');
    if (previous) previous.addEventListener('click', () => step(-1));
    if (next) next.addEventListener('click', () => step(1));
    player.addEventListener('play', reflect);
    player.addEventListener('pause', reflect);
    player.addEventListener('ended', () => step(1));

    if (select) {
      const requested = new URLSearchParams(window.location.search).get('artiste');
      if (requested && rows.some((row) => row.dataset.artist === requested)) {
        select.value = requested;
      }
      select.addEventListener('change', applyFilters);
    }
    if (search) {
      search.addEventListener('input', applyFilters);
      search.addEventListener('search', applyFilters);
    }
    applyFilters();
  }

''';

void patchJs() {
  var js = read('assets\\js\\site.js');
  if (!js.contains('function initRajazPlaylist()')) {
    js = replaceOne(
      js,
      "  document.addEventListener('DOMContentLoaded', () => {",
      '${rajazJs.replaceAll('\n', '\r\n')}  document.addEventListener(\'DOMContentLoaded\', () => {',
      'DOMContentLoaded',
    );
    js = replaceOne(
      js,
      '    initAudioPlaylist();',
      '    initAudioPlaylist();\r\n    initRajazPlaylist();',
      'appel Rajaz',
    );
    write('assets\\js\\site.js', js);
    stdout.writeln('JS : lecteur et filtres Rajaz ajoutés');
  }
}

void patchSitemap() {
  var xml = read('sitemap.xml');
  if (xml.contains('/$newPage<')) return;
  const entry = '''
  <url>
    <loc>https://www.diiwaanu-xassida-yi.com/$newPage</loc>
    <lastmod>2026-11-28</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>
''';
  xml = xml.replaceFirst('</urlset>', '$entry</urlset>');
  write('sitemap.xml', xml);
  stdout.writeln('Sitemap : $newPage ajouté');
}

void patchSearch(Map<String, Object> data) {
  var js = read('assets\\js\\search-data.js');
  if (js.contains('"url":"$newPage"')) return;
  final entries = <Map<String, Object>>[
    {
      'kind': 'Page',
      'title': 'Rajaz — Khassaïdes en solistes',
      'text': 'Khassaïdes chantées par un seul interprète, à écouter en ligne.',
      'url': newPage,
      'external': false,
    },
  ];
  for (final artist in data['artists'] as List<dynamic>) {
    if (artist.toString() == unknownArtist) continue;
    entries.add({
      'kind': 'Audio',
      'title': 'Rajaz — $artist',
      'text': 'Khassaïdes chantées par $artist, à écouter en ligne.',
      'url': '$newPage?artiste=${Uri.encodeQueryComponent(artist.toString())}',
      'external': false,
    });
  }
  final injected = entries.map((entry) => '${jsonEncode(entry)},').join();
  js = js.replaceFirst(
    'window.DIIWAANU_SEARCH_INDEX = [',
    'window.DIIWAANU_SEARCH_INDEX = [$injected',
  );
  write('assets\\js\\search-data.js', js);
  stdout.writeln('Recherche : ${entries.length} entrées Rajaz ajoutées');
}

void patchAudit() {
  final path = 'tools\\audit_site.dart';
  var dart = read(path);
  dart = dart
      .replaceAll('if (files.length != 28)', 'if (files.length != 29)')
      .replaceAll('PAGES ATTENDUES : 28, trouvé', 'PAGES ATTENDUES : 29, trouvé')
      .replaceAll('if (locs.length != 28)', 'if (locs.length != 29)')
      .replaceAll('SITEMAP ATTENDU : 28 URL, trouvé', 'SITEMAP ATTENDU : 29 URL, trouvé');
  if (!dart.contains('final rajazPage')) {
    const anchor = '  if (!voieInfos.contains(\'href="conferences.html"\')) {';
    const addition = r'''  final rajazPage = read('rajaz.html');
  final rajazCount = '<li class="playlist-row"'.allMatches(rajazPage).length;
  if (rajazCount != 230) {
    stdout.writeln('RAJAZ pistes : $rajazCount (attendu 230)');
    problems++;
  }
  if (!rajazPage.contains('id="rajaz-piste-001"') ||
      !rajazPage.contains('id="rajaz-piste-234"') ||
      !rajazPage.contains('id="rajaz-player"') ||
      !rajazPage.contains('id="rajaz-artist"') ||
      !rajazPage.contains('id="rajaz-search"') ||
      !rajazPage.contains('id="rajaz-count"')) {
    stdout.writeln('RAJAZ : page dédiée incomplète');
    problems++;
  }
  if (!rajazPage.contains('/RAJAZ/s._rajaz_-_001.mp3') ||
      !rajazPage.contains('/RAJAZ/s._rajaz_-_234.mp3')) {
    stdout.writeln('RAJAZ : URLs R2 manquantes');
    problems++;
  }
  if (RegExp(r'<audio\b').allMatches(rajazPage).length != 1) {
    stdout.writeln('RAJAZ : le lecteur unique est attendu');
    problems++;
  }
  if (!siteJs.contains('function initRajazPlaylist()') ||
      !siteJs.contains('initRajazPlaylist();') ||
      !read('assets/css/site.css').contains('.rajaz-filters')) {
    stdout.writeln('RAJAZ : filtres ou CSS absents');
    problems++;
  }
''';
    if (!dart.contains(anchor)) throw StateError('Ancre audit introuvable');
    dart = dart.replaceFirst(anchor, '$addition$anchor');
  }
  write(path, dart);
  stdout.writeln('Audit : attentes 29 pages et 230 pistes Rajaz');
}

void patchMemo(Map<String, Object> data) {
  final tracks = (data['tracks'] as List<dynamic>).length;
  var md = read('DEMARRAGE.md');
  md = md
      .replaceAll('28 pages, 28 URL', '29 pages, 29 URL')
      .replaceAll('28 pages · 28 URL', '29 pages · 29 URL')
      .replaceAll('838 entrées', '879 entrées')
      .replaceAll('839 entrées', '879 entrées')
      .replaceAll('Navigation déployée sur les 28 pages', 'Navigation déployée sur les 29 pages');
  if (!md.contains('`rajaz.html`')) {
    md = md.replaceFirst(
      '- `index.html` : six boutons mourides dans l’ordre',
      '- `rajaz.html` : $tracks khassaïdes chantées par un seul interprète, '
      'regroupées par interprète avec filtre local et lecteur unique sur R2 '
      '`RAJAZ/` ; aucun téléchargement.\n'
      '- `index.html` : six boutons mourides dans l’ordre',
    );
  }
  if (!md.contains('préfixe R2 `RAJAZ/`')) {
    md = md.replaceFirst(
      'Audio : 23 MP3',
      'Audio : 23 MP3 de khassaïdes collectives et $tracks MP3 Rajaz',
    );
  }
  write('DEMARRAGE.md', md);
  stdout.writeln('Mémo : page Rajaz documentée');
}

void patchGenerator() {
  final file = File('$appDir\\tools\\generate_site_pages.dart');
  var dart = file.readAsStringSync(encoding: utf8);
  if (dart.contains("MenuItem('Rajaz', 'rajaz.html')")) return;
  dart = replaceOne(
    dart,
    "    MenuItem('Audio', 'audio.html'),\n",
    "    MenuItem('Audio', 'audio.html'),\n    MenuItem('Rajaz', 'rajaz.html'),\n",
    'menu générateur',
  );
  file.writeAsStringSync(dart, encoding: utf8, flush: true);
  stdout.writeln('Générateur site : entrée Rajaz ajoutée');
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
    if (!content.contains(oldVersion)) continue;
    entity.writeAsStringSync(
      content.replaceAll(oldVersion, newVersion),
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
    if (!content.contains(oldVersion)) continue;
    file.writeAsStringSync(
      content.replaceAll(oldVersion, newVersion),
      encoding: utf8,
      flush: true,
    );
    changed++;
  }
  stdout.writeln('Cache : $oldVersion → $newVersion sur $changed fichiers');
}

void main() {
  final data = loadData();
  if ((data['tracks'] as List).length != 230) {
    throw StateError('230 pistes Rajaz attendues');
  }
  buildPage(data);
  patchNavigation();
  patchCss();
  patchJs();
  patchSitemap();
  patchSearch(data);
  patchAudit();
  patchMemo(data);
  patchGenerator();
  bumpCache();
  stdout.writeln('Terminé : page Rajaz et cache $newVersion');
}
