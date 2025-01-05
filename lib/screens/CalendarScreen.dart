import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

import '../models/comunicado.dart';
import '../services/session_manager.dart';

class ComunicadoService {
  final String apiUrl =
      'http://142.93.7.209:8069/api/comunicados'; // URL de tu API

  // Método para obtener la lista de comunicados desde la API
  Future<List<Comunicado>> obtenerComunicados() async {
    try {
      String? sessionId = await SessionManager.getSessionId();
      final response = await http.get(
        Uri.parse('http://142.93.7.209:8069/api/comunicados'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': '$sessionId', // Usa la sesión para autenticar
        },
      );
      print(response.body);
      // Si la respuesta es exitosa, parsea los datos JSON
      List<dynamic> data = json.decode(response.body);
      return data
          .map((comunicadoJson) => Comunicado.fromJson(comunicadoJson))
          .toList();
    } catch (e) {
      // Si ocurre un error, lo muestra en consola o maneja el error
      throw Exception('Error de conexión: $e');
    }
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<Comunicado>> _comunicadosPorFecha;
  late List<Comunicado> _comunicadosSeleccionados;
  final ComunicadoService _comunicadoService = ComunicadoService();

  @override
  void initState() {
    super.initState();
    _comunicadosPorFecha = {}; // Aquí cargarías los comunicados
    _comunicadosSeleccionados = [];
    _cargarComunicados(); // Cargar los comunicados al iniciar
  }

  // Cargar los comunicados desde la API y organizarlos por fecha
  void _cargarComunicados() async {
    try {
      List<Comunicado> comunicados =
          await _comunicadoService.obtenerComunicados();
      Map<DateTime, List<Comunicado>> comunicadosPorFecha = {};

      // Agrupa los comunicados por fecha
      for (var comunicado in comunicados) {
        DateTime fecha = comunicado.fecha
            as DateTime; // Suponiendo que el objeto 'Comunicado' tiene la propiedad 'fecha'
        if (comunicadosPorFecha[fecha] == null) {
          comunicadosPorFecha[fecha] = [];
        }
        comunicadosPorFecha[fecha]!.add(comunicado);
      }

      setState(() {
        _comunicadosPorFecha = comunicadosPorFecha;
      });
    } catch (e) {
      print('Error al cargar los comunicados: $e');
    }
  }

  // Obtén los comunicados para una fecha seleccionada
  List<Comunicado> _obtenerComunicadosParaFecha(DateTime fecha) {
    return _comunicadosPorFecha[fecha] ?? [];
  }

  // Agregar un comunicado manualmente a la fecha actual
  void _agregarComunicadoManual() {
    DateTime fechaHoy = DateTime.now();
    Comunicado nuevoComunicado = Comunicado(
      id: '999', // Asignar un ID único para el communicate
      fecha: fechaHoy.toString(),
      titulo: "Comunicado Manual",
      descripcion: "Este es un comunicado manual agregado a la fecha actual.",
      imagen: '', hora: '', tipo: '', autorEmail: '', autorNombre: '',
    );

    // Agregarlo al mapa de comunicados por fecha
    if (_comunicadosPorFecha[fechaHoy] == null) {
      _comunicadosPorFecha[fechaHoy] = [];
    }
    _comunicadosPorFecha[fechaHoy]!.add(nuevoComunicado);

    // Actualizar el estado para reflejar el cambio
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      // drawer: MenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 01, 01),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              // Mostrar los comunicados en las fechas correspondientes
              eventLoader: (day) {
                return _obtenerComunicadosParaFecha(day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Mostrar los detalles de los comunicados de esa fecha
                List<Comunicado> comunicados =
                    _obtenerComunicadosParaFecha(selectedDay);
              },
            ),
          ),
        ],
      ),
    );
  }
}
