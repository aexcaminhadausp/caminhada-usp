import 'dart:convert';

import 'package:app/components/controll_route_button.dart';
import 'package:app/components/route_statistic_tracking_label.dart';
import 'package:app/screens/campus_manual_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class RouteTracking extends StatefulWidget {
  final LatLng start;
  final LatLng end;

  const RouteTracking({
    super.key,
    required this.start,
    required this.end,
  });

  @override
  State<RouteTracking> createState() => _RouteTrackingState();
}

class _RouteTrackingState extends State<RouteTracking> {
  List<List<LatLng>> _routes = [];
  int _selectedRouteIndex = 0;

  double _distanceKm = 0;
  double _durationMin = 0;

  @override
  void initState() {
    super.initState();
    calculateRoutes();
  }

  Future<void> calculateRoutes() async {
    final manualRoute = CampusManualRoutes.getManualRoute(
      widget.start,
      widget.end,
    );

    if (manualRoute != null) {
      final distance = const Distance();
      double totalMeters = 0;

      for (int i = 0; i < manualRoute.length - 1; i++) {
        totalMeters += distance(manualRoute[i], manualRoute[i + 1]);
      }

      setState(() {
        _routes = [manualRoute];
        _selectedRouteIndex = 0;
        _distanceKm = totalMeters / 1000;
        _durationMin = (_distanceKm / 4.5) * 60;
      });

      print("Manual route loaded successfully");
      return;
    }

    final url =
        "https://router.project-osrm.org/route/v1/foot/"
        "${widget.start.longitude},${widget.start.latitude};"
        "${widget.end.longitude},${widget.end.latitude}"
        "?overview=full&geometries=geojson&alternatives=true&steps=true";

    print("Routing URL: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print("Routing failed");
      return;
    }

    final data = jsonDecode(response.body);

    if (data["routes"] == null || data["routes"].isEmpty) {
      print("No routes found");
      return;
    }

    List<List<LatLng>> routes = [];

    for (var route in data["routes"]) {
      final coordinates = route["geometry"]["coordinates"];

      List<LatLng> points = coordinates.map<LatLng>((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();

      routes.add(points);
    }

    final selected = data["routes"][0];

    setState(() {
      _routes = routes;
      _distanceKm = selected["distance"] / 1000;
      _durationMin = selected["duration"] / 60;
    });

    print("Automatic route loaded successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: widget.start,
              zoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.caminhadausp',
              ),
              PolylineLayer(
                polylines: List.generate(
                  _routes.length,
                      (index) {
                    return Polyline(
                      points: _routes[index],
                      strokeWidth: 5,
                      color: index == _selectedRouteIndex
                          ? Colors.blue
                          : Colors.grey,
                    );
                  },
                ),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.start,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  Marker(
                    point: widget.end,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.25,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RouteStatisticTrackingLabel(
                          icon: Icons.directions_walk,
                          label: "Tempo",
                          value: "${_durationMin.toStringAsFixed(1)} min",
                        ),
                        RouteStatisticTrackingLabel(
                          icon: Icons.map,
                          label: "Distância",
                          value: "${_distanceKm.toStringAsFixed(2)} km",
                        ),
                      ],
                    ),
                    if (_routes.length > 1)
                      Column(
                        children: List.generate(
                          _routes.length,
                              (index) {
                            return ListTile(
                              title: Text("Rota ${index + 1}"),
                              subtitle: Text(
                                index == 0 ? "Mais rápida" : "Alternativa",
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedRouteIndex = index;
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ControllRoteButton(
                  icone: Icons.play_arrow_outlined,
                  iconSize: 60,
                  buttonSize: 80,
                  color: Colors.green,
                  finish: false,
                ),
                SizedBox(width: 10),
                ControllRoteButton(
                  icone: Icons.stop_outlined,
                  iconSize: 30,
                  buttonSize: 50,
                  color: Colors.blueGrey,
                  finish: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}