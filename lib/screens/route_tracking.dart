import 'dart:async';
import 'dart:convert';

import 'package:app/components/controll_route_button.dart';
import 'package:app/components/route_statistic_tracking_label.dart';
import 'package:app/screens/route_statistic.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class RouteTracking extends StatefulWidget {
  final LatLng start;
  final LatLng end;
  final int? preferenceType;
  final int destinationId;

  const RouteTracking({
    super.key,
    required this.start,
    required this.end,
    this.preferenceType,
    required this.destinationId,
  });

  @override
  State<RouteTracking> createState() => _RouteTrackingState();
}

class _RouteTrackingState extends State<RouteTracking> {
  List<List<LatLng>> _routes = [];
  int _selectedRouteIndex = 0;
  bool _isRouteSaved = false;
  bool _isNavigating = false;
  final double _arrivalThreshold = 15.0;
  final Stopwatch _stopwatch = Stopwatch(); 
  double _distanceToTarget = 0.0;           

  double _distanceKm = 0;
  double _durationMin = 0;
  List<double> _routeDistances = [];
  List<double> _routeDurations = [];

  LatLng? _currentPosition;
  List<LatLng> _activeRouteLine = [];
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.start;
    calculateRoutes();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> calculateRoutes() async {
    final url =
        "https://routing.openstreetmap.de/routed-foot/route/v1/driving/"
        "${widget.start.longitude},${widget.start.latitude};"
        "${widget.end.longitude},${widget.end.latitude}"
        "?overview=full&geometries=geojson&alternatives=true&steps=true";

    print("Routing URL: $url");

    try {
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
      List<double> distances = [];
      List<double> durations = [];

      for (var route in data["routes"]) {
        final coordinates = route["geometry"]["coordinates"];

        List<LatLng> points = coordinates.map<LatLng>((coord) {
          return LatLng(coord[1], coord[0]);
        }).toList();

        routes.add(points);
        distances.add(route["distance"] / 1000);
        durations.add(route["duration"] / 60);
      }

      final selected = data["routes"][0];

      setState(() {
        _routes = routes;
        _routeDistances = distances;
        _routeDurations = durations;
        _distanceKm = selected["distance"] / 1000;
        _durationMin = selected["duration"] / 60;
        if (routes.isNotEmpty) {
          _activeRouteLine = List.from(routes[0]);
        }
      });

      print("Automatic route loaded successfully");
    } catch (e) {
      print("Erro ao buscar rota na API OSRM: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sem conexão com a internet para calcular a rota.")));
      }
    }
  }

  String encodePolyline(List<LatLng> points) {
    var lastLat = 0;
    var lastLng = 0;
    var result = StringBuffer();

    void encode(int v) {
      v = v < 0 ? ~(v << 1) : v << 1;
      while (v >= 0x20) {
        result.write(String.fromCharCode((0x20 | (v & 0x1f)) + 63));
        v >>= 5;
      }
      result.write(String.fromCharCode(v + 63));
    }

    for (var point in points) {
      var lat = (point.latitude * 1e5).round();
      var lng = (point.longitude * 1e5).round();
      encode(lat - lastLat);
      encode(lng - lastLng);
      lastLat = lat;
      lastLng = lng;
    }
    return result.toString();
  }

  void _updateRouteProgress(LatLng currentPos) {
    if (_routes.isEmpty) return;

    final distance = const Distance();
    final route = _routes[_selectedRouteIndex];
    
    int closestIndex = 0;
    double minDistance = double.infinity;
    
    // Procura o ponto mais próximo na rota
    for (int i = 0; i < route.length; i++) {
      double d = distance.as(LengthUnit.Meter, currentPos, route[i]);
      if (d < minDistance) {
        minDistance = d;
        closestIndex = i;
      }
    }

    // Calcula a distância restante ao longo da rota
    double remainingDistance = 0;
    if (closestIndex < route.length) {
      remainingDistance += minDistance;
      for (int i = closestIndex; i < route.length - 1; i++) {
        remainingDistance += distance.as(LengthUnit.Meter, route[i], route[i+1]);
      }
    }

    // Cria a linha da rota consumida (começa do usuário e segue do ponto mais próximo até o final)
    List<LatLng> consumedRouteLine = [currentPos];
    if (closestIndex < route.length) {
       consumedRouteLine.addAll(route.sublist(closestIndex));
    }

    setState(() {
      _currentPosition = currentPos;
      _distanceToTarget = remainingDistance;
      _activeRouteLine = consumedRouteLine;
    });
  }

  void _startNavigation() {
    if (_isNavigating) return; // Proteção contra múltiplos inícios
    setState(() => _isNavigating = true);
    _stopwatch.start();
    _startTracking();
  }

  void _startTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen(
      (Position position) {
        if (!mounted) return;

        final currentPos = LatLng(position.latitude, position.longitude);
        final metersRemainingToDest = const Distance().as(LengthUnit.Meter, currentPos, widget.end);
        
        _updateRouteProgress(currentPos);
        
        try {
          _mapController.move(currentPos, _mapController.camera.zoom);
        } catch (e) {
          debugPrint("Erro no MapController: $e");
        }

        // Chegada ao destino
        if (metersRemainingToDest <= _arrivalThreshold && !_isRouteSaved) {   
          _saveRouteToHistory();
        }
      },
      onError: (error) {
        debugPrint("Erro no GPS durante tracking: $error");
        // Opcional: Mostrar alerta de perda de sinal
      },
    );
  }


  Future<void> _saveRouteToHistory() async {
    if (_isRouteSaved) return; // Proteção contra múltiplos disparos

    String encodedPath = encodePolyline(_routes[_selectedRouteIndex]);
    final double finalDistanceKm = _distanceKm;
    final int totalSeconds = _stopwatch.elapsed.inSeconds;

    final data = {
      "destination_id": widget.destinationId,
      "polyline": encodedPath,
      "distance": finalDistanceKm * 1000, // Backend espera em metros
      "rate": null
    };

    final historyId = await ApiService.saveRoute(data);

    if (historyId != null && mounted) {
      setState(() => _isRouteSaved = true);

      _stopwatch.stop();
      _positionStream?.cancel();
      _positionStream = null;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Destino alcançado! Trajeto registado."),
          backgroundColor: Colors.green,
        ),

      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatisticRouteScreen(
            historyId: historyId,
            distanceKm: finalDistanceKm,
            timeInSeconds: totalSeconds,
          ),
        ),
      );
    } else if (mounted) {
      // Se falhar o salvamento crítico, avisamos o utilizador
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao sincronizar trajeto com o servidor."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _showStopDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Encerrar Rota"),
        content: const Text("O que você deseja fazer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Continuar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text("Sair da Rota", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveRouteToHistory(); // Finaliza e salva
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Já cheguei", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.start,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.caminhadausp',
              ),
              if (_routes.isNotEmpty)
                PolylineLayer(
                  polylines: List.generate(
                    _routes.length,
                        (index) {
                      return Polyline(
                        points: (_isNavigating && index == _selectedRouteIndex) 
                            ? _activeRouteLine 
                            : _routes[index],
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
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
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
                          value: _isNavigating && _distanceKm > 0
                              ? "${((_distanceToTarget / 1000) / (_distanceKm / _durationMin)).toStringAsFixed(1)} min"
                              : _isNavigating
                                  ? "--- min"
                                  : "${_durationMin.toStringAsFixed(1)} min",
                        ),
                        RouteStatisticTrackingLabel(
                          icon: Icons.map,
                          label: "Distância",
                          value: _isNavigating
                            ?"${(_distanceToTarget / 1000).toStringAsFixed(2)} km"
                            : "${_distanceKm.toStringAsFixed(2)} km",
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
                                  _distanceKm = _routeDistances[index];
                                  _durationMin = _routeDurations[index];
                                  _activeRouteLine = List.from(_routes[index]);
                                  if (_isNavigating && _currentPosition != null) {
                                    _updateRouteProgress(_currentPosition!);
                                  }
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
              children: [
                if (!_isNavigating)
                  Row(
                    children: [
                      ControllRoteButton(
                        onTap: _startNavigation,
                        icone: Icons.play_arrow_outlined,
                        iconSize: 60,
                        buttonSize: 80,
                        color: Colors.green,
                        finish: false,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ControllRoteButton(
                  onTap: _showStopDialog,
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