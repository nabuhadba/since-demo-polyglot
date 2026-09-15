import 'dart:convert';

import 'package:http/http.dart' as http;

class Stop {
  Stop({required this.sequence, required this.shipmentId, required this.address});

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        sequence: json['sequence'] as int,
        shipmentId: json['shipmentID'] as String,
        address: json['address'] as String,
      );

  final int sequence;
  final String shipmentId;
  final String address;
}

class StopsApi {
  StopsApi(this.baseUrl, {http.Client? client}) : _client = client ?? http.Client();

  final Uri baseUrl;
  final http.Client _client;

  Future<List<Stop>> today(String driverId) async {
    final response = await _client.get(baseUrl.resolve('drivers/$driverId/stops/today'));
    if (response.statusCode != 200) {
      throw StateError('stops API answered ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((item) => Stop.fromJson(item as Map<String, dynamic>)).toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
  }
}
