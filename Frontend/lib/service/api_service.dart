import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ Flutter Web ke liye localhost use karo
  static const String baseUrl = "http:// 192.168.100.125:3000/api";

  // ================= SIGNUP =================
  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,      // ✅ name properly passed
          "email": email,    // ✅ email added (missing before)
          "password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Server Error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  // ================= GET TOURNAMENTS =================
  static Future<List> getTournaments() async {
    final response = await http.get(
      Uri.parse("$baseUrl/tournaments"),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'] ?? [];
    } else {
      throw Exception("Failed to load tournaments");
    }
  }

  // ================= JOIN TOURNAMENT =================
  static Future<bool> joinTournament(
      String userId, String tournamentId) async {

    final response = await http.post(
      Uri.parse("$baseUrl/tournaments/join"), // ✅ use baseUrl for consistency
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userId": userId,
        "tournamentId": tournamentId,
      }),
    );

    return response.statusCode == 200;
  }
}