import 'package:feed_sync/feed_sync.dart';
import 'package:test/test.dart';

void main() {
  test('an unreachable host is reported as unavailable', () async {
    final client = FeedClient();
    await expectLater(
      client.fetch('acme', 'http://127.0.0.1:9/feed.zip'),
      throwsA(isA<FeedUnavailable>()),
    );
  });
}
