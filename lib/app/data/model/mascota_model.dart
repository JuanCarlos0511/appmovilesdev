/// Modelo de dominio para Mascota.
/// Puro Dart — sin dependencias de almacenamiento.
class Mascota {
  final String id;
  final String nombre;
  final String especie;
  final int edad;

  const Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.edad,
  });

  // ---------- Serialización ----------

  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      especie: json['especie'] as String,
      edad: json['edad'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'especie': especie,
        'edad': edad,
      };

  // ---------- Inmutabilidad ----------

  Mascota copyWith({
    String? id,
    String? nombre,
    String? especie,
    int? edad,
  }) {
    return Mascota(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      especie: especie ?? this.especie,
      edad: edad ?? this.edad,
    );
  }

  @override
  String toString() =>
      'Mascota(id: $id, nombre: $nombre, especie: $especie, edad: $edad)';
}
