/// Representa una nota del feed principal de la aplicacion.
class Articulo {
  const Articulo({
    required this.titulo,
    required this.categoria,
    required this.resumen,
    required this.minutosLectura,
  });

  final String titulo;
  final String categoria;
  final String resumen;
  final int minutosLectura;
}
