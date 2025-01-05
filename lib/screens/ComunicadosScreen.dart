import 'package:flutter/material.dart';

import '../models/comunicado.dart';
import '../services/odoo_service.dart';
import 'ComunicadoDetailsScreen.dart';

class ComunicadosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunicados'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      // drawer: MenuDrawer(),
      body: FutureBuilder<List<Comunicado>>(
        future: OdooService().obtenerComunicados(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los comunicados'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay comunicados disponibles.'));
          }

          List<Comunicado> comunicados = snapshot.data!;

          return ListView.builder(
            itemCount: comunicados.length,
            itemBuilder: (context, index) {
              final comunicado = comunicados[index];
              return Card(
                margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16), // Márgenes para separar cada item
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                elevation: 4, // Sombra para darle profundidad al card
                child: ListTile(
                  contentPadding:
                      EdgeInsets.all(12), // Espaciado interno del ListTile
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        8), // Bordes redondeados para la imagen
                    child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 60, // Establece el ancho máximo
                          maxHeight: 60, // Establece la altura máxima, opcional
                        ),
                        child: Image.network(
                          comunicado.imagen,
                          width: 50, // Ancho fijo para la imagen
                          height: 50, // Alto fijo para la imagen
                          fit: BoxFit
                              .cover, // Asegura que la imagen se ajuste sin deformarse
                        )),
                  ),
                  title: Text(
                    comunicado.titulo,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comunicado.fecha,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(
                          height: 4), // Espacio entre la fecha y la descripción
                      Text(
                        comunicado.descripcion,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          overflow: TextOverflow
                              .ellipsis, // Si es muy larga, se corta con "..."
                        ),
                        maxLines: 2, // Limitar la descripción a dos líneas
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navegar a la pantalla de detalles del comunicado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ComunicadoDetailsScreen(comunicado: comunicado),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
