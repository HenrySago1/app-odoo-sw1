import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/menu_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    // Función para navegar a las páginas
    void navigateToPage(String routeName) {
      Navigator.pushNamed(context, routeName);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home', // Título personalizado para esta pantalla
      ),
      drawer: MenuDrawer(), // Aquí reutilizas el widget MenuDrawer
      body: Center(
        child: user == null
            ? Text('No user logged in')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bienvenido, ${user.name}!'),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2, // Dos cuadros por fila
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding: EdgeInsets.all(20),
                      children: [
                        // Cuadro: Calendario
                        GestureDetector(
                          onTap: () => navigateToPage('/calendar'),
                          child: _buildMenuCard(
                            icon: Icons.calendar_today,
                            label: 'Calendario',
                          ),
                        ),
                        // Cuadro: Comunicado
                        GestureDetector(
                          onTap: () => navigateToPage('/comunicados'),
                          child: _buildMenuCard(
                            icon: Icons.announcement,
                            label: 'Comunicados',
                          ),
                        ),
                        // Cuadro: Habla en tu idioma
                        GestureDetector(
                          onTap: () => navigateToPage('/idioma'),
                          child: _buildMenuCard(
                            icon: Icons.language,
                            label: 'Habla en tu idioma',
                          ),
                        ),
                        // Cuadro: Recomendaciones
                        GestureDetector(
                          onTap: () => navigateToPage('/recomendaciones'),
                          child: _buildMenuCard(
                            icon: Icons.assessment,
                            label: 'Recomendaciones',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Método para construir los cuadros con íconos y texto
  Widget _buildMenuCard({required IconData icon, required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: Color.fromARGB(255, 171, 81, 163),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
