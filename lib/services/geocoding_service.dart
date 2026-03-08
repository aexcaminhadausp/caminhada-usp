import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {

  static Future<LatLng?> getCoordinates(String query) async {

    // Bounding box aproximado da USP Ribeirão Preto
    const viewbox =
        "-47.865,-21.175,-47.845,-21.155";

    final url =
        "https://nominatim.openstreetmap.org/search"
        "?q=${Uri.encodeComponent(query)}"
        "&format=json"
        "&limit=1"
        "&viewbox=$viewbox"
        "&bounded=1"
        "&accept-language=pt-BR";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "caminhadausp-app"
      },
    );

    print("Geocoding URL: $url");
    print("Response: ${response.body}");

    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);

    if (data.isEmpty) {
      return null;
    }

    final lat = double.parse(data[0]["lat"]);
    final lon = double.parse(data[0]["lon"]);

    return LatLng(lat, lon);
  }
}