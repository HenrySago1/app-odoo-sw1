import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/user.dart';
import '../services/odoo_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Este código se ejecutará en segundo plano
  print('Handling a background message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _obscureText = true; // Controla si la contraseña está oculta

  void _login() async {
    try {
      print("click login......");
      User? user = await OdooService()
          .login(_usernameController.text, _passwordController.text, context);
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x4DD3C9E5),
                ),
                padding: EdgeInsets.all(20),

                child: Image.asset(
                  'assets/logo.png', // Ruta de tu imagen en la carpeta assets
                  width: 80, // Ancho de la imagen
                  height: 80, // Alto de la imagen
                  // color: Color.fromARGB(255, 74, 163,236), // Opcional: Aplicar un color a la imagen
                ),

                // child: Icon(
                //   Icons.account_balance_sharp,
                //   color: Color.fromARGB(255, 74, 163, 236),
                //   size: 80,
                // ),
              ),
              SizedBox(height: 20),
              Text(
                'MI AGENDA ESCOLAR',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 171, 81, 163),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Por favor, inicie sesión para continuar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person,
                      color: Color.fromARGB(255, 171, 81, 163)),
                  filled: true,
                  fillColor: Color(0x3DD3C9E5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock,
                      color: Color.fromARGB(255, 171, 81, 163)),
                  filled: true,
                  fillColor: Color(0x44D3C9E5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Color.fromARGB(255, 171, 81, 163),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 171, 81, 163),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Acción para recuperar contraseña
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Color.fromARGB(255, 171, 81, 163)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
