// Construit la page FATWA (questions-réponses religieuses, deux auteurs) à
// partir du catalogue généré par l'application, puis synchronise navigation,
// styles, script, sitemap, recherche, audit, mémo et cache des assets.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const appDir = r'C:\Users\akman\Documents\khassida_app';
const newPage = 'fatwa.html';
const oldVersion = 'biblio52';
const newVersion = 'biblio53';
const r2Prefix = 'FATWA/';

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
  final decoded = jsonDecode(read('tools\\fatwa_data.json'));
  if (decoded is! Map) throw StateError('fatwa_data.json invalide');
  return decoded.cast<String, Object>();
}

String options(List<dynamic> authors) {
  final buffer = StringBuffer()
    ..writeln('        <option value="">Tous les auteurs</option>');
  for (final author in authors) {
    buffer.writeln(
      '        <option value="${escapeHtml(author.toString())}">'
      '${escapeHtml(author.toString())}</option>',
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
    final author = track['author'].toString();
    final url = track['url'].toString();
    final haystack = '$number $title $author'.toLowerCase();
    buffer.writeln('        <li class="playlist-row" id="fatwa-piste-$number"');
    buffer.writeln(
      '            data-author="${escapeHtml(author)}" '
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
      '            <p class="playlist-duration">Auteur : ${escapeHtml(author)}</p>',
    );
    buffer.writeln('          </div>');
    buffer.writeln('        </li>');
  }
  return buffer.toString();
}

/// La navigation est patchée avant la construction de la page : celle-ci
/// hérite donc des mêmes liens que le reste du site.
void patchNavigation() {
  var touched = 0;
  for (final entity in Directory(siteDir).listSync()) {
    if (entity is! File || !entity.path.endsWith('.html')) continue;
    var html = entity.readAsStringSync(encoding: utf8);
    if (html.contains('href="$newPage"')) continue;
    var changed = false;
    const li = '<li><a href="rajaz.html">Rajaz</a></li>';
    if (html.contains(li)) {
      html = html.replaceAll(li, '$li\n          <li><a href="$newPage">FATWA</a></li>');
      changed = true;
    }
    const inline = '<a href="rajaz.html">Rajaz</a> · ';
    if (html.contains(inline)) {
      html = html.replaceAll(inline, '$inline<a href="$newPage">FATWA</a> · ');
      changed = true;
    }
    const bare = '<a href="rajaz.html">Rajaz</a>';
    if (!changed && html.contains(bare)) {
      html = html.replaceAll(bare, '$bare\n        <a href="$newPage">FATWA</a>');
      changed = true;
    }
    if (!changed) continue;
    entity.writeAsStringSync(html, encoding: utf8, flush: true);
    touched++;
  }
  stdout.writeln('Navigation : lien FATWA ajouté sur $touched pages');
}

void buildPage(Map<String, Object> data) {
  var h = read('audio.html');
  final tracks = data['tracks'] as List<dynamic>;
  final authors = data['authors'] as List<dynamic>;
  final authorNames = authors.map((a) => a.toString()).join(' et ');
  const description =
      'Écoutez les fatwas en ligne : questions-réponses sur la religion '
      'avec Serigne Mbacke A. Rahmane et Serigne Cheikhouna Mbacke Abdoul '
      'Wadoud, sans compte ni publicité ni enregistrement sur l’appareil.';

  h = h.replaceAll(
    'https://www.diiwaanu-xassida-yi.com/audio.html',
    'https://www.diiwaanu-xassida-yi.com/$newPage',
  );
  h = replaceOne(
    h,
    '<title>Audio — Diiwaanu Xassida Yi</title>',
    '<title>FATWA — Questions-réponses sur la religion — Diiwaanu Xassida Yi</title>',
    'title',
  );
  h = h.replaceAll(
    'Écoutez les khassaïdes en ligne au format MP3, directement sur le site, sans compte ni publicité ni enregistrement sur l’appareil.',
    description,
  );
  h = replaceOne(
    h,
    '<meta property="og:title" content="Audio — Diiwaanu Xassida Yi">',
    '<meta property="og:title" content="FATWA — Questions-réponses sur la religion — Diiwaanu Xassida Yi">',
    'og:title',
  );
  h = replaceOne(h, '<p class="eyebrow">Audio</p>', '<p class="eyebrow">FATWA</p>', 'eyebrow');
  h = replaceOne(
    h,
    '<h1>Les khassaïdes<br><span>à écouter</span></h1>',
    '<h1>FATWA<br><span>questions-réponses</span></h1>',
    'h1',
  );
  h = replaceOne(
    h,
    '<p class="lead">Vingt-trois enregistrements à écouter en ligne, avec lecture, pause, précédent et suivant, sans inscription.</p>',
    '<p class="lead">${tracks.length} enregistrements avec $authorNames. '
    'Filtrez par auteur et écoutez en ligne, sans inscription.</p>',
    'lead',
  );
  h = replaceOne(
    h,
    '<span class="kicker">À écouter</span>',
    '<span class="kicker">À écouter</span>',
    'kicker',
  );
  h = replaceOne(
    h,
    '<p>Choisissez une piste dans la liste : elle se lance dans le lecteur ci-dessus. Les MP3 restent en ligne et ne sont pas enregistrés sur l’appareil.</p>',
    '<p>Choisissez un auteur, puis une question-réponse : elle se lance dans '
    'le lecteur ci-dessus. Les MP3 restent en ligne et ne sont pas enregistrés '
    'sur l’appareil.</p>',
    'section intro',
  );

  final filters = '''
      <div class="fatwa-filters" role="group" aria-label="Filtrer les fatwas">
        <label for="fatwa-author">Auteur
          <select id="fatwa-author">
${options(authors)}          </select>
        </label>
        <label for="fatwa-search">Rechercher
          <input id="fatwa-search" type="search" autocomplete="off" placeholder="Titre ou auteur">
        </label>
        <p id="fatwa-count" role="status" aria-live="polite">${tracks.length} enregistrements</p>
      </div>
''';
  final playlist = RegExp(r'<ol class="playlist" id="playlist".*?</ol>', dotAll: true);
  if (!playlist.hasMatch(h)) throw StateError('Playlist audio introuvable');
  h = h.replaceFirst(
    playlist,
    '$filters      <ol class="fatwa-playlist playlist" id="fatwa-playlist" '
        'aria-label="Playlist FATWA">\n${rows(tracks)}      </ol>',
  );

  h = replaceOne(
    h,
    '<h2 id="player-title">Lecteur des khassaïdes</h2>',
    '<h2 id="fatwa-player-title">Lecteur FATWA</h2>',
    'titre lecteur',
  );
  h = replaceOne(
    h,
    '<audio id="audio-player" controls preload="none" aria-label="Lecteur audio des khassaïdes"></audio>',
    '<audio id="fatwa-player" controls preload="none" aria-label="Lecteur audio FATWA"></audio>',
    'lecteur',
  );
  h = h.replaceAll('data-audio-prev', 'data-fatwa-prev');
  h = h.replaceAll('data-audio-next', 'data-fatwa-next');
  h = replaceOne(
    h,
    '<p class="audio-status" id="audio-status" role="status" aria-live="polite">Choissez une piste pour commencer l’écoute.</p>',
    '<p class="audio-status" id="fatwa-status" role="status" aria-live="polite">'
    'Choisissez une question-réponse pour commencer l’écoute.</p>',
    'statut',
  );
  h = replaceOne(
    h,
    '<p>Pas de publicité, pas de formulaire, pas d’historique : la lecture s’ouvre dans votre navigateur. <a href="bibliotheque.html">Voir la bibliothèque →</a></p>',
    '<p>Pas de publicité, pas de formulaire, pas d’historique : la lecture '
    's’ouvre dans votre navigateur. <a href="audio.html">Revenir aux khassaïdes '
    'collectives →</a></p>',
    ' Pied de section',
  );
  write(newPage, h);
  stdout.writeln('Écrit : $newPage (${tracks.length} pistes)');
}

/// Le bouton FATWA prend la place 09, juste après Rajaz (08).
void patchHomeButton() {
  var html = read('index.html');
  if (html.contains('class="mouride-btn mouride-btn-fatwa"')) return;
  const rajazLine =
      '<a class="mouride-btn mouride-btn-rajaz" href="rajaz.html" '
      'aria-label="Rajaz — écouter les khassaïdes">'
      '<span class="mouride-btn-num" aria-hidden="true">08</span>'
      '<span>Rajaz</span></a>';
  if (!html.contains(rajazLine)) {
    throw StateError('Bouton Rajaz introuvable sur l’accueil');
  }
  const fatwaLine =
      '        <a class="mouride-btn mouride-btn-fatwa" href="fatwa.html" '
      'aria-label="FATWA — questions-réponses sur la religion">'
      '<span class="mouride-btn-num" aria-hidden="true">09</span>'
      '<span>FATWA</span></a>\r\n';
  html = replaceOne(html, '$rajazLine\r\n', '$rajazLine\r\n$fatwaLine', 'bouton Rajaz');
  write('index.html', html);
  stdout.writeln('Accueil : bouton FATWA ajouté après Rajaz');
}

void patchCss() {
  var css = read('assets\\css\\site.css');
  if (css.contains('.fatwa-filters')) return;
  css += '''

/* Filtres de la page FATWA : cibles larges, texte lisible sur mobile. */
.fatwa-filters {
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
.fatwa-filters label {
  display: flex;
  flex: 1 1 240px;
  flex-direction: column;
  gap: 6px;
  font-size: 14px;
  font-weight: 700;
  color: #F7E6A8;
}
.fatwa-filters select,
.fatwa-filters input {
  min-height: 48px;
  padding: 10px 12px;
  border: 1px solid rgba(201, 154, 46, 0.55);
  border-radius: 12px;
  background: #061E13;
  color: #FFF7E2;
  font: inherit;
  font-size: 16px;
}
.fatwa-filters p {
  flex-basis: 100%;
  margin: 0;
  font-size: 14px;
  color: #E7F0E6;
}
''';
  write('assets\\css\\site.css', css);
  stdout.writeln('CSS : filtres FATWA ajoutés');
}

const fatwaJs = r'''
  /* ---------- FATWA : un seul lecteur, filtres locaux, aucun téléchargement ---------- */
  function initFatwaPlaylist() {
    const player = $('#fatwa-player');
    const list = $('#fatwa-playlist');
    const status = $('#fatwa-status');
    const select = $('#fatwa-author');
    const search = $('#fatwa-search');
    const count = $('#fatwa-count');
    if (!player || !list) return;
    const rows = $$('.playlist-row', list);
    if (!rows.length) return;
    let current = null;

    const titleOf = (row) => row.dataset.title || 'cette question-réponse';
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
      const author = select ? select.value : '';
      const query = search ? search.value.trim().toLowerCase() : '';
      let shown = 0;
      rows.forEach((row) => {
        const authorOk = !author || row.dataset.author === author;
        const textOk = !query || (row.dataset.search || '').includes(query);
        row.hidden = !(authorOk && textOk);
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
        announce('Choisissez une question-réponse pour commencer l’écoute.');
      }
      reflect();
    };

    rows.forEach((row) => {
      const button = $('.playlist-play', row);
      if (button) button.addEventListener('click', () => setTrack(row, true));
    });
    const previous = $('[data-fatwa-prev]');
    const next = $('[data-fatwa-next]');
    if (previous) previous.addEventListener('click', () => step(-1));
    if (next) next.addEventListener('click', () => step(1));
    player.addEventListener('play', reflect);
    player.addEventListener('pause', reflect);
    player.addEventListener('ended', () => step(1));

    if (select) {
      const requested = new URLSearchParams(window.location.search).get('auteur');
      if (requested && rows.some((row) => row.dataset.author === requested)) {
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
  if (js.contains('function initFatwaPlaylist()')) return;
  js = replaceOne(
    js,
    "  document.addEventListener('DOMContentLoaded', () => {",
    '${fatwaJs.replaceAll('\n', '\r\n')}  document.addEventListener(\'DOMContentLoaded\', () => {',
    'DOMContentLoaded',
  );
  js = replaceOne(
    js,
    '    initRajazPlaylist();',
    '    initRajazPlaylist();\r\n    initFatwaPlaylist();',
    'appel FATWA',
  );
  write('assets\\js\\site.js', js);
  stdout.writeln('JS : lecteur et filtres FATWA ajoutés');
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
  xml = replaceOne(xml, '</urlset>', '$entry</urlset>', 'fin sitemap');
  write('sitemap.xml', xml);
  stdout.writeln('Sitemap : $newPage ajouté');
}

void patchSearch(Map<String, Object> data) {
  var js = read('assets\\js\\search-data.js');
  if (js.contains('"url":"$newPage"')) return;
  final entries = <Map<String, Object>>[
    {
      'kind': 'Page',
      'title': 'FATWA — questions-réponses sur la religion',
      'text': 'Questions-réponses religieuses de deux auteurs, à écouter en ligne.',
      'url': newPage,
      'external': false,
    },
  ];
  for (final author in data['authors'] as List<dynamic>) {
    entries.add({
      'kind': 'Audio',
      'title': 'FATWA — $author',
      'text': 'Questions-réponses religieuses avec $author, à écouter en ligne.',
      'url': '$newPage?auteur=${Uri.encodeQueryComponent(author.toString())}',
      'external': false,
    });
  }
  final injected = entries.map((entry) => '${jsonEncode(entry)},').join();
  js = replaceOne(
    js,
    'window.DIIWAANU_SEARCH_INDEX = [',
    'window.DIIWAANU_SEARCH_INDEX = [$injected',
    'index recherche',
  );
  write('assets\\js\\search-data.js', js);
  stdout.writeln('Recherche : ${entries.length} entrées FATWA ajoutées');
}

void patchAudit() {
  final path = 'tools\\audit_site.dart';
  var dart = read(path);
  dart = dart
      .replaceAll('if (files.length != 29)', 'if (files.length != 30)')
      .replaceAll('PAGES ATTENDUES : 29, trouvé', 'PAGES ATTENDUES : 30, trouvé')
      .replaceAll('if (locs.length != 29)', 'if (locs.length != 30)')
      .replaceAll('SITEMAP ATTENDU : 29 URL, trouvé', 'SITEMAP ATTENDU : 30 URL, trouvé')
      .replaceAll(
        "'mouride-btn-rajaz']) {",
        "'mouride-btn-rajaz', 'mouride-btn-fatwa']) {",
      );
  if (!dart.contains('final fatwaPage')) {
    const anchor = "  if (!voieInfos.contains('href=\"conferences.html\"')) {";
    const addition = r'''  final fatwaPage = read('fatwa.html');
  final fatwaCount = '<li class="playlist-row"'.allMatches(fatwaPage).length;
  if (fatwaCount != 61) {
    stdout.writeln('FATWA pistes : $fatwaCount (attendu 61)');
    problems++;
  }
  if (!fatwaPage.contains('id="fatwa-piste-001"') ||
      !fatwaPage.contains('id="fatwa-piste-061"') ||
      !fatwaPage.contains('id="fatwa-player"') ||
      !fatwaPage.contains('id="fatwa-author"') ||
      !fatwaPage.contains('id="fatwa-search"') ||
      !fatwaPage.contains('id="fatwa-count"')) {
    stdout.writeln('FATWA : page dédiée incomplète');
    problems++;
  }
  if (!fatwaPage.contains('/FATWA/fatwa_001.mp3') ||
      !fatwaPage.contains('/FATWA/fatwa_061.mp3')) {
    stdout.writeln('FATWA : URLs R2 manquantes');
    problems++;
  }
  if (RegExp(r'<audio\b').allMatches(fatwaPage).length != 1) {
    stdout.writeln('FATWA : le lecteur unique est attendu');
    problems++;
  }
  if (!siteJs.contains('function initFatwaPlaylist()') ||
      !siteJs.contains('initFatwaPlaylist();') ||
      !read('assets/css/site.css').contains('.fatwa-filters')) {
    stdout.writeln('FATWA : filtres ou CSS absents');
    problems++;
  }
  if (homeButtons.indexOf('mouride-btn-rajaz') >=
      homeButtons.indexOf('mouride-btn-fatwa')) {
    stdout.writeln('BOUTONS FATWA : doit suivre Rajaz sur l’accueil');
    problems++;
  }
''';
    dart = replaceOne(dart, anchor, '$addition$anchor', 'ancre audit');
  }
  write(path, dart);
  stdout.writeln('Audit : attentes 30 pages, 61 pistes FATWA et ordre du bouton');
}

void patchMemo(Map<String, Object> data) {
  final tracks = (data['tracks'] as List<dynamic>).length;
  var md = read('DEMARRAGE.md');
  if (!md.contains('`fatwa.html`')) {
    md = replaceOne(
      md,
      '- `index.html` : sept boutons mourides dans l’ordre',
      '- `fatwa.html` : $tracks questions-réponses sur la religion, regroupées '
      'par auteur (`Serigne Mbacke A. Rahmane`, 30, et `Serigne Cheikhouna '
      'Mbacke Abdoul Wadoud`, 31), avec filtre local, recherche et lecteur '
      'unique sur R2 `FATWA/` ; aucun téléchargement.\n'
      '- `index.html` : sept boutons mourides dans l’ordre',
      'mémo fatwa',
    );
  }
  md = md
      .replaceAll('29 pages, 29 URL', '30 pages, 30 URL')
      .replaceAll('29 pages · 29 URL · 879 entrées', '30 pages · 30 URL · 882 entrées')
      .replaceAll('879 entrées', '882 entrées')
      .replaceAll('Navigation déployée sur les 29 pages', 'Navigation déployée sur les 30 pages')
      .replaceAll('sept boutons mourides', 'huit boutons mourides')
      .replaceAll(
        '« Conférences » et « Rajaz » (bouton placé juste après le sous-menu Conférences).',
        '« Conférences », « Rajaz » et « FATWA » (Rajaz après le sous-menu '
        'Conférences, FATWA juste après Rajaz).',
      )
      .replaceAll(
        'le septième (« Rajaz », numéro 08) ouvrant `rajaz.html`.',
        'le septième (« Rajaz », numéro 08) ouvrant `rajaz.html` et le huitième '
        ' (« FATWA », numéro 09) ouvrant `fatwa.html`.',
      )
      .replaceAll('préfixe `AUDIO/`.', 'préfixes `AUDIO/` et `FATWA/`.');
  write('DEMARRAGE.md', md);
  stdout.writeln('Mémo : page FATWA documentée');
}

void patchGenerator() {
  final file = File('$appDir\\tools\\generate_site_pages.dart');
  var dart = file.readAsStringSync(encoding: utf8);
  if (dart.contains("MenuItem('FATWA', 'fatwa.html')")) return;
  dart = replaceOne(
    dart,
    "    MenuItem('Audio', 'audio.html'),\n",
    "    MenuItem('Audio', 'audio.html'),\n    MenuItem('FATWA', 'fatwa.html'),\n",
    'menu générateur',
  );
  file.writeAsStringSync(dart, encoding: utf8, flush: true);
  stdout.writeln('Générateur site : entrée FATWA ajoutée');
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
    if (!content.contains('?v=$oldVersion')) continue;
    entity.writeAsStringSync(
      content.replaceAll('?v=$oldVersion', '?v=$newVersion'),
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
    if (!content.contains('?v=$oldVersion')) continue;
    file.writeAsStringSync(
      content.replaceAll('?v=$oldVersion', '?v=$newVersion'),
      encoding: utf8,
      flush: true,
    );
    changed++;
  }
  stdout.writeln('Cache : $oldVersion → $newVersion sur $changed fichiers');
}

void main() {
  final data = loadData();
  if ((data['tracks'] as List).length != 61) {
    throw StateError('61 pistes FATWA attendues');
  }
  patchNavigation();
  buildPage(data);
  patchHomeButton();
  patchCss();
  patchJs();
  patchSitemap();
  patchSearch(data);
  patchAudit();
  patchMemo(data);
  patchGenerator();
  bumpCache();
  stdout.writeln('Terminé : page FATWA et cache $newVersion');
}
