import 'package:app/components/local_field.dart';
import 'package:app/components/route_warnings.dart';
import 'package:app/screens/route_tracking.dart';
import 'package:flutter/material.dart';

class CreateRoteScreen extends StatefulWidget {
  const CreateRoteScreen({super.key});

  @override
  State<CreateRoteScreen> createState() => _CreateRoteScreenState();
}

class _CreateRoteScreenState extends State<CreateRoteScreen> {
  int? _selectedType;
  final List<WalkingPreferenceType> walkingPreferencesTypes =[
    WalkingPreferenceType(title: "Rápida", icon: Icons.run_circle_outlined),
    WalkingPreferenceType(title: "Acessível", icon: Icons.wheelchair_pickup_outlined),
    WalkingPreferenceType(title: "Sombra", icon: Icons.nature_people)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text("Criar Rota")),
    body: Stack(
      children: [
       _configurationRouteLabel(),
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
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RouteTracking()),);
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
          )
        ),

        
      ],
    ),
  );
  }
  Widget _configurationRouteLabel(){
    return  Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LocalField(title: "Origem", hint: "Localização Atual"),
          const SizedBox(height: 10),
          LocalField(title: "Destino", hint: "Biblioteca Central"),
          const SizedBox(height: 20),

          SizedBox( //botoes de escolha de rota
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
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
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

class WalkingPreferenceType{
  final String title;
  final IconData icon;
  
  WalkingPreferenceType({
    required this.title,
    required this.icon
  });
}