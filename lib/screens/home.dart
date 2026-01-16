import 'package:app/components/popular_walking_spots.dart';
import 'package:app/components/latest_route.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
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
              UltimoTrajeto(
                nomeLocal: "Faculdade de Direito de Ribeirão Preto", 
                nomeEndereco: "Rua Prof. Doutor Aymar Batista Prado"
              ),
              SizedBox(height: 5,),
              UltimoTrajeto(
                nomeLocal: "Faculdade de Direito de Ribeirão Preto", 
                nomeEndereco: "Rua Prof. Doutor Aymar Batista Prado"
              ),

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
              PontoPopular(nomeLocal: "Biblioteca Central", cor: Colors.green),
              SizedBox(height: 10,),
              PontoPopular(nomeLocal: "Teatro do Campus", cor: Colors.purple),
            ],
          ),
        ),
      ),
      
    );
  }
}