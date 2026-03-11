import 'package:latlong2/latlong.dart';

class CampusRouteService {
  // PONTOS FIXOS NO CAMPUS PARA A ROTA A PÉ
  static final LatLng bibliotecaCentral = LatLng(-21.1672, -47.8516);
  static final LatLng restauranteCentral = LatLng(-21.159711737143247, -47.84768748180572);
  static final LatLng centroEsportivo = LatLng(-21.169240638521572, -47.852560874992385);
  static final LatLng faculdadeFilosofiaExatas = LatLng(-21.1665, -47.8473);
  static final LatLng faculdadeFilosofiaHumanas = LatLng(-21.1637, -47.8589);

  // LISTA COM TODOS OS PONTOS
  static final List<LatLng> pontosCampus = [
    bibliotecaCentral,
    restauranteCentral,
    centroEsportivo,
    faculdadeFilosofiaExatas,
    faculdadeFilosofiaHumanas,
  ];
}
