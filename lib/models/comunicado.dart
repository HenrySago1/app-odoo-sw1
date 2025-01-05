class Comunicado {
  final String id;
  final String titulo;
  final String descripcion;
  final String imagen;
  final String fecha;
  final String hora;
  final String tipo;
  final String autorNombre;
  final String autorEmail;

  Comunicado({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.fecha,
    required this.hora,
    required this.tipo,
    required this.autorNombre,
    required this.autorEmail,
  });

  // Método para crear un comunicado desde un mapa (ej. JSON)
  factory Comunicado.fromJson(Map<String, dynamic> json) {
    // Convertir la hora en formato numérico a un string legible (ej. "15.3" -> "15:30")
    String horaConvertida = json['hora'].toString().contains('.')
        ? json['hora'].toString().replaceAll('.', ':') + '0'
        : json['hora'].toString() + ':00';

    return Comunicado(
      id: json['comunicado_id']?.toString() ?? '',  // Asegúrate de que sea un String
      titulo: json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      imagen: json['imagen']?.toString() ?? '',
      fecha: json['fecha']?.toString() ?? '',
      hora: horaConvertida,
      tipo: json['tipo']?.toString() ?? '',
      autorNombre: json['autor_nombre']?.toString() ?? '',
      autorEmail: json['autor_email']?.toString() ?? '',
    );
  }

}
