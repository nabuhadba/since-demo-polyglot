import 'package:dio/dio.dart';

import 'rate_table.dart';

/// Thrown when a carrier's feed cannot be fetched.
class FeedUnavailable implements Exception {
  FeedUnavailable(this.carrier, this.reason);

  final String carrier;
  final String reason;

  @override
  String toString() => 'feed for $carrier unavailable: $reason';
}

class FeedClient {
  FeedClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: 5000,
              receiveTimeout: 30000,
              responseType: ResponseType.bytes,
              headers: {'User-Agent': 'fleetwise-feed-sync/1.3'},
            ));

  final Dio _dio;

  Future<List<Rate>> fetch(String carrier, String url) async {
    try {
      final response = await _dio.get<List<int>>(url);
      return ratesFromZip(response.data ?? const []);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
        throw FeedUnavailable(carrier, 'timed out');
      }
      throw FeedUnavailable(carrier, e.message);
    }
  }
}
