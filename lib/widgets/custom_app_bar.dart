import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Agregar parámetro para el título

  CustomAppBar({required this.title}); // Solo se requiere el título

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String name =
        prefs.getString('userName') ?? 'Guest'; // Definir nombre por defecto
    String avatarUrl = prefs.getString('userAvatar') ??
        ''; // Definir URL de avatar por defecto
    return {'name': name, 'avatarUrl': avatarUrl};
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title), // Usa el título pasado como parámetro
      actions: [
        FutureBuilder<Map<String, String>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Icon(Icons.error);
            } else if (snapshot.hasData) {
              final userData = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: PopupMenuButton<String>(
                  onSelected: (String value) {
                    // Aquí manejas las acciones cuando se selecciona una opción
                    if (value == 'logout') {
                      // Maneja el cierre de sesión
                      Navigator.of(context).pushReplacementNamed('/login');
                    } else if (value == 'profile') {
                      // Navegar al perfil del usuario
                      Navigator.of(context).pushNamed('/profile');
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Perfil'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text('Salir'),
                        ),
                      ),
                    ];
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            Provider.of<UserProvider>(context).user?.image !=
                                    null
                                ? MemoryImage(base64Decode(
                                    Provider.of<UserProvider>(context)
                                        .user!
                                        .image!))
                                : null,
                        child: Provider.of<UserProvider>(context).user?.image ==
                                null
                            ? Icon(Icons.person)
                            : null, // Ícono de respaldo si no hay imagen
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              );
            } else {
              return Icon(Icons.account_circle);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // Establece la altura del AppBar
}
