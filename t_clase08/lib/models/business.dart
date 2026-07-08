/// Punto del "Directorio de negocios" en el mapa. [dx]/[dy] son fracciones
/// (0..1) de la posición dentro del lienzo del mapa simulado.
class Business {
  final String name;
  final double dx;
  final double dy;

  const Business({required this.name, required this.dx, required this.dy});
}
