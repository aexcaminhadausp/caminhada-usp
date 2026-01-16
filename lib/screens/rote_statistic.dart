import 'package:flutter/material.dart';

class RotaFinalizada extends StatefulWidget {
  const RotaFinalizada({super.key});

  @override
  State<RotaFinalizada> createState() => _RotaFinalizadaState();
}
//tela de rota finalizada
class _RotaFinalizadaState extends State<RotaFinalizada> {
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
            _InfoLinha(label: "Distância Percorrida", valor: "20km"),
            _InfoLinha(label: "Tempo Total", valor: "1 hora"),
            _InfoLinha(label: "Calorias", valor: "120kcal"),
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
//classe que cria as linhas das estatisticas
class _InfoLinha extends StatelessWidget {
  final String label;
  final String valor;

  const _InfoLinha({
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
