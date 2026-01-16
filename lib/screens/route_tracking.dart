import 'package:app/components/controll_route_button.dart';
import 'package:app/components/route_statistic_tracking_label.dart';
import 'package:flutter/material.dart';

class RouteTracking extends StatefulWidget {
  const RouteTracking({super.key});

  @override
  State<RouteTracking> createState() => _RouteTrackingState();
}

class _RouteTrackingState extends State<RouteTracking> {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            RoteStatisticLabel(
                              icon: Icons.directions_walk,
                              label: "Tempo",
                              value: "00:30:24",
                            ),
                            SizedBox(height: 12),
                            RoteStatisticLabel(
                              icon: Icons.wb_sunny_outlined,
                              label: "Clima",
                              value: "30°",
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            RoteStatisticLabel(
                              icon: Icons.map,
                              label: "Distância",
                              value: "12.5km / 20km",
                            ),
                            SizedBox(height: 12),
                            RoteStatisticLabel(
                              icon: Icons.trending_up,
                              label: "Inclinação",
                              value: "60%",
                            ),
                          ],
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
                ControllRoteButton(
                  icone: Icons.play_arrow_outlined,
                  iconSize: 60,
                  buttonSize: 80,
                  color: Colors.green,
                  finish: false,
                ),
                const SizedBox(width: 10),
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