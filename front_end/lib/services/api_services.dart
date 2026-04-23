import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static String? token;

  // ================= HEADERS =================
  static Map<String, String> get headers {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // ================= LOGIN =================
  static Future<bool> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: headers,
      body: jsonEncode({
        "email": email,
        "senha": senha,
      }),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      token = data["access_token"];

      return true;
    }

    return false;
  }

  // ================= REGISTER =================
  static Future<bool> register(Map<String, dynamic> user) async {
  final response = await http.post(
    Uri.parse("$baseUrl/auth/register"), // CUIDADO AQUI
    headers: headers,
    body: jsonEncode(user),
  );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER BODY: ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ================= PROFILE =================
  static Future<Map<String, dynamic>?> getProfile() async {
    final response = await http.get(
      Uri.parse("$baseUrl/auth/me"),
      headers: headers,
    );

    print("PROFILE STATUS: ${response.statusCode}");
    print("PROFILE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  // ================= UPDATE PROFILE =================
  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/auth/editar-me"),
      headers: headers,
      body: jsonEncode(data),
    );

    print("UPDATE PROFILE STATUS: ${response.statusCode}");
    print("UPDATE PROFILE BODY: ${response.body}");

    return response.statusCode == 200;
  }

  // ================= GET GENERICO =================
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
    );

    print("GET STATUS: ${response.statusCode}");
    print("GET BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  // ================= PUT GENERICO =================
  static Future<bool> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    print("PUT STATUS: ${response.statusCode}");
    print("PUT BODY: ${response.body}");

    return response.statusCode == 200;
  }

  // ================= DELETE =================
  static Future<bool> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
    );

    print("DELETE STATUS: ${response.statusCode}");
    print("DELETE BODY: ${response.body}");

    return response.statusCode == 200;
  }
} 