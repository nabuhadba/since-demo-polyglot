import 'dart:convert';

import 'package:driver_app/src/stops_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('stops come back in sequence order', () async {
    final client = MockClient((request) async => http.Response(
          jsonEncode([
            {'sequence': 2, 'shipmentID': 'SHP-2', 'address': '2 Elm St'},
            {'sequence': 1, 'shipmentID': 'SHP-1', 'address': '1 Oak Ave'},
          ]),
          200,
        ));
    final stops = await StopsApi(Uri.parse('https://api.example/'), client: client).today('d-1');
    expect(stops.map((s) => s.shipmentId), ['SHP-1', 'SHP-2']);
  });
}
