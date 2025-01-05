import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notifications.dart';
import '../main.dart'; // Asegúrate de importar MyApp para acceder a navigatorKey.

class FirebaseConfig {
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Este código se ejecuta en segundo plano
    print('Handling a background message: ${message.messageId}');
  }

  static void setupFirebaseMessaging() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Manejando notificaciones cuando la app está en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Muestra la notificación localmente cuando la app está en primer plano
      LocalNotifications.showNotification(message);

      // Maneja la lógica para redirigir a una pantalla si la app está en primer plano
      _handleNotificationClick(message);
    });

    // Manejando cuando el usuario abre la app desde una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Lógica al abrir la app desde una notificación
      print("Notificación abierta: ${message.notification?.title}");
      if (message.data['targetScreen'] == '/pantalla_especifica') {
        MyApp.navigatorKey.currentState?.pushNamed('/pantalla_especifica', arguments: message.data);
      }
    });

    // Manejar la notificación cuando la app está cerrada
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(message);
      }
    });
  }

  // Función para manejar el click en la notificación y redirigir a una pantalla específica
  static void _handleNotificationClick(RemoteMessage message) {
    final targetScreen = message.data['targetScreen'];

    if (targetScreen != null) {
      // Usamos el navigatorKey para hacer la navegación a la pantalla específica
      MyApp.navigatorKey.currentState?.pushNamed(targetScreen);
    }
  }
}
