import 'package:app/components/controll_rote_button.dart';
import 'package:app/components/item_info.dart';
import 'package:flutter/material.dart';

class Rota extends StatefulWidget {
  const Rota({super.key});

  @override
  State<Rota> createState() => _RotaState();
}

class _RotaState extends State<Rota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 136, 235, 140),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.25,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [

                    /// indicador de arrastar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    //estatisticas de tempo e distancia ja percorridas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        InfoItem(
                          icon: Icons.directions_walk,
                          label: "Tempo",
                          value: "00:30:24",
                        ),
                        InfoItem(
                          icon: Icons.map,
                          label: "Distância",
                          value: "12.5km / 20km",
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    //estatisticas de tempo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        InfoItem(
                          icon: Icons.wb_sunny_outlined,
                          label: "Clima",
                          value: "30°",
                        ),
                        InfoItem(
                          icon: Icons.trending_up,
                          label: "Inclinação",
                          value: "60%",
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    
                  ],
                ),
              );
            },
          ),

          //botoes de play e pause
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BotaoRota(
                  icone: Icons.play_arrow_outlined,
                  tamanhoIcone: 60,
                  tamanhoBotao: 80,
                  cor: Colors.green,
                  finalizar: false,
                ),
                const SizedBox(width: 10),
                BotaoRota(
                  icone: Icons.stop_outlined,
                  tamanhoIcone: 30,
                  tamanhoBotao: 50,
                  cor: Colors.blueGrey,
                  finalizar: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}