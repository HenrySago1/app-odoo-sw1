import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return Center(
          child:
              CircularProgressIndicator()); // Si no hay usuario, mostrar un loader
    }

    Uint8List? imageBytes =
        user.image != null ? base64Decode(user.image!) : null;

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 171, 81, 163),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi agenda escolar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          user.image != null ? MemoryImage(imageBytes!) : null,
                      child: user.image == null ? Icon(Icons.person) : null,
                    ),
                    SizedBox(width: 10),
                    Text(
                      user.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Opciones del menú
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendario'),
            onTap: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Comunicados'),
            onTap: () {
              Navigator.pushNamed(context, '/comunicados');
            },
          ),

          ListTile(
            leading: Icon(Icons.language),
            title: Text('Habla tu idioma'),
            onTap: () {
              Navigator.pushNamed(context, '/idioma');
            },
          ),

          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Recomendaciones'),
            onTap: () {
              Navigator.pushNamed(context, '/recomendaciones');
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Salir'),
            onTap: () async {
              await userProvider.removeUser();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Versión 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
