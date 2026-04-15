import 'package:app/components/route_statistic_finished_label.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home_scaffold.dart';

class StatisticRouteScreen extends StatefulWidget {
  final String historyId;
  final double distanceKm;
  final int timeInSeconds;

  const StatisticRouteScreen({
    super.key,
    required this.historyId,
    required this.distanceKm,
    required this.timeInSeconds,
  });

  @override
  State<StatisticRouteScreen> createState() => _StatisticRouteScreenState();
}
//tela de rota finalizada
class _StatisticRouteScreenState extends State<StatisticRouteScreen> {
  int rate = 0;
  bool isSaving = false;

  Future<void> _endStatisticScreen() async {
    setState(() => isSaving = true);

    // Se o usuário selecionou estrelas, atualizamos no banco
    if (rate > 0) {
      await ApiService.updateRouteRate(widget.historyId, rate);
    }

    if (!mounted) return;

    // Navega de volta para a Home limpando todo o histórico de telas anteriores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScaffold()),
      (route) => false,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Bloqueia o voltar padrão para forçar o redirecionamento
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _endStatisticScreen();
      },
      child: Scaffold(
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
              RouteStatisticFinishedLabel(label: "Distância Percorrida", value: "${widget.distanceKm.toStringAsFixed(2)} km"),
              RouteStatisticFinishedLabel(label: "Tempo Total", value: "${widget.timeInSeconds ~/ 60} min"),
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
                          rate = index + 1;
                        });
                      },
                      icon: Icon(
                        index < rate
                            ? Icons.star
                            : Icons.star_border,
                        size: 32,
                        color: Colors.amberAccent,
                      ),
                    );
                  }),
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
                const Spacer(),
                // Botão de Finalizar (Necessário para concluir o fluxo e enviar a API)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _endStatisticScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    child: isSaving 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text("Finalizar", style: TextStyle(fontSize: 18)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
