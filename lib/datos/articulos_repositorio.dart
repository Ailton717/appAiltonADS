import '../modelos/articulo.dart';

/// Fuente de datos local que alimenta el feed.
///
/// Se mantiene en memoria porque el objetivo de la practica es la
/// integracion del anuncio, no el consumo de un servicio remoto.
class ArticulosRepositorio {
  const ArticulosRepositorio();

  List<Articulo> obtenerArticulos() {
    return const [
      Articulo(
        titulo: 'Servicios en la nube para aplicaciones moviles',
        categoria: 'Cloud',
        resumen:
            'Como apoyarse en backends administrados para reducir el tiempo '
            'de salida a produccion de una app movil.',
        minutosLectura: 4,
      ),
      Articulo(
        titulo: 'Monetizacion sin arruinar la experiencia de usuario',
        categoria: 'Negocio',
        resumen:
            'Donde colocar los anuncios dentro de una interfaz para que '
            'aporten ingresos sin interrumpir la navegacion.',
        minutosLectura: 6,
      ),
      Articulo(
        titulo: 'Arquitectura por capas en Flutter',
        categoria: 'Desarrollo',
        resumen:
            'Separar modelos, datos y presentacion hace que una pantalla '
            'crezca sin volverse inmanejable.',
        minutosLectura: 5,
      ),
      Articulo(
        titulo: 'Listas desplazables de alto rendimiento',
        categoria: 'Desarrollo',
        resumen:
            'ListView.builder construye solo lo visible, lo que mantiene '
            'fluido el scroll aun con cientos de elementos.',
        minutosLectura: 3,
      ),
      Articulo(
        titulo: 'Control de versiones en proyectos academicos',
        categoria: 'Herramientas',
        resumen:
            'Commits pequenos y descriptivos permiten reconstruir la historia '
            'de un proyecto meses despues.',
        minutosLectura: 4,
      ),
      Articulo(
        titulo: 'Pruebas en dispositivos reales',
        categoria: 'Calidad',
        resumen:
            'El emulador acelera el desarrollo, pero el comportamiento final '
            'siempre se confirma en hardware fisico.',
        minutosLectura: 5,
      ),
      Articulo(
        titulo: 'Diseno adaptable a cualquier pantalla',
        categoria: 'Diseno',
        resumen:
            'Medir el ancho disponible antes de dibujar evita desbordes en '
            'telefonos pequenos y tablets.',
        minutosLectura: 4,
      ),
      Articulo(
        titulo: 'Publicacion en Google Play paso a paso',
        categoria: 'Negocio',
        resumen:
            'Firma de la aplicacion, ficha de la tienda y politicas de '
            'contenido antes de la primera version.',
        minutosLectura: 7,
      ),
    ];
  }
}
