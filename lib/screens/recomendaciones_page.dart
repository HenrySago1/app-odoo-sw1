import 'package:flutter/material.dart';

class RecomendacionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendaciones'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Center(
        child: Text(
          'Esta es la página de rendimiento.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
