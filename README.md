# DEPRECATED
As of Angel `1.1.0`, this package is unnecessary, as the functionality to compress responses has been inlined into the framework itself.

See the migration guide:
https://angel-dart.gitbook.io/angel/migration-guide

# compress

[![version 1.0.0+2](https://img.shields.io/badge/pub-v1.0.0+2-brightgreen.svg)](https://pub.dartlang.org/packages/angel_compress)
[![build status](https://travis-ci.org/angel-dart/compress.svg)](https://travis-ci.org/angel-dart/compress)

Angel hook to compress responses in a variety of formats.

```dart
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_compress/angel_compress.dart';
import 'package:lzw/lzw.dart';

main() {
  var app = new Angel();
  
  // GZIP is the easiest to add
  app.responseFinalizers.add(gzip());
  
  // Support any other codec
  app.responseFinalizers.add(compress('lzw', LZW));
}
```
