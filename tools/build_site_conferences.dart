// Ajoute les boutons « Taalif » et « Conférences » après « Galerie mouride » sur l'accueil,
// et une section d'écoute de 22 MP3 hébergés sur R2 dans voie-mouride.html.

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const oldVersion = 'biblio34';
const version = 'biblio45';
const r2Base = 'https://pub-f07ad970b3b84dfa8539a6cf6ce3f5b3.r2.dev';

List<String> get noms => List<String>.generate(
      22,
      (i) => 's._moustapha_saliou_-_${(i + 1).toString().padLeft(2, '0')}.mp3',
    );

String titre(int i) => 'Conférence ${(i + 1).toString().padLeft(2, '0')} — S. Moustapha Saliou';

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
    '$siteDir\\tools\\build_site_home_videos.dart',
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

void patchHomeButton() {
  final path = '$siteDir\\index.html';
  var html = File(path).readAsStringSync();
  if (html.contains('href="taalif.html"')) return;
  const galerie = '''        <a class="mouride-btn" href="voie-mouride.html#galerie-mouride"><span class="mouride-btn-num" aria-hidden="true">04</span><span>Galerie mouride</span></a>''';
  if (!html.contains(galerie)) {
    stdout.writeln('ACCUEIL : bouton Galerie mouride introuvable');
    return;
  }
  html = html.replaceFirst(galerie, '''$galerie
        <a class="mouride-btn mouride-btn-taalif" href="taalif.html" aria-label="Taalif — lire Xarnubi en ligne"><span class="mouride-btn-num" aria-hidden="true">05</span><span>Taalif</span><span class="mouride-btn-call" lang="ar" dir="rtl" aria-hidden="true">تأليف</span></a>''');
  html = html.replaceFirst('aria-hidden="true">05</span><span>Conférences', 'aria-hidden="true">06</span><span>Conférences');
  write(path, html);
  stdout.writeln('Accueil : bouton Taalif ajouté après Galerie mouride');
}

String conferenceItems() => List<String>.generate(noms.length, (i) {
      final n = (i + 1).toString().padLeft(2, '0');
      final t = titre(i);
      return '''            <div class="conference-item">
              <h3><span class="card-index">$n</span>$t</h3>
              <audio controls preload="none" controlsList="nodownload" aria-label="Écouter $t">
                <source src="$r2Base/CONFERENCES/${noms[i]}" type="audio/mpeg">
                Votre navigateur ne lit pas les fichiers audio MP3.
              </audio>
            </div>''';
    }).join('\n');

void patchVoie() {
  final path = '$siteDir\\voie-mouride.html';
  var html = File(path).readAsStringSync();
  if (html.contains('id="conferences"')) return;
  const dialog = '''      <dialog class="gallery-lightbox" id="gallery-lightbox" aria-label="Portrait mouride agrandi">''';
  if (!html.contains(dialog)) {
    stdout.writeln('VOIE : lightbox introuvable');
    return;
  }
  final section = '''      <article class="info-block" id="conferences">
        <div class="info-copy">
          <span class="kicker">05 — Conférences</span>
          <h2>Les conférences de S. Moustapha Saliou</h2>
          <p>Vingt-deux enregistrements écoutables en ligne depuis notre stockage R2. Le bouton play est celui du navigateur : aucun MP3 n’est enregistré sur l’appareil et aucun suivi n’est ajouté.</p>
          <div class="links"><a class="btn btn-gold" href="audio.html">Écouter les khassaïdes →</a></div>
        </div>
        <div class="conference-list">
${conferenceItems()}
        </div>
      </article>

''';
  html = html.replaceFirst(dialog, section + dialog);
  write(path, html);
  stdout.writeln('Voie mouride : section Conférences avec ${noms.length} MP3');
}

const cssNew = r'''
/* ---------- Conférences : écoute en ligne, lecteur natif, aucun téléchargement ---------- */
.conference-list {
  display: grid;
  grid-template-columns: minmax(0, 1fr);
  gap: 12px;
}
.conference-item {
  padding: 12px;
  border: 1px solid rgba(201, 154, 46, .36);
  border-radius: 12px;
  background: rgba(3, 20, 12, .55);
}
.conference-item h3 {
  margin: 0 0 8px;
  color: #FFF7E2;
  font-size: 1rem;
  line-height: 1.4;
}
.conference-item audio {
  display: block;
  width: 100%;
  min-height: 48px;
}
@media (min-width: 860px) {
  .conference-list { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}
''';

void patchCss() {
  final file = File('$siteDir\\assets\\css\\site.css');
  var css = file.readAsStringSync();
  if (css.contains('.conference-list')) return;
  css = css.trimRight() + '\n\n' + cssNew;
  write(file.path, css);
}

void patchSearch() {
  final path = '$siteDir\\assets\\js\\search-data.js';
  var js = File(path).readAsStringSync();
  if (js.contains('"kind":"Conférence"')) return;
  const prefix = 'window.DIIWAANU_SEARCH_INDEX = ';
  if (!js.startsWith(prefix)) {
    stdout.writeln('INDEX : préfixe inattendu');
    return;
  }
  final raw = js.substring(prefix.length).replaceFirst(RegExp(r';\s*$'), '');
  final list = jsonDecode(raw) as List<dynamic>;
  for (var i = 0; i < noms.length; i++) {
    list.add(<String, dynamic>{
      'kind': 'Conférence',
      'title': titre(i),
      'text': 'Enregistrement audio écoutable en ligne depuis le stockage R2 du projet.',
      'url': 'voie-mouride.html#conferences',
      'external': false,
    });
  }
  write(path, '$prefix${jsonEncode(list)};');
  stdout.writeln('Index recherche : ${noms.length} conférences ajoutées (total ${list.length})');
}

void patchRecherche() {
  final path = '$siteDir\\recherche.html';
  var html = File(path).readAsStringSync();
  if (html.contains('data-search-kind="Conférence"')) return;
  const marker = '''          <button type="button" data-search-kind="Chaîne YouTube" aria-pressed="false">Chaînes</button>''';
  if (!html.contains(marker)) {
    stdout.writeln('RECHERCHE : bouton Chaînes introuvable');
    return;
  }
  html = html.replaceFirst(marker, '''$marker
          <button type="button" data-search-kind="Conférence" aria-pressed="false">Conférences</button>''');
  write(path, html);
}

const auditNew = r'''
  final conferences = 'class="conference-item"'.allMatches(voieInfos).length;
  if (conferences != 22) {
    stdout.writeln('CONFERENCES pistes : $conferences (attendu 22)');
    problems++;
  }
  if (!voieInfos.contains('/CONFERENCES/s._moustapha_saliou_-_01.mp3') ||
      !voieInfos.contains('/CONFERENCES/s._moustapha_saliou_-_22.mp3')) {
    stdout.writeln('CONFERENCES : URLs R2 manquantes');
    problems++;
  }
  final indexConferences = '"kind":"Conférence"'.allMatches(indexJs).length;
  if (indexConferences != 22) {
    stdout.writeln('INDEX conférences : $indexConferences (attendu 22)');
    problems++;
  }
  if (!recherche.contains('data-search-kind="Conférence"')) {
    stdout.writeln('RECHERCHE filtre conférences : absent');
    problems++;
  }
''';

void patchAudit() {
  final path = '$siteDir\\tools\\audit_site.dart';
  var text = File(path).readAsStringSync();
  if (!text.contains("'>Taalif<'")) {
    text = text.replaceFirst(
      "'>Galerie mouride<'",
      "'>Galerie mouride<', '>Taalif<', '>Conférences<'",
    );
  }
  if (!text.contains("'conferences']")) {
    text = text.replaceFirst(
      "'galerie-mouride']",
      "'galerie-mouride', 'conferences']",
    );
  }
  if (!text.contains('CONFERENCES pistes')) {
    const finalMarker = "  stdout.writeln('Pages : \${files.length}";
    text = text.replaceFirst(finalMarker, auditNew + finalMarker);
  }
  write(path, text);
}

void patchMemo() {
  final path = '$siteDir\\DEMARRAGE.md';
  var text = File(path).readAsStringSync();
  if (text.contains('Taalif')) return;
  text = text.replaceAll('814 entrées', '836 entrées');
  const marker = '- `index.html#videos-accueil` :';
  if (!text.contains(marker)) {
    stdout.writeln('MÉMO : marqueur accueil introuvable');
    return;
  }
  text = text.replaceFirst(
    marker,
    '- `index.html` : bouton mouride « Taalif » inséré après « Galerie mouride », vers `taalif.html` (texte extrait du PDF et mis en page avec la palette vert/or).\n$marker',
  );
  write(path, text);
}

void main() {
  bumpVersion();
  patchHomeButton();
  patchVoie();
  patchCss();
  patchSearch();
  patchRecherche();
  patchAudit();
  patchMemo();
  stdout.writeln('Terminé : $version');
}
