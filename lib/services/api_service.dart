import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';

class ApiService {
  // Use 'http://127.0.0.1:8000' para Windows/Web.
  // Use 'http://10.0.2.2:8000' se decidir usar emulador Android futuramente.
  static const String baseUrl = "http://127.0.0.1:8000";

  /// Realiza o login e armazena o Token JWT localmente.
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        // O FastAPI OAuth2PasswordRequestForm espera 'username' e 'password'.
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        // Persistência do token para manter o usuário logado
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        
        return true;
      }
      return false;
    } catch (e) {
      print("Erro na conexão com a API: $e");
      return false;
    }
  }

  /// Recupera os dados do usuário logado (Perfil).
  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) return null;

      final response = await http.get(
        Uri.parse("$baseUrl/users/me"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Erro ao buscar perfil: $e");
      return null;
    }
  }

  /// Busca os Pontos de Interesse (POIs) cadastrados no Campus via PostGIS.
  static Future<List<dynamic>> getMapPOIs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) return [];

      final response = await http.get(
        Uri.parse("$baseUrl/map/pois"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("Erro ao buscar POIs: $e");
      return [];
    }
  }

  /// Remove o token e desconecta o usuário.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}