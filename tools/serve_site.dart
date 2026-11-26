import 'dart:io';

void main() async {
  // À lancer depuis la racine du dépôt : dart run tools/serve_site.dart
  final root = Directory.current.path;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8765);
  stdout.writeln('SERVEUR PRET http://127.0.0.1:8765/');
  await for (final request in server) {
    try {
      var path = Uri.decodeComponent(request.uri.path);
      if (path == '/' || path.isEmpty) path = '/index.html';
      final segments = path.split('/').where((p) => p.isNotEmpty && p != '.' && p != '..');
      final file = File([root, ...segments].join(Platform.pathSeparator));
      if (!file.existsSync()) {
        request.response.statusCode = 404;
        request.response.write('Introuvable : $path');
        await request.response.close();
        continue;
      }
      final ext = file.uri.pathSegments.last.split('.').last.toLowerCase();
      ContentType type;
      switch (ext) {
        case 'html':
          type = ContentType('text', 'html', charset: 'utf-8');
          break;
        case 'css':
          type = ContentType('text', 'css', charset: 'utf-8');
          break;
        case 'js':
          type = ContentType('application', 'javascript', charset: 'utf-8');
          break;
        case 'json':
          type = ContentType('application', 'json', charset: 'utf-8');
          break;
        case 'png':
          type = ContentType('image', 'png');
          break;
        case 'jpg':
          type = ContentType('image', 'jpeg');
          break;
        case 'svg':
          type = ContentType('image', 'svg+xml');
          break;
        case 'mp3':
          type = ContentType('audio', 'mpeg');
          break;
        default:
          type = ContentType('application', 'octet-stream');
      }
      request.response.headers.contentType = type;
      request.response.headers.add('Cache-Control', 'no-store');
      request.response.add(file.readAsBytesSync());
    } catch (error) {
      request.response.statusCode = 500;
      request.response.write('Erreur : $error');
    }
    await request.response.close();
  }
}
