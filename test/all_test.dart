import 'dart:convert';
import 'dart:io';
import 'package:angel_compress/angel_compress.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:test/test.dart';

main() {
  HttpClient client;
  HttpServer server;
  String url;

  setUp(() async {
    client = new HttpClient();
    server = await createServer().startServer();
    url = 'http://${server.address.address}:${server.port}';
  });

  tearDown(() async {
    await server.close(force: true);
    client.close(force: true);
    client = null;
    url = null;
  });

  test('can compress', () async {
    var rq = await client.getUrl(Uri.parse('$url/greet'));
    rq.headers.add(HttpHeaders.ACCEPT_ENCODING, 'gzip');
    var response = await rq.close();
    var bytes =
        (await response.toList()).reduce((a, b) => []..addAll(a)..addAll(b));
    var body = new String.fromCharCodes(bytes);

    print('Body: ${body}');
    print('Headers: ${response.headers}');
    expect(body, isNot(equals('"Hello world"')));

    var decoded = new String.fromCharCodes(GZIP.decode(bytes));
    expect(decoded, equals('Hello world'));
  });

  test('can compress if no header', () async {
    var rq = await client.getUrl(Uri.parse('$url/greet'));
    var response = await rq.close();
    var bytes =
        (await response.toList()).reduce((a, b) => []..addAll(a)..addAll(b));
    var body = new String.fromCharCodes(bytes);

    print('Body: ${body}');
    print('Headers: ${response.headers}');
    expect(body, isNot(equals('"Hello world"')));

    var decoded = new String.fromCharCodes(GZIP.decode(bytes));
    expect(decoded, equals('Hello world'));
  });

  test('only when header is added or empty', () async {
    var rq = await client.getUrl(Uri.parse('$url/greet'));
    rq.headers.add(HttpHeaders.ACCEPT_ENCODING, 'not-gzip');
    var response = await rq.close();
    var bytes =
        (await response.toList()).reduce((a, b) => []..addAll(a)..addAll(b));
    var body = new String.fromCharCodes(bytes);

    print('Body: ${body}');
    print('Headers: ${response.headers}');
    expect(body, equals('"Hello world"'));
  });
}

Angel createServer() {
  var app = new Angel()..get('/greet', 'Hello world');
  app.responseFinalizers
    ..add(compress('gzip', GZIP))
    ..add((req, res) async {
      print('Final buf: ' + new String.fromCharCodes(res.buffer.toBytes()));
    });
  return app;
}