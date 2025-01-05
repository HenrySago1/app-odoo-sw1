import 'package:flutter/material.dart';

import '../models/comunicado.dart';

class ComunicadoDetailsScreen extends StatelessWidget {
  final Comunicado comunicado;

  ComunicadoDetailsScreen({required this.comunicado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(comunicado.titulo),
        backgroundColor: Color(0xFFD9D0EA),
      ),
      body: Container(
        color: Color(0xFFF5F1F6), // Fondo lila suave
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
                child: Image.network(
                  comunicado.imagen,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Descripción
              Text(
                comunicado.descripcion,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16),

              // Detalles del comunicado
              _buildDetailRow('Fecha:', comunicado.fecha),
              _buildDetailRow('Hora:', comunicado.hora),
              _buildDetailRow('Tipo de reunión:', comunicado.tipo),

              SizedBox(height: 16),

              // Autor
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Autor: ${comunicado.autorNombre} (${comunicado.autorEmail})',
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Botón para más acciones (Ejemplo: abrir enlace)
              ElevatedButton(
                onPressed: () => _launchURL('https://www.ejemplo.com'),
                child: Text('Marcar leido'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir filas de detalles
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Función para lanzar un enlace (ejemplo: abrir una URL)
  void _launchURL(String url) async {
    // Aquí se puede agregar lógica para abrir enlaces en el navegador o aplicación
    print('Abrir URL: $url');
  }
}
