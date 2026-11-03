import 'dart:io';

/// Identificadores de las unidades de anuncio utilizadas por la aplicacion.
///
/// Durante el desarrollo se emplean exclusivamente las unidades oficiales de
/// prueba de Google. Usar un ID de produccion contra trafico propio puede
/// provocar la suspension de la cuenta de AdMob.
class AnunciosConfig {
  const AnunciosConfig._();

  /// Formato asignado (numero de lista 3): banner adaptable intercalado.
  ///
  /// Unidad de prueba para Android indicada en la practica.
  /// https://developers.google.com/admob/android/test-ads?hl=es-419
  static const String _bannerIntercaladoAndroid =
      'ca-app-pub-3940256099942544/9214589741';

  /// Unidad de prueba equivalente para iOS.
  /// https://developers.google.com/admob/ios/test-ads?hl=es-419
  static const String _bannerIntercaladoIos =
      'ca-app-pub-3940256099942544/2435281174';

  /// Unidad de anuncio que corresponde a la plataforma en ejecucion.
  static String get bannerIntercaladoId =>
      Platform.isAndroid ? _bannerIntercaladoAndroid : _bannerIntercaladoIos;

  /// Cantidad de articulos que se muestran entre un anuncio y el siguiente.
  static const int articulosEntreAnuncios = 3;
}
