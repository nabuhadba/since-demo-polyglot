import 'package:archive/archive.dart';

/// One lane's rate, in cents per pallet.
class Rate {
  Rate(this.origin, this.destination, this.centsPerPallet);

  final String origin;
  final String destination;
  final int centsPerPallet;

  String toCsv() => '$origin,$destination,$centsPerPallet';
}

/// Reads `rates.csv` out of a carrier's zip. Other files in the zip are ignored.
List<Rate> ratesFromZip(List<int> zipBytes) {
  final archive = ZipDecoder().decodeBytes(zipBytes);
  final file = archive.findFile('rates.csv');
  if (file == null) {
    throw const FormatException('feed has no rates.csv');
  }
  final text = String.fromCharCodes(file.content as List<int>);
  return text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('origin,'))
      .map((line) {
    final parts = line.split(',');
    if (parts.length != 3) {
      throw FormatException('bad rate line', line);
    }
    return Rate(parts[0], parts[1], int.parse(parts[2]));
  }).toList();
}
