import 'package:app/components/popular_walking_spots.dart';
import 'package:app/components/latest_route.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  late Future<List<dynamic>> _poisFuture;

  // Lista de cores para alternar visualmente entre os cards dos pontos
  final List<Color> _poiColors = [
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    // Inicia a busca dos POIs no servidor assim que a tela abre
    _poisFuture = ApiService.getMapPOIs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // --- BARRA DE BUSCA ---
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
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
              ),

              // --- SEÇÃO DE ÚLTIMOS TRAJETOS (Estático) ---
              const SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                child: const Text(
                  'Últimos Trajetos',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),

              Divider(thickness: 2, color: const Color.fromARGB(255, 66, 66, 66),),
              LatestRoute(
                localName: "Faculdade de Direito de Ribeirão Preto", 
                addressName: "Rua Prof. Doutor Aymar Batista Prado"
              ),
              SizedBox(height: 5,),
              LatestRoute(
                localName: "Faculdade de Direito de Ribeirão Preto", 
                addressName: "Rua Prof. Doutor Aymar Batista Prado"
              ),

              // --- SEÇÃO DE PONTOS POPULARES (Dinâmico da API) ---
              const SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                child: const Text(
                  'Pontos populares',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),

              Divider(thickness: 2, color: const Color.fromARGB(255, 66, 66, 66),),
              FutureBuilder<List<dynamic>>(
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
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}