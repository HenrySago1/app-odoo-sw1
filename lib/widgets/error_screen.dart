import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  // Constructor para pasar el mensaje de error
  ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }
}
