import 'package:app/components/local_field.dart';
import 'package:app/components/route_warnings.dart';
import 'package:app/screens/route_tracking.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';

class CreateRoteScreen extends StatefulWidget {
  const CreateRoteScreen({super.key});

  @override
  State<CreateRoteScreen> createState() => _CreateRoteScreenState();
}

class _CreateRoteScreenState extends State<CreateRoteScreen> {
  int? _selectedType;
  final TextEditingController origemController = TextEditingController();
  final TextEditingController destinoController = TextEditingController();

  List<dynamic> _availablePois = [];
  int? _selectedDestinationId;

  final List<WalkingPreferenceType> walkingPreferencesTypes = [
    WalkingPreferenceType(title: "Rápida", icon: Icons.run_circle_outlined),
    WalkingPreferenceType(
      title: "Acessível",
      icon: Icons.wheelchair_pickup_outlined,
    ),
    WalkingPreferenceType(title: "Sombra", icon: Icons.nature_people)
  ];

  @override
  void initState() {
    super.initState();
    _loadPois(); // Carrega os destinos assim que a tela abre
  }

  Future<void> _loadPois() async {
    final pois = await ApiService.getMapPOIs();
    
    if (!mounted) return; // Previne erro caso a tela seja fechada antes da API responder
    
    setState(() {
      _availablePois = pois;
    });
  }

  void _onDestinationSelected(String selection) {
    // Busca o objeto POI completo pelo nome selecionado
    final poi = _availablePois.firstWhere(
      (p) => p['name'] == selection,
      orElse: () => null,
    );

    if (poi != null) {
      setState(() {
        destinoController.text = poi['name'];
        _selectedDestinationId = poi['id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Rota")),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: _configurationRouteLabel(),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                ),
              );
            },
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 100,
            child: ElevatedButton(
              onPressed: () async {
                final startQuery = origemController.text;
                final endQuery = destinoController.text;

                if (startQuery.isEmpty || endQuery.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Digite origem e destino"),
                    ),
                  );
                  return;
                }

                // --- VERIFICAÇÃO DE PERMISSÃO DE GPS ---
                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                if (!serviceEnabled) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor, ative o GPS do celular para navegar."),
                    ),
                  );
                  return;
                }
                LocationPermission permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                }

                if (!mounted) return;

                if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("A permissão de localização é necessária para navegação.")),
                  );
                  return;
                }

                LatLng? start;
                LatLng? end;

                // 1. Define a Origem: Tenta encontrar nos POIs ou usa GPS se estiver vazio
                if (startQuery == "Localização Atual" || startQuery.isEmpty) {
                  Position position = await Geolocator.getCurrentPosition();
                  start = LatLng(position.latitude, position.longitude);
                } else {
                  final poiOrigem = _availablePois.firstWhere(
                    (p) => p['name'] == startQuery,
                    orElse: () => null,
                  );
                  if (poiOrigem != null) {
                    start = LatLng(poiOrigem['latitude'], poiOrigem['longitude']);
                  }
                }

                // 2. Define o Destino: OBRIGATÓRIO ser um POI da lista para ter ID
                final poiDestino = _availablePois.firstWhere(
                  (p) => p['name'] == endQuery,
                  orElse: () => null,
                );

                if (poiDestino != null) {
                  end = LatLng(poiDestino['latitude'], poiDestino['longitude']);
                  _selectedDestinationId = poiDestino['id'];
                }

                if (!mounted) return;

                // 3. Validação Final: Se não houver destino válido ou ID, bloqueia
                if (start == null || end == null || _selectedDestinationId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Selecione uma origem e destino válidos."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RouteTracking(
                      start: start!,
                      end: end!,
                      preferenceType: _selectedType,
                      destinationId: _selectedDestinationId!, // Envia o ID real do banco
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Iniciar rota",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _configurationRouteLabel() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LocalField(
            title: "Origem",
            hint: "Localização Atual",
            controller: origemController,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _availablePois.map((poi) {
              return ActionChip(
                label: Text(poi['name'] ?? "Ponto"),
                onPressed: () {
                  setState(() {
                    origemController.text = poi['name'];
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          LocalField(
            title: "Destino",
            hint: "Biblioteca Central",
            controller: destinoController,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: _availablePois.isEmpty
                ? [const Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)))]
                : _availablePois.map((poi) {
                    return ActionChip(
                      label: Text(poi['name'] ?? "Ponto"),
                      // Reutiliza a sua função para organizar a seleção
                      onPressed: () => _onDestinationSelected(poi['name'] ?? ""),
                    );
                  }).toList(),
          ),
          SizedBox(
            height: 150,
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: List.generate(walkingPreferencesTypes.length, (index) {
                final iten = walkingPreferencesTypes[index];
                final bool selected = (_selectedType == index);

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _selectedType = index;
                    });
                  },
                  child: Card(
                    elevation: selected ? 6 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    color: selected
                        ? Theme.of(context).colorScheme.primary.withValues(
                      alpha: 0.1,
                    )
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iten.icon,
                          size: 30,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[700],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          iten.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          RouteWarning(message: "Beba bastante água!"),
          const SizedBox(height: 10),
          RouteWarning(message: "Passe protetor solar!"),
        ],
      ),
    );
  }
}

class WalkingPreferenceType {
  final String title;
  final IconData icon;

  WalkingPreferenceType({
    required this.title,
    required this.icon,
  });
}