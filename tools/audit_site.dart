import 'dart:io';

// À lancer depuis la racine du dépôt : dart run tools/audit_site.dart
final dir = Directory.current.path;

void main() {
  final files = Directory(dir)
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.html'))
      .toList()
    ..sort((a, b) => a.uri.pathSegments.last.compareTo(b.uri.pathSegments.last));

  var problems = 0;
  final idsByFile = <String, Set<String>>{};
  final hrefRe = RegExp(r'href="([^"]+)"');
  final idRe = RegExp(r'\sid="([^"]+)"');

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    final html = file.readAsStringSync();
    final ids = idRe.allMatches(html).map((m) => m.group(1)!).toList();
    idsByFile[name] = ids.toSet();
    if (ids.length != ids.toSet().length) {
      stdout.writeln('IDS DOUBLONNÉS $name : $ids');
      problems++;
    }
    final backdrops = '<div class="menu-backdrop"'.allMatches(html).length;
    if (backdrops != 1) {
      stdout.writeln('BACKDROP $name : $backdrops');
      problems++;
    }
    if (!html.contains('?v=biblio42')) {
      stdout.writeln('CACHE $name : absent');
      problems++;
    }
    if (html.contains('biblio28')) {
      stdout.writeln('CACHE $name : biblio28 restant');
      problems++;
    }
    if (!html.contains('https://www.diiwaanu-xassida-yi.com/')) {
      stdout.writeln('CANONIQUE $name : absent');
      problems++;
    }
  }

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    final html = file.readAsStringSync();
    for (final match in hrefRe.allMatches(html)) {
      final href = match.group(1)!;
      if (href.startsWith('http') || href.startsWith('mailto:') || href.startsWith('tel:')) continue;
      if (href.startsWith('#')) {
        final anchor = href.substring(1);
        if (anchor.isNotEmpty && !idsByFile[name]!.contains(anchor)) {
          stdout.writeln('ANCRE MANQUANTE $name → $href');
          problems++;
        }
        continue;
      }
      final clean = href.split('#').first.split('?').first;
      if (clean.isEmpty) continue;
      final target = File('$dir/$clean');
      if (!target.existsSync()) {
        stdout.writeln('LIEN CASSÉ $name → $href');
        problems++;
        continue;
      }
      final anchor = href.contains('#') ? href.split('#').last : '';
      if (anchor.isNotEmpty && !idsByFile[clean]!.contains(anchor)) {
        stdout.writeln('ANCRE DISTANTE MANQUANTE $name → $href');
        problems++;
      }
    }
  }

  final sitemap = File('$dir/sitemap.xml').readAsStringSync();
  final locs = RegExp(r'<loc>([^<]+)</loc>').allMatches(sitemap).map((m) => m.group(1)!).toList();
  for (final loc in locs) {
    final name = loc.split('/').last.isEmpty ? 'index.html' : loc.split('/').last;
    if (!File('$dir/$name').existsSync()) {
      stdout.writeln('SITEMAP CASSÉ $loc');
      problems++;
    }
  }

  if (files.length != 24) {
    stdout.writeln('PAGES ATTENDUES : 24, trouvé ${files.length}');
    problems++;
  }
  if (locs.length != 24) {
    stdout.writeln('SITEMAP ATTENDU : 24 URL, trouvé ${locs.length}');
    problems++;
  }

  String read(String name) => File('$dir/$name').readAsStringSync();
  final home = read('index.html');
  for (final marker in ['id="videos-accueil"', 'id="nos-videos"', 'id="direct-youtube"', 'id="agenda-accueil"', 'href="actualites.html"', 'href="recherche.html"', 'href="conferences.html"']) {
    if (!home.contains(marker)) {
      stdout.writeln('ACCUEIL $marker : absent');
      problems++;
    }
  }

  if (home.contains('<span class="kicker">À la une</span>')) {
    stdout.writeln('ACCUEIL : bloc « À la une » toujours présent');
    problems++;
  }
  final homeApercus = 'class="youtube-preview"'.allMatches(home).length;
  if (homeApercus != 7) {
    stdout.writeln('ACCUEIL aperçus YouTube : $homeApercus (attendu 7)');
    problems++;
  }
  if (home.contains('<iframe')) {
    stdout.writeln('ACCUEIL : lecteur intégré détecté');
    problems++;
  }
  final voie = read('voie-mouride.html');
  for (final marker in ['id="sous-rubriques"', 'id="fondements"', 'id="lumiere"']) {
    if (!voie.contains(marker)) {
      stdout.writeln('VOIE $marker : absent');
      problems++;
    }
  }
  final chapitres = RegExp(r'href="xam-yoonwi\.html#chapitre-\d+"').allMatches(voie).length;
  if (chapitres < 6) {
    stdout.writeln('VOIE sous-rubriques : $chapitres liens de chapitre');
    problems++;
  }

  final audio = read('audio.html');
  final pistes = '<li class="playlist-row"'.allMatches(audio).length;
  final lecteurs = '<audio'.allMatches(audio).length;
  if (pistes != 23 || lecteurs != 1) {
    stdout.writeln('AUDIO : $pistes pistes, $lecteurs lecteurs');
    problems++;
  }
  if (audio.contains('download')) {
    stdout.writeln('AUDIO : lien de téléchargement présent');
    problems++;
  }

  final recherche = read('recherche.html');
  if (!recherche.contains('assets/js/search-data.js')) {
    stdout.writeln('RECHERCHE : index statique absent');
    problems++;
  }
  final indexJs = read('assets/js/search-data.js');
  final entrees = '"kind":'.allMatches(indexJs).length;
  if (entrees < 800) {
    stdout.writeln('RECHERCHE : $entrees entrées (attendu ≥ 800)');
    problems++;
  }
  final siteJs = read('assets/js/site.js');
  for (final marker in ['function initAudioPlaylist()', 'function initGlobalSearch()', 'initAudioPlaylist();', 'initGlobalSearch();']) {
    if (!siteJs.contains(marker)) {
      stdout.writeln('JS $marker : absent');
      problems++;
    }
  }

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    final html = file.readAsStringSync();
    if (!html.contains('<noscript>') || !html.contains('href="agenda.html"') || !html.contains('href="recherche.html"')) {
      stdout.writeln('NAVIGATION $name : noscript ou nouveaux liens absents');
      problems++;
    }
  }

  final homeButtons = read('index.html');
  for (final marker in ['class="mouride-actions"', '>Info mouride<', '>Xam sa serigne<', '>Xam sa diine<', '>Galerie mouride<', '>Taalif<', '>Conférences<']) {
    if (!homeButtons.contains(marker)) {
      stdout.writeln('BOUTONS $marker : absents');
      problems++;
    }
  }
  if (!File('$dir/assets/pdf/xarnubi.pdf').existsSync()) {
    stdout.writeln('PDF Taalif : assets/pdf/xarnubi.pdf absent');
    problems++;
  }
  final taalif = read('taalif.html');
  if (!taalif.contains('id="taalif"') ||
      !taalif.contains('class="taalif-palette"') ||
      RegExp(r'class="vers"').allMatches(taalif).length < 1000) {
    stdout.writeln('TAALIF : page, palette ou vers absents');
    problems++;
  }
  final voieInfos = read('voie-mouride.html');
  for (final anchor in ['info-mouride', 'xam-sa-serigne', 'xam-sa-diine', 'galerie-mouride', 'conferences']) {
    if (!voieInfos.contains('id="$anchor"')) {
      stdout.writeln('SECTION $anchor : absente');
      problems++;
    }
  }
  if (RegExp(r'class="gallery-item"').allMatches(voieInfos).length < 12) {
    stdout.writeln('GALERIE : moins de 12 portraits');
    problems++;
  }
  final jsMouride = read('assets/js/site.js');
  if (!jsMouride.contains('function initMourideGallery()') || !jsMouride.contains('initMourideGallery();')) {
    stdout.writeln('JS galerie : absent');
    problems++;
  }

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
  final confPage = read('conferences.html');
  final conferences = 'class="playlist-row"'.allMatches(confPage).length;
  if (conferences != 22) {
    stdout.writeln('CONFERENCES pistes : $conferences (attendu 22)');
    problems++;
  }
  final confCss = read('assets/css/site.css');
  if (!confPage.contains('id="conferences"') ||
      !confPage.contains('id="playlist"') ||
      !confPage.contains('id="piste-01"') ||
      !confPage.contains('id="piste-22"') ||
      !confPage.contains('assets/conferences/serigne-moustapha-saliou.jpg') ||
      !confCss.contains('serigne-moustapha-saliou-clair.jpg') ||
      !confCss.contains('.conf-stage') ||
      !confCss.contains('.conf-playlist')) {
    stdout.writeln('CONFERENCES : page dédiée incomplète');
    problems++;
  }
  if (!confPage.contains('/CONFERENCES/s._moustapha_saliou_-_01.mp3') ||
      !confPage.contains('/CONFERENCES/s._moustapha_saliou_-_22.mp3')) {
    stdout.writeln('CONFERENCES : URLs R2 manquantes');
    problems++;
  }
  if (RegExp(r'<audio\b').allMatches(confPage).length != 1) {
    stdout.writeln('CONFERENCES : le lecteur unique est attendu');
    problems++;
  }
  if (!voieInfos.contains('href="conferences.html"')) {
    stdout.writeln('VOIE : lien vers la page conférences absent');
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
  stdout.writeln('Pages : ${files.length} · URLs sitemap : ${locs.length} · Index recherche : $entrees · Problèmes : $problems');
}
