import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String sessionIdKey = 'sessionId';

  // Guardar el sessionId
  static Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionIdKey, sessionId);
  }

  // Obtener el sessionId
  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionIdKey);
  }

  // Eliminar el sessionId (por ejemplo, al cerrar sesión)
  static Future<void> clearSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionIdKey);
  }

  // Método para cerrar sesión y eliminar el sessionId
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionIdKey);
  }

}
