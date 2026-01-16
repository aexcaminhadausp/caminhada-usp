import 'package:app/components/route_statistic_finished_label.dart';
import 'package:flutter/material.dart';

class StatisticRouteScreen extends StatefulWidget {
  const StatisticRouteScreen({super.key});

  @override
  State<StatisticRouteScreen> createState() => _StatisticRouteScreenState();
}
//tela de rota finalizada
class _StatisticRouteScreenState extends State<StatisticRouteScreen> {
  int avaliacao = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rota Finalizada"),),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          children: [
            //parte das estatisticas das rotas
            SizedBox(
                width: double.infinity,
                child: const Text(
                  'Estatísticas',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
            Divider(thickness: 2, color: const Color.fromARGB(255, 66, 66, 66),),
            //linhas e seus valores
            RouteStatisticFinishedLabel(label: "Distância Percorrida", value: "20km"),
            RouteStatisticFinishedLabel(label: "Tempo Total", value: "1 hora"),
            RouteStatisticFinishedLabel(label: "Calorias", value: "120kcal"),
            const SizedBox(height: 24),

            //parte da avaliacao
            SizedBox(
                width: double.infinity,
                child: const Text(
                  'Avalie a Rota',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
            Divider(thickness: 2, color: const Color.fromARGB(255, 66, 66, 66),),
            //estrelas
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        avaliacao = index + 1;
                      });
                    },
                    icon: Icon(
                      index < avaliacao
                          ? Icons.star
                          : Icons.star_border,
                      size: 32,
                      color: Colors.amberAccent,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              //espaco de comentario
              Container(
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: "Faça seu comentário...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              /// RELATAR PROBLEMA
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Relatar problema com essa rota",
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

