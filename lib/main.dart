import 'package:fcm/providers/auth_provider.dart';
import 'package:fcm/screens/CalendarScreen.dart';
import 'package:fcm/screens/ComunicadoDetailsScreen.dart';
import 'package:fcm/screens/ComunicadosScreen.dart';
import 'package:fcm/screens/habla_tu_idioma_page.dart';
import 'package:fcm/screens/home_screen.dart';
import 'package:fcm/screens/login_screen.dart';
import 'package:fcm/screens/recomendaciones_page.dart';
import 'package:fcm/widgets/error_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'config/firebase_config.dart';
import 'config/local_notifications.dart';
import 'models/comunicado.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotifications
      .initialize(); // Inicializa las notificaciones locales
  FirebaseConfig
      .setupFirebaseMessaging(); // Configura los manejadores de Firebase Messaging

  initializeDateFormatting('pt_BR', null).then((_) => runApp(MyApp()));
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Crea una clave global para el Navigator
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..loadUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        navigatorKey: navigatorKey, // Asocia el GlobalKey al MaterialApp
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.user != null) {
                    // Si el usuario está autenticado, redirige a Home
                    Future.delayed(
                        Duration.zero,
                        () => navigatorKey.currentState
                            ?.pushReplacementNamed('/home'));
                    return Container(); // Evitar mostrar una pantalla temporal
                  } else {
                    // Si no está autenticado, redirige a Login
                    Future.delayed(
                        Duration.zero,
                        () => navigatorKey.currentState
                            ?.pushReplacementNamed('/login'));
                    return Container(); // Evitar mostrar una pantalla temporal
                  }
                },
              ),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/comunicados': (context) => ComunicadosScreen(),
          '/comunicado_details': (context) => ComunicadoDetailsScreen(
              comunicado:
                  ModalRoute.of(context)!.settings.arguments as Comunicado),
          '/calendar': (context) => CalendarScreen(),
          '/pantalla_especifica': (context) => CalendarScreen(),
          '/recomendaciones': (context) => RecomendacionesPage(),
          '/idioma': (context) => HablaTuIdiomaPage()
        },
        onGenerateRoute: (settings) {
          final comunicado = settings.arguments as Comunicado?;

          if (comunicado != null) {
            return MaterialPageRoute(
              builder: (context) =>
                  ComunicadoDetailsScreen(comunicado: comunicado),
            );
          } else {
            // Maneja el caso en que 'comunicado' es null
            return MaterialPageRoute(
              builder: (context) => ErrorScreen(
                  message: 'No se encontró información de Comunicado'),
            );
          }
          // Puedes agregar más casos si es necesario

          // Si no se encuentra ninguna coincidencia, devuelve un error o la pantalla de inicio
          return MaterialPageRoute(
            builder: (context) => HomeScreen(),
          );
        },
      ),
    );
  }
}
