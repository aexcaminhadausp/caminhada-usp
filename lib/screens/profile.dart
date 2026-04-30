import 'package:app/services/api_service.dart';
import 'package:app/screens/login.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _profileFuture;

  // Preferências Hardcoded (Estado Local)
  bool _prefAcessivel = false;
  bool _prefSombra = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = ApiService.getProfile();
  }

  void _handleLogout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text("Erro ao carregar dados do perfil."),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABEÇALHO DO PERFIL
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user['name'] ?? "Usuário",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user['email'] ?? "",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                const Text(
                  "Preferências de Caminhada",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                // PREFERÊNCIAS 
                SwitchListTile(
                  title: const Text("Acessibilidade"),
                  subtitle: const Text("Evitar escadas e terrenos irregulares"),
                  secondary: const Icon(Icons.wheelchair_pickup, color: Colors.blue),
                  value: _prefAcessivel,
                  onChanged: (bool value) {
                    setState(() => _prefAcessivel = value);
                  },
                ),
                SwitchListTile(
                  title: const Text("Priorizar Sombra"),
                  subtitle: const Text("Rotas com maior cobertura de árvores"),
                  secondary: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                  value: _prefSombra,
                  onChanged: (bool value) {
                    setState(() => _prefSombra = value);
                  },
                ),

                const SizedBox(height: 40),
                
                // BOTÃO DE SAÍDA
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text("Sair da Conta", style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}