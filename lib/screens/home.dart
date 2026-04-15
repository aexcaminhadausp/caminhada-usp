import 'package:app/components/popular_walking_spots.dart';
import 'package:app/components/latest_route.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/screens/route_tracking.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  late Future<List<dynamic>> _poisFuture;
  late Future<List<dynamic>> _historyFuture;

  // Lista de cores para alternar visualmente entre os cards dos pontos
  final List<Color> _poiColors = [
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.red,
  ];

  Future<void> _goToRoute(Map<String, dynamic> poi) async {
    //Pedir permissão e pegar localização atual
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (!mounted) return;

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, ative o GPS do celular.")),
        );
        return;
      }

      Position position;
      try {
        position = await Geolocator.getCurrentPosition();
      } catch (e) {
        print("Erro ao obter localização: $e");
        return;
      }
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RouteTracking(
            start: LatLng(position.latitude, position.longitude),
            end: LatLng(poi['latitude'], poi['longitude']),
            destinationId: poi['id'],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A permissão de localização é necessária.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicia a busca dos POIs no servidor assim que a tela abre
    _poisFuture = ApiService.getMapPOIs();
    _historyFuture = ApiService.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                
                const SizedBox(height: 15),
                const Text('Últimos Trajetos', style: TextStyle(fontSize: 18)),
                const Divider(thickness: 2, color: Color.fromARGB(255, 66, 66, 66)),
                _buildHistorySection(),

                const SizedBox(height: 15),
                const Text('Pontos populares', style: TextStyle(fontSize: 18)),
                const Divider(thickness: 2, color: Color.fromARGB(255, 66, 66, 66)),
                _buildPopularSpotsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS DE CONSTRUÇÃO DE INTERFACE ---

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Digite um ponto de interesse',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // ação do filtro
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return FutureBuilder<List<dynamic>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: LinearProgressIndicator()),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("Suas caminhadas recentes aparecerão aqui.", style: TextStyle(color: Colors.grey)),
          );
        }

        final recentItems = snapshot.data!.take(3).toList();

        return Column(
          children: recentItems.map((item) {
            final distance = _formatDistance(item['distance']);
            final formattedDate = _formatDate(item['created_at']);
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () => _goToRoute(item),
                child: LatestRoute(
                  localName: item['destination_name'] ?? "Destino",
                  addressName: "Data: $formattedDate • Distância: ${distance}m", 
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPopularSpotsSection() {
    return FutureBuilder<List<dynamic>>(
      future: _poisFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Erro ao carregar pontos de interesse."),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Nenhum ponto encontrado no banco de dados."),
          );
        }

        final pois = snapshot.data!;
        
        return ListView.separated(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pois.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final poi = pois[index];
            return PopularWWalkingSpots(
              localName: poi['name'] ?? 'Ponto sem nome',
              color: _poiColors[index % _poiColors.length],
              onTap: () => _goToRoute(poi),
            );
          },
        );
      },
    );
  }

  // --- MÉTODOS UTILITÁRIOS ---

  String _formatDistance(dynamic distance) {
    return (distance as num?)?.toStringAsFixed(0) ?? '0';
  }

  String _formatDate(String isoDate) {
    try {
      final rawDate = isoDate.split('T')[0].split('-');
      return "${rawDate[2]}/${rawDate[1]}/${rawDate[0]}";
    } catch (e) {
      return isoDate;
    }
  }
}