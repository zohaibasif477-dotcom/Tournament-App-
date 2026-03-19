import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000/api/users/signup";

  // ------------------------------
  // SIGNUP
  // ------------------------------
  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": name,
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 20));

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? 'Signup failed'};
      }
    } catch (e) {
      print("API Error (signup): $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ------------------------------
  // LOGIN
  // ------------------------------
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 20));

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print("API Error (login): $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ------------------------------
  // Get all tournaments
  // ------------------------------
  static Future<List<dynamic>> getTournaments() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/tournaments/all'))
          .timeout(const Duration(seconds: 20)); // ✅ timeout added

      if (response.statusCode == 200) {
        return json.decode(response.body); // List<dynamic> واپس کرے
      } else {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        throw Exception('Server Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("API Error (getTournaments): $e");
      throw Exception("Failed to fetch tournaments: $e");
    }
  }

  // ------------------------------
  // Create a tournament
  // ------------------------------
  static Future<bool> addTournament(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/tournaments/create'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 20)); // ✅ timeout added

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("API Error (addTournament): $e");
      return false;
    }
  }

  // ------------------------------
  // Join a tournament
  // ------------------------------
  static Future<bool> joinTournament(String userID, String tournamentID) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/tournaments/join'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "userID": userID,
              "tournamentID": tournamentID,
            }),
          )
          .timeout(const Duration(seconds: 20)); // ✅ timeout added

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("API Error (joinTournament): $e");
      return false;
    }
  }
}