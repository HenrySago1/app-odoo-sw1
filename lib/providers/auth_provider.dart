import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Cargar datos de usuario desde SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? name = prefs.getString('name');
    String? serverVersion = prefs.getString('serverVersion');

    if (username != null && name != null && serverVersion != null) {
      _user = User(username: username, name: name);
    }
    notifyListeners();
  }

  // Guardar usuario en SharedPreferences
  Future<void> setUser(User user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user.username);
    prefs.setString('name', user.name);
    notifyListeners();
  }

  // Método para obtener el token FCM
  Future<String?> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  // Eliminar usuario (logout)
  Future<void> removeUser() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('name');
    notifyListeners();
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user'); // Eliminar los datos del usuario almacenados
    _user = null; // Limpiar el usuario
    notifyListeners();
  }

}
