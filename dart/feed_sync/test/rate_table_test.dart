import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:feed_sync/feed_sync.dart';
import 'package:test/test.dart';

List<int> zipOf(Map<String, String> files) {
  final archive = Archive();
  files.forEach((name, text) {
    final bytes = utf8.encode(text);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  });
  return ZipEncoder().encode(archive)!;
}

void main() {
  test('reads rates.csv and skips the header', () {
    final rates = ratesFromZip(zipOf({
      'rates.csv': 'origin,destination,cents\nCHI,DEN,18500\nDEN,SLC,12250\n',
      'README.txt': 'ignore me',
    }));
    expect(rates.map((r) => r.toCsv()), ['CHI,DEN,18500', 'DEN,SLC,12250']);
  });

  test('a zip without rates.csv is a format error', () {
    expect(() => ratesFromZip(zipOf({'other.csv': 'x'})), throwsFormatException);
  });
}
