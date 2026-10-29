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
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 30),
              responseType: ResponseType.bytes,
              headers: {'User-Agent': 'fleetwise-feed-sync/1.3'},
            ));

  final Dio _dio;

  Future<List<Rate>> fetch(String carrier, String url) async {
    try {
      final response = await _dio.get<List<int>>(url);
      return ratesFromZip(response.data ?? const []);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw FeedUnavailable(carrier, 'timed out');
      }
      throw FeedUnavailable(carrier, e.message ?? e.type.name);
    }
  }
}
