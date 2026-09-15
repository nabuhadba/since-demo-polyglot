import 'package:flutter/material.dart';

import 'src/stops_api.dart';

void main() {
  runApp(DriverApp(api: StopsApi(Uri.parse('https://api.fleetwise.example/'))));
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key, required this.api});

  final StopsApi api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleetwise Driver',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: StopsScreen(api: api, driverId: 'me'),
    );
  }
}

class StopsScreen extends StatelessWidget {
  const StopsScreen({super.key, required this.api, required this.driverId});

  final StopsApi api;
  final String driverId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's stops")),
      body: FutureBuilder<List<Stop>>(
        future: api.today(driverId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Could not load stops: ${snapshot.error}'));
          }
          final stops = snapshot.data;
          if (stops == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              for (final stop in stops)
                ListTile(
                  leading: CircleAvatar(child: Text('${stop.sequence}')),
                  title: Text(stop.shipmentId),
                  subtitle: Text(stop.address),
                ),
            ],
          );
        },
      ),
    );
  }
}
