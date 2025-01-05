import 'dart:convert';

import 'package:fcm/services/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/comunicado.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'firebase_service.dart';

class OdooService {
  final String baseUrl = 'http://142.93.7.209:8069/'; // URL de tu API
  final String database = 'odoo_agenda';

  Future<User?> login(
      String username, String password, BuildContext context) async {
    await SessionManager.saveSessionId(
        "jjjhfjftrjggkfkhfj"); // Almacenar el sessionId en SharedPreferences
    User user = new User(name: "henry saavedra", username: username);
    Provider.of<UserProvider>(context, listen: false).setUser(
        user); // Guarda el usuario en el UserProvider usando el contexto
    return user;
  }

  //notificacion push
/*  Future<User?> login(
      String username, String password, BuildContext context) async {
    final response = await _authenticate(username, password);
    if (response.statusCode != 200) throw Exception('Failed to authenticate');
    final data = jsonDecode(response.body);
    _handleApiError(data);
    if (data.containsKey('result')) {
      final sessionCookie = response.headers['set-cookie'];
      if (sessionCookie != null) {
        await SessionManager.saveSessionId(
            sessionCookie); // Almacenar el sessionId en SharedPreferences
        // Obtener el avatar (suponiendo que tienes una función que obtiene la URL o el avatar en base64)
        final uid = data['result']['uid'];
        final avatarData = await getUserAvatar(
            uid, sessionCookie); // Llamar la función para obtener el usuario
        final data2 = jsonDecode(avatarData.body);
        User user = User.fromJson(data2['result'][0]);
        Provider.of<UserProvider>(context, listen: false).setUser(
            user); // Guarda el usuario en el UserProvider usando el contexto
        //await updateFCM(user, sessionCookie);
        return user;
      }
    }
  }*/

  Future<List<Comunicado>> obtenerComunicados() async {
    try {
      String? sessionId = await SessionManager.getSessionId();
      final response = await http.get(
        Uri.parse('$baseUrl/api/comunicados'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': '$sessionId',
        },
      );
      print(response.body);
      print("=====================================================");
      List<dynamic> data = json.decode(response.body);
      return data
          .map((comunicadoJson) => Comunicado.fromJson(comunicadoJson))
          .toList();
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener un comunicado por ID desde la API
  Future<Comunicado> obtenerComunicadoPorId(int id) async {
    List<Comunicado> comunicados = await obtenerComunicados();
    return comunicados.firstWhere((comunicado) => comunicado.id == id);
  }

  Future<http.Response> getUserAvatar(int userId, String session_id) async {
    // Realiza la solicitud HTTP POST
    return await http.post(
      Uri.parse('$baseUrl/web/dataset/call_kw'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': session_id,
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "model": "res.users", // El modelo en Odoo
          "method": "read", // Método para leer registros
          "args": [
            [userId]
          ], // El ID del usuario
          "kwargs": {
            "fields": [
              "id",
              "name",
              "email",
              "image_1920"
            ], // Campos solicitados: nombre y avatar
          },
        }
      }),
    );
  }

  //AUXILIARES
  // Método para realizar la solicitud de autenticación
  Future<http.Response> _authenticate(String username, String password) {
    return http.post(
      Uri.parse('$baseUrl/web/session/authenticate'),
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {"db": database, "login": username, "password": password}
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );
  }

  // Método para manejar errores de la API
  void _handleApiError(Map<String, dynamic> data) {
    if (data.containsKey('error')) {
      final error = data['error'];
      if (error.containsKey('code') && error['code'] == 200) {
        throw Exception(error['data']['message']);
      } else {
        throw Exception('Error during login: ${error['message']}');
      }
    }
  }

  Future<void> updateFCM(User user, String? sessionId) async {
    String? token = await FirebaseService.getDeviceToken();
    print('su token de dispositivo es $token');
    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/update-fcm'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': '$sessionId', // Usa la sesión para autenticar
        },
        body: jsonEncode({
          'params': {
            'userId':
                user.id, // Puedes ajustar el nombre y valor si es necesario
            'fcmToken': token
          }
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
        print("FCM token actualizado correctamente");
      } else {
        print("Error al actualizar el FCM token: ${response.statusCode}");
      }
    }
  }
}
