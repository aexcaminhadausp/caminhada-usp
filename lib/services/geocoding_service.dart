import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {

  static Future<LatLng?> getCoordinates(String query) async {

    final url =
        "https://nominatim.openstreetmap.org/search"
        "?q=${Uri.encodeComponent(query)}"
        "&format=json"
        "&limit=1";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "caminhadausp-app"
      },
    );

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);

    if (data.isEmpty) return null;

    return LatLng(
      double.parse(data[0]["lat"]),
      double.parse(data[0]["lon"]),
    );
  }
}
