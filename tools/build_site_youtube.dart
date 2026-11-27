// Ajout d’une section « En direct sur YouTube » dans media.html.
// Liens simples uniquement : aucun iframe, aucun script Google, aucun cookie sur le site.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const oldVersion = 'biblio30';
const version = 'biblio31';

final channels = <Map<String, Object>>[
  {
    'name': 'GMT -Tv — Grande Mosquée de Touba',
    'text': 'Chaîne officielle IP-TV de la Grande Mosquée de Touba, par Moukhaddamatoul Khidma : prières, conférences et directs depuis la mosquée.',
    'url': 'https://www.youtube.com/@GMTTv/streams',
    'index': 1,
  },
  {
    'name': 'Rafah TV International',
    'text': 'Chaîne culturelle et religieuse basée à Touba, près de la Grande Mosquée : directs, reportages et actualités mourides.',
    'url': 'https://www.youtube.com/@rafahtvinternational3478/streams',
    'index': 2,
  },
  {
    'name': 'Bichri TV International - HD',
    'text': 'Télévision islamique au service de Wakeur Xaadimu Rassoul : directs des Jataayu Mouride, Magal, Gamous et Ziarras.',
    'url': 'https://www.youtube.com/@bichritv/streams',
    'index': 3,
  },
  {
    'name': 'As-Samadiyya TV',
    'text': 'Dahira Yi du Dimanche : enseignements, rencontres et retransmissions en direct en haute définition.',
    'url': 'https://www.youtube.com/@as-samadiyyatv7927/streams',
    'index': 4,
  },
  {
    'name': 'Al Khadimiyyah TV',
    'text': 'Chaîne dédiée au patrimoine mouride : khassaïdes en continu, enseignements et directs depuis Touba.',
    'url': 'https://www.youtube.com/channel/UCqbQTS505CVDNNmPI0KwoYA/streams',
    'index': 5,
  },
  {
    'name': 'Al Mouridiyyah TV',
    'text': 'Chaîne d’Hizbut Tarqiyyah, « À la découverte de l’Univers Touba » : matinale As-Sabaah et directs.',
    'url': 'https://www.youtube.com/@Almouridiyyah_Tv_Officiel/streams',
    'index': 6,
  },
  {
    'name': 'Touba TV Officiel',
    'text': 'Directs et événements de Touba : discours du Khalife général,Magal et rencontres de la cité sainte.',
    'url': 'https://www.youtube.com/channel/UCavUkP6uhnT8wJpFgu-Q3kg/streams',
    'index': 7,
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

String videoCards() => channels.map((c) {
      final n = (c['index'] as int).toString().padLeft(2, '0');
      return '''        <article class="video-card">
          <div class="video-card-head"><span class="card-index">$n</span><h3>${c['name']}</h3></div>
          <p>${c['text']}</p>
          <p><a class="video-btn" href="${c['url']}" target="_blank" rel="noopener noreferrer">Regarder sur YouTube ↗</a></p>
        </article>''';
    }).join('\n');

const videoSection = r'''
    <section class="video-direct" id="direct-youtube">
      <div class="section-head">
        <span class="kicker">En direct</span>
        <h2>Les chaînes mourides sur YouTube</h2>
        <p>Sept chaînes qui diffusent des prières, des enseignements et des grands rendez-vous mourides. Chaque lien ouvre l’onglet « Direct » de la chaîne dans un nouvel onglet. Nous n’intégrons aucun lecteur YouTube ici : aucun cookie ni suivi Google n’est chargé sur notre page.</p>
      </div>
      <p class="video-note">Les directs dépendent de ces chaînes externes : leur disponibilité et leurs programmes ne sont pas contrôlés par Diiwaanu Xassida Yi.</p>
      <div class="video-grid">
__CARDS__
      </div>
      <p class="video-note">Aucune vidéo n’est hébergée ni copiée sur ce site. Ces liens sont fournis à titre d’accès aux diffusions publiques.</p>
    </section>
''';

void patchMedia() {
  final file = File('$siteDir/media.html');
  var html = file.readAsStringSync();
  if (html.contains('id="direct-youtube"')) return;

  html = html.replaceFirst(
    'Écoutez les khassaïdes en ligne et parcourez les captures de l’application, sans lecteur externe ni suivi.',
    'Écoutez les khassaïdes en ligne, parcourez les captures de l’application et trouvez les directs mourides sur YouTube, sans lecteur intégré ni suivi.',
  );

  const cardMarker = '''        <article class="card"><div class="mark" aria-hidden="true">03</div><h3>Icône du projet</h3><p>La même icône accompagne le site et l’application Android, dans un cadre vert profond et or.</p><p><a class="btn btn-gold" href="assets/app-icon.png" target="_blank" rel="noopener">Voir l’icône →</a></p></article>''';
  if (!html.contains(cardMarker)) {
    stdout.writeln('MÉDIA : carte 03 introuvable');
    return;
  }
  html = html.replaceFirst(cardMarker, '''$cardMarker
        <article class="card"><div class="mark" aria-hidden="true">04</div><h3>En direct sur YouTube</h3><p>Les chaînes mourides et la Grande Mosquée de Touba, en simples liens externes : aucun lecteur Google intégré.</p><p><a class="btn btn-gold" href="#direct-youtube">Voir les chaînes →</a></p></article>''');

  final endMarker = RegExp(r'  </div>\r?\n</main>');
  if (!endMarker.hasMatch(html)) {
    stdout.writeln('MÉDIA : fin de main introuvable');
    return;
  }
  html = html.replaceFirst(endMarker, "${videoSection.replaceAll('__CARDS__', videoCards())}  </div>\n</main>");
  write(file.path, html);
  stdout.writeln('Média : section YouTube ajoutée');
}

const cssInsert = r'''
/* ---------- Chaînes YouTube en direct : liens simples, aucun lecteur intégré ---------- */
.video-direct { margin-top: 26px; scroll-margin-top: 24px; }
.video-direct .section-head { margin-bottom: 14px; }
.video-note {
  margin: 0 0 16px;
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
  padding: 18px;
  border: 1px solid rgba(201, 154, 46, .42);
  border-top: 3px solid rgba(201, 154, 46, .72);
  border-radius: var(--radius);
  background: rgba(6, 30, 19, .78);
}
.video-card-head { display: flex; align-items: baseline; gap: 10px; }
.video-card h3 { margin: 0; color: #FFF7E2; font-size: 1.12rem; line-height: 1.35; }
.video-card p { margin: 0; color: #E7F0E6; }
.video-card .video-btn { margin-top: auto; }
.video-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 48px;
  padding: 10px 16px;
  border: 1px solid var(--gold);
  border-radius: 999px;
  background: rgba(201, 154, 46, .18);
  color: var(--gold-light);
  font-size: 1rem;
  font-weight: 800;
  text-decoration: none;
}
.video-btn:hover, .video-btn:focus-visible {
  background: rgba(201, 154, 46, .30);
  color: #FFF7E2;
  text-decoration: none;
}
@media (min-width: 860px) {
  .video-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
}
''';

void patchCss() {
  final file = File('$siteDir/assets/css/site.css');
  var css = file.readAsStringSync();
  if (css.contains('.video-direct')) return;
  css = css.trimRight() + '\n\n' + cssInsert;
  write(file.path, css);
}

void patchSearch() {
  final file = File('$siteDir/assets/js/search-data.js');
  var js = file.readAsStringSync();
  if (js.contains('"kind":"Chaîne YouTube"')) return;
  final entries = channels.map((c) => jsonEncode(<String, dynamic>{
        'kind': 'Chaîne YouTube',
        'title': c['name'],
        'text': "${c['text']} Regarder sur YouTube — directs mourides.",
        'url': c['url'],
        'external': true,
      })).join(',');
  final after = js.replaceFirst(RegExp(r'\];\s*$'), ',$entries];');
  if (after == js) {
    stdout.writeln('INDEX : fin de tableau introuvable');
    return;
  }
  write(file.path, after);
  stdout.writeln('Index recherche : ${channels.length} chaînes ajoutées');
}

void patchRecherche() {
  final file = File('$siteDir/recherche.html');
  var html = file.readAsStringSync();
  if (html.contains('data-search-kind="Chaîne YouTube"')) return;
  const marker = '''          <button type="button" data-search-kind="Audio" aria-pressed="false">Audio</button>''';
  if (!html.contains(marker)) {
    stdout.writeln('RECHERCHE : bouton Audio introuvable');
    return;
  }
  html = html.replaceFirst(marker, '''$marker
          <button type="button" data-search-kind="Chaîne YouTube" aria-pressed="false">Chaînes</button>''');
  write(file.path, html);
}

const auditInsert = r'''
  final media = read('media.html');
  for (final marker in ['id="direct-youtube"', 'Regarder sur YouTube ↗']) {
    if (!media.contains(marker)) {
      stdout.writeln('MEDIA $marker : absent');
      problems++;
    }
  }
  final videoLinks = RegExp(r'class="video-btn"').allMatches(media).length;
  if (videoLinks != 7) {
    stdout.writeln('MEDIA liens YouTube : $videoLinks (attendu 7)');
    problems++;
  }
  if (media.contains('youtube.com/embed') || media.contains('youtube-nocookie') || media.contains('<iframe')) {
    stdout.writeln('MEDIA : lecteur YouTube intégré détecté');
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
    if (text.contains('MEDIA liens YouTube')) continue;
    if (!text.contains(finalMarker)) {
      stdout.writeln('AUDIT : marqueur final introuvable dans ${file.uri.pathSegments.last}');
      continue;
    }
    text = text.replaceFirst(finalMarker, auditInsert + finalMarker);
    write(file.path, text);
  }
}

void patchMemo() {
  final file = File('$siteDir/DEMARRAGE.md');
  var text = file.readAsStringSync();
  if (text.contains('sept chaînes mourides en liens simples')) return;
  const marker = '- `index.html` : quatre boutons mourides juste au-dessus de la grille « À la une ».';
  if (!text.contains(marker)) {
    stdout.writeln('MÉMO : marqueur introuvable');
    return;
  }
  text = text.replaceFirst(marker, '''- `media.html#direct-youtube` : sept chaînes mourides en liens simples « Regarder sur YouTube » (GMT-Tv, Rafah TV, Bichri TV, As-Samadiyya TV, Al Khadimiyyah TV, Al Mouridiyyah TV, Touba TV). Aucun iframe, aucun cookie Google.
$marker''');
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
