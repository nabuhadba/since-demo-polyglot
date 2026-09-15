import 'dart:io';

import 'package:args/args.dart';
import 'package:feed_sync/feed_sync.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('carrier', abbr: 'c', mandatory: true)
    ..addOption('url', abbr: 'u', mandatory: true)
    ..addOption('out', abbr: 'o', defaultsTo: 'out');
  final args = parser.parse(arguments);

  final carrier = args['carrier'] as String;
  final rates = await FeedClient().fetch(carrier, args['url'] as String);
  final out = File(p.join(args['out'] as String, '$carrier.csv'));
  await out.parent.create(recursive: true);
  await out.writeAsString(rates.map((rate) => rate.toCsv()).join('\n'));
  stdout.writeln('wrote ${rates.length} rates to ${out.path}');
}
