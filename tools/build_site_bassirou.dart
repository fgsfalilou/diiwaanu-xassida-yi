// Construit la page des conférences de Serigne Bassirou Mbacke Xelcome sur le
// modèle de conferences-bousso-seck.html, puis synchronise navigation, styles,
// sitemap, recherche, audit, mémo et cache des assets (biblio51).

import 'dart:convert';
import 'dart:io';

const siteDir = r'C:\Users\akman\AppData\Local\Temp\opencode\diiwaanu-site';
const appDir = r'C:\Users\akman\Documents\khassida_app';
const photoSource =
    r'C:\Users\akman\Downloads\MediaHuman\Musique\Serigne bassirou mbacke kelcom\serignebassiroumbackexelcom.png';
const r2Base = 'https://pub-f07ad970b3b84dfa8539a6cf6ce3f5b3.r2.dev';
const newPage = 'conferences-bassirou-mbacke.html';
const speaker = 'Serigne Bassirou Mbacke Xelcome';
const shortSpeaker = 'S. Bassirou Mbacke';
const photoName = 'serignebassiroumbackexelcom.png';
const prefix = 'CONFERENCES_BASSIROU_MBACKE';

const titresBassirouMbacke = <String>[
  "Jaar Jaari Serigne Touba (Part 1)",
  "Al-Khulafa Ar-Rashidun (radhi Allahû 'anhûm)- {Seydina Abu Bakr AS-Siddiq} (R.A) [1]",
  "Al-Khulafa Ar-Rashidun (radhi Allahû 'anhûm)- {Seydina Abu Bakr AS-Siddiq} (R.A) [2]",
  "Waxtan — An Nabi (alayhi salam)- {Seydina Moussa, Khidr & Zul-Qarnain}",
  "Al-Khulafa Ar-Rashidun (radhi Allahû 'anhûm)- {Seydina Umar Al-Farooq} (R.A) [1]",
  "S. Bassirou Mbacke Khelcom Talks About Serigne Saliou",
  "Al-Khulafa Ar-Rashidun (radhi Allahû 'anhûm)- {Seydina Umar Al-Farooq} (R.A) [2]",
  "Al-Khulafa Ar-Rashidun (radhi Allahû 'anhûm)- {Seydina Umar Al-Farooq} (R.A) [3]",
  "Serigne Bassirou Mbacke Khelcome — Nguem (Part 1)",
  "Serigne Bassirou Mbacke Khelcome — Nguem (Part 2)",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 1",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 2",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 3",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 4",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 5",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 6",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 7",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 8",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 9",
  "S. Bassirou Khelcom — Histoire Yonentebi (SAW) - Guinawam",
  "S. Bassirou Khelcom — Histoire Yonentebi (SAW) - Jaffe Jaffeyi",
  "S. Bassirou Khelcom — Histoire Yonentebi (SAW) - Xare Badr",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 10",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 11",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 12",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 13",
  "L'Histoire du Prophet Moussa (AS) En Wolof [Part 2]",
  "L'Histoire du Prophet Moussa (AS) En Wolof [Part 3]",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 14",
  "S. Bassirou Khelcom — Histoire Prophet Muhammad (SAW) Part 15",
  "L'Histoire du Prophet Moussa (AS) En Wolof [Part 1]",
  "L'Histoire du Prophet Moussa (AS) En Wolof [Part 4]",
  "S. Bassirou Khelcom — Les Oeuvres de Serigne Touba",
  "S. Bassirou Khelcom — Tassawouf (Part 1)",
  "S. Bassirou Khelcom — Tassawouf (Part 2)",
  "Seringe Bassirou Mbacke Khelcom. Waadial Magal Touba",
  "Qui était Serigne Touba, Portrait décrit par Serigne Bassirou Mbacké Khelcom",
  "Plateau 4 — Les Qualités du Prophète (PSL) par S. Bass Khelcom [1]",
  "Plateau 4 — Les Qualités du Prophète (PSL) par S. Bass Khelcom [2]",
  "denkaaney serigne touba",
  "serigne bachir mbacke mooy waxtaan ci beug yalla",
  "Journées Abdoulahi wa Khadim Rassoul France 2013",
  "Serigne Bassirou Mbacké (Khelcom)",
  "Serigne Bassirou Khelcom DAY 2 June 12th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 10 June 20th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 3 June 13th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 6 June 16th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 7 June 17th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 8 June 18th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 9 June 19th 2013 Calgary",
  "Kaan mooy Serigne Souhaibou Mbacké Serigne Bassirou Khelcom DAY 16 June 29th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 11 June 25th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 12 June 26th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 13 June 27th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 14 June 28th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 4 June 14th 2013 Calgary",
  "Serigne Bassirou Khelcom DAY 5 June 15th 2013 Calgary",
  "Karbala",
  "Khisa Seydina Ayyoba (alayhi salam)",
  "Kane moy serigne Touba avec serigne bassirou Mbacke",
  "Les bienfaits des Qacaïd par Cheikh Bassirou Mbacké ibn Serigne Abdoul Karim",
  "Serigne Bassirou Mbacké (khelcom) à Taverny",
  "journées 2011 — Serigne Bassirou MBACKE Khelcom",
  "Serigne Basirou Khelcom — tarbiyyah et téguin selon Cheikhoul Khadim",
  "Serigne Bass Khelcom — Le Ramadan (fondements, principes et bienfaits)",
  "www.assirah.com — Universite Du Magal 2013, 5 Safar",
  "Laylatoul khadr Serigne Bassirou Mbacké (khelcom)",
  "Serigne Bassirou Mbacké Khelcom 11 novembre 2014",
  "Journée Khassida Dialibatoul Marakhib 2015 — Discours Serigne Bass Khelcom",
  "Journée Khassida Touba Ndiéne Edition 2015 2",
  "S. Bassirou Khelcom — Immigration and Education Calgary 2015",
  "S. Bassirou Khelcom — Story of Prophet Zakariya and his son Yahya Calgary 20152",
  "Entretien-Exclusif avec Serigne Bassirou MBACKE Khelcom",
  "Serigne Bassirou Mbacké Khelcom 11 novembre 2015",
  "FIMA JAAR reçoit S. Bassirou Khelcom",
  "Comment CHEIKH AHMADOU BAMBA célébrait le Maouloud (Gamou) — S. Bassirou Khelcom",
  "SERIGNE BASSIROU MBACKÉ KHELCOM DAARA SERIGNE FALLOU IBN SERIGNE CHOUHIBOU PISTE 1",
  "SERIGNE BASSIROU MBACKÉ KHELCOM DAARA SERIGNE FALLOU IBN SERIGNE CHOUHIBOU PISTE 2",
  "Sogné Journée Khassaides 2016 des Etats Unis par Serigne Bassirou Mbacke, Xelkom",
  "Journée Khassaides des Etats Unis, Cincinnati 2016 — Waxtaan - Serigne Bassirou Mbacké, Xelkom",
  "Seg Bassirou Mbacke Khelcom at Dahira Touba Washington DC",
  "Seg Bassirou Mbacke Khelcom Touba Washington Tontu ladji",
  "Qassida Day Edmonton May 2016 S Bassirou Khelcom",
  "Serigne Bassirou Mbacké Khelcom Journée Xassida Espagne 2016",
  "Serigne Bassirou Mbacké Khelcom Waxtaan ci koor partie 1",
  "Serigne Bassirou Mbacké Khelcom Waxtaan ci koor partie 2",
  "Les Sublimes Noms d'ALLAH à travers Taysiroul Hasir par Serigne Bassirou Mbacké Khelcom ALLAH",
  "S. Bassirou Mbacké Khelcom — Les Sublimes Noms d'ALLAH à travers Taysiroul Hasir (AR RAHMAN AR RAHIM)",
  "S. Bassirou Mbacké Khelcom — Les Sublimes Noms d'ALLAH à travers Taysiroul Hassir { AL MALIKOU}",
  "AL QOUDDOUS avec S. Bass Khelcom — {Les Sublimes Noms d'ALLAH à travers Taysiroul Hassir}",
  "AS-SALAM avec S. Bassirou Mbacké Khelcom {Les Sublimes Noms d'ALLAH à travers Taysiroul Hassir }",
  "AL-JABBAR avec S. Bassirou Mbacké Khelcom {Les Sublimes Noms d'ALLAH à travers Taysiroul Hassir}",
  "AL-MOUHAYMIN avec S. Bassirou Mbacké Khelcom {Les Sublimes Noms d'ALLAH à travers Taysiroul Hassir }",
  "XASSIDA AK TARBIYYAH — Serigne Bassirou Mbacké Khelcom ak Serigne Abo Mbacké Imam {Taverny 2011}",
  "Serigne Bassirou Mbacké Xelcom (Magal 11 novembre ) Thème — la famille",
  "SEYDINA OUSMANE {AL KHOULAFAOU RACHIDOUNE}- Serigne Bassirou Mbacké Khelcom",
  "SIRA SEYDINA ALIOUNE (RA) Part.1 {AL KHOULAFAOU RACHIDOUNE} - S. BASSIROU MBACKE XELCOM",
  "SIRA SEYDINA ALIOUNE Part. 2 {AL KHOULAFAOU RACHIDOUNE} - S. BASSIROU MBACKE XELCOM-",
  "SIRA SEYDINA ALIOUNE (RA) Part.3 {AL KHOULAFAOU RACHIDOUNE} - S. BASSIROU MBACKE XELCOM-",
  "SIRA SEYDINA ALIOUNE Part.4 et Fin {AL KHOULAFAOU RACHIDOUNE} - S. BASSIROU MBACKE XELCOM",
  "LE PROPHÈTE IBRAHIM (AS) Part.1~ SERIGNE BASSIROU MBACKE XELCOM~",
  "LE PROPHÈTE IBRAHIM (AS) Part.2~ SERIGNE BASSIROU MBACKE XELCOM~",
  "LE PROPHÈTE IBRAHIM (AS) Part. 3 et Fin - S. BASSIROU MBACKE XELCOM~",
  "LE PROPHÈTE YOUSSOUF (AS) Part.1 - SERIGNE BASSIROU MBACKÉ KHELCOM-",
  "LE PROPHÈTE YOUSSOUF (AS) Part.2 et Fin- S. BASSIROU MBACKE KHELCOM-",
  "QISSA SEYDINA SOULEYMANE (AS) Part. 1 - S. BASSIROU MBACKE KHELCOM-",
  "QISSA SEYDINA SOULEYMANE (AS) Part 2 et Fin - S. BASSIROU MBACKÉ KHELCOM-",
  "L'HISTOIRE DU PROPHÈTE ADAM (AS) Part.1 - S. BASSIROU MBACKÉ KHELCOM",
  "L' HISTOIRE DU PROPHÈTE ADAM (AS) Part. 2 et Fin - S. BASSIROU MBACKÉ KHELCOM",
  "TARIXOU SENEGAL , SERIGNE BI, LAT DIOR.....avec S. Bassirou Mbacké Khelcom",
  "KHOUTBA KORITÉ 2010 (Arabe et Wolof) - S. BASSIROU MBACKÉ KHELCOM-",
  "Magalou Khassida Yi 2016 — Waxtaanou Serigne Bassirou Mbacke Khelcom",
  "S. Bassirou Mbacké Khelcom — Yitté Diou kawé (Ramadan 2016)",
  "S. Bassirou Mbacké Khelcom — Journée Xassida Touba Ndiéné (février 2016)",
  "S. Bassirou Mbacké Xelcom — Thiant {Ay Firndèm si Alquran ak sunna ak xèt yinekoy défé}",
  "S. Bassirou Mbacké xelcom — Q — R sur les prêts bancaires et les aides des non croyants",
  "S. Bassirou Mbacké Khelcom — Serigne Touba ak yengou yimou dane yengou nguir défar",
  "Une archive des causeries de S. Bass Khelcom — Diam ak Orma {dans les années 2000}",
  "S. Bassirou Mbacké Khelcom — Université Du Magal 2013",
  "19 — S. Bassirou Mbacké Xelcom — Moujouk Yonéntébi (saw), aw Mélokanam ak ay Djikom",
  "Seydina Insaa-Ibn-Mariam (Partie1) - S. Bassirou Mbacké Khelcom",
  "Seydina Insaa-Ibn-Mariam (Partie2) - S. Bassirou Mbacké Khelcom~",
  "20 — S. Bassirou Mbacké Khelcom — Guinaw bi Yonéntébi (saw) lakho, xewxew ya thia am, ay soxnam",
  "S. Bassirou Mbacké Khelcom — Abdoullahi Wa Xadimou Rassoul (Taverny, France 2012)",
  "6 — S. Bassirou Mbacké Khelcom — Bi Yonéntébi (saw) yéksê madina ak lamoufa ndieuka taxawal",
  "7 — Serigne Bassirou Mbacké Khelcom — Xareb Badr",
  "S. Bass Khelcom — Nane la Serigne Touba Doné Karangué ak Laxatou kaay",
  "8 — S. Bassirou Mbacké Khelcom — Lên ci linou meuna djangué ci Xaréb Badr",
  "9 — Les vaillants de Badr — mérites et considérations - S. Bassirou Mbacké Khelcom",
  "10 — S. Bassirou Mbacké Khelcom — La Médine de l'entre-deux-batailles (Badr et Ouhoud)",
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

final boussoPlain = RegExp(
  r'<a href="conferences-bousso-seck\.html"(?: aria-current="page")?>Conférences — S\. Bousso Seck</a>',
);
const boussoSub =
    '<a href="conferences-bousso-seck.html"><span class="mouride-sub-num" aria-hidden="true">03</span><span>Serigne Bousso Seck</span></a>';
const newPlain =
    '<a href="conferences-bassirou-mbacke.html">Conférences — S. Bassirou Mbacke</a>';
const newSub =
    '<a href="conferences-bassirou-mbacke.html"><span class="mouride-sub-num" aria-hidden="true">04</span><span>Serigne Bassirou Mbacke Xelcome</span></a>';

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
    if (line.contains(boussoSub)) {
      output.add('$indent$newSub');
      continue;
    }
    final match = boussoPlain.firstMatch(line);
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

String playlistRows() => List<String>.generate(titresBassirouMbacke.length, (i) {
      final n = (i + 1).toString().padLeft(3, '0');
      final titre = titresBassirouMbacke[i];
      final full = 'Conférence $n — $speaker : $titre';
      final src = '$r2Base/$prefix/s._bassirou_mbacke_-_$n.mp3';
      return '''        <li class="playlist-row" id="bassirou-piste-$n"
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
      '<a class="btn btn-gold-outline" href="conferences-bassirou-mbacke.html">Conférences de S. Bassirou Mbacke →</a>';
  for (final page in [
    'conferences.html',
    'conferences-saliou-sow.html',
    'conferences-bousso-seck.html',
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
      '<a class="btn btn-gold-outline" href="conferences-bousso-seck.html">S. Bousso Seck →</a>';
  if (voie.contains(voieAnchor) && !voie.contains(newPage)) {
    voie = voie.replaceFirst(
      voieAnchor,
      '$voieAnchor <a class="btn btn-gold-outline" href="$newPage">S. Bassirou Mbacke →</a>',
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
    '<body id="haut" class="conf-page conf-bassirou">',
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
    '<p>Retrouvez ici cent trente enregistrements de $speaker, réunis pour une écoute calme et sans distraction.</p>',
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
    '<a class="btn btn-gold-outline" href="conferences-bousso-seck.html">Conférences de S. Bousso Seck →</a></div>',
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
  if (css.contains('.conf-bassirou .conf-header')) return;
  css += '''

/* ---------- Conférences de Serigne Bassirou Mbacke Xelcome ---------- */
.conf-bassirou .conf-header {
  background-image:
    radial-gradient(circle at 88% 0%, rgba(201,154,46,.22), transparent 42%),
    linear-gradient(180deg, rgba(6, 30, 19, .34), rgba(6, 30, 19, .76)),
    url("../conferences/$photoName"),
    linear-gradient(155deg, var(--night), var(--green-2) 70%, var(--night-2));
  background-position: center, center, center 38%, center;
}
.conf-bassirou .conf-stage {
  background-image:
    linear-gradient(180deg, rgba(6, 30, 19, .30), rgba(6, 30, 19, .78) 62%, rgba(6, 30, 19, .90)),
    url("../conferences/$photoName");
}
''';
  write(path, css);
  stdout.writeln('CSS : variante conf-bassirou ajoutée');
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
        'Cent trente conférences de $speaker à écouter en ligne, sans compte ni publicité.',
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
      .replaceAll('if (files.length != 26)', 'if (files.length != 27)')
      .replaceAll('PAGES ATTENDUES : 26, trouvé', 'PAGES ATTENDUES : 27, trouvé')
      .replaceAll('if (locs.length != 26)', 'if (locs.length != 27)')
      .replaceAll('SITEMAP ATTENDU : 26 URL, trouvé', 'SITEMAP ATTENDU : 27 URL, trouvé');
  if (!dart.contains('final bassirouPage')) {
    const anchor = "  if (!voieInfos.contains('href=\"conferences.html\"')) {";
    const addition = r'''  final bassirouPage = read('conferences-bassirou-mbacke.html');
  final bassirouCount = 'class="playlist-row"'.allMatches(bassirouPage).length;
  if (bassirouCount != 130) {
    stdout.writeln('BASSIROU MBACKE pistes : $bassirouCount (attendu 130)');
    problems++;
  }
  final bassirouCss = read('assets/css/site.css');
  if (!bassirouPage.contains('id="conferences"') ||
      !bassirouPage.contains('id="playlist"') ||
      !bassirouPage.contains('id="bassirou-piste-001"') ||
      !bassirouPage.contains('id="bassirou-piste-130"') ||
      !bassirouPage.contains('assets/conferences/serignebassiroumbackexelcom.png') ||
      !bassirouCss.contains('.conf-bassirou .conf-header') ||
      !bassirouCss.contains('serignebassiroumbackexelcom.png')) {
    stdout.writeln('BASSIROU MBACKE : page dédiée incomplète');
    problems++;
  }
  if (!bassirouPage.contains('/CONFERENCES_BASSIROU_MBACKE/s._bassirou_mbacke_-_001.mp3') ||
      !bassirouPage.contains('/CONFERENCES_BASSIROU_MBACKE/s._bassirou_mbacke_-_130.mp3')) {
    stdout.writeln('BASSIROU MBACKE : URLs R2 manquantes');
    problems++;
  }
  if (RegExp(r'<audio\b').allMatches(bassirouPage).length != 1) {
    stdout.writeln('BASSIROU MBACKE : le lecteur unique est attendu');
    problems++;
  }
''';
    dart = dart.replaceFirst(anchor, '$addition$anchor');
  }
  write(path, dart);
  stdout.writeln('Audit : attentes 27 pages et 130 pistes Bassirou Mbacke');
}

void patchMemo() {
  final path = '$siteDir\\DEMARRAGE.md';
  var md = read(path);
  md = md
      .replaceAll('26 pages, 26 URL', '27 pages, 27 URL')
      .replaceAll('26 pages · 26 URL', '27 pages · 27 URL')
      .replaceAll('837 entrées', '838 entrées')
      .replaceAll('Navigation déployée sur les 26 pages', 'Navigation déployée sur les 27 pages')
      .replaceAll(
        'trois entrées : « Serigne Moustapha Saliou »',
        'quatre entrées : « Serigne Moustapha Saliou »',
      );
  if (!md.contains('`conferences-bassirou-mbacke.html`')) {
    md = md.replaceFirst(
      '- `index.html` : six boutons mourides',
      '- `conferences-bassirou-mbacke.html` : cent trente conférences de Serigne Bassirou Mbacke '
      'Xelcome, même structure que `conferences.html` (photo fournie dans le dossier audio, un '
      'seul lecteur, playlist R2 `CONFERENCES_BASSIROU_MBACKE/`, aucun téléchargement).\n'
      '- `index.html` : six boutons mourides',
    );
    md = md.replaceFirst(
      '`conferences-bousso-seck.html`, 14 MP3, préfixe R2 `CONFERENCES_BOUSSO_SECK/`) ; lecteur unique et aucun téléchargement.',
      '`conferences-bousso-seck.html`, 14 MP3, préfixe R2 `CONFERENCES_BOUSSO_SECK/`) et « Serigne '
      'Bassirou Mbacke Xelcome » (`conferences-bassirou-mbacke.html`, 130 MP3, préfixe R2 '
      '`CONFERENCES_BASSIROU_MBACKE/`) ; lecteur unique et aucun téléchargement.',
    );
  }
  write(path, md);
  stdout.writeln('Mémo : page Bassirou Mbacke documentée');
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
  if (titresBassirouMbacke.length != 130) {
    throw StateError('130 titres attendus');
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
  stdout.writeln('Terminé : 130 conférences $speaker');
}
