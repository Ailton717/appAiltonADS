import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../anuncios/anuncios_config.dart';

/// Banner adaptable intercalado (*inline adaptive banner*).
///
/// A diferencia del banner anclado, que queda fijo en un borde de la pantalla,
/// este formato vive dentro del contenido desplazable. Se solicita con el ancho
/// realmente disponible y adopta la altura que el propio SDK reporta una vez
/// cargado, de modo que se intercala entre los articulos sin tapar la interfaz
/// ni dejar huecos vacios.
class BannerIntercalado extends StatefulWidget {
  const BannerIntercalado({super.key});

  @override
  State<BannerIntercalado> createState() => _BannerIntercaladoState();
}

class _BannerIntercaladoState extends State<BannerIntercalado>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _anuncio;
  AdSize? _tamanoCargado;
  bool _cargaEnCurso = false;
  int _anchoSolicitado = 0;

  /// Mantiene el anuncio vivo mientras se desplaza la lista, para no pagar
  /// una recarga cada vez que la fila sale y vuelve a entrar en pantalla.
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // El ancho disponible cambia al rotar el dispositivo o en pantalla
    // dividida; en ese caso se pide un anuncio con el nuevo tamano.
    final anchoActual = MediaQuery.sizeOf(context).width.truncate();
    if (anchoActual != _anchoSolicitado && anchoActual > 0) {
      _anchoSolicitado = anchoActual;
      _cargarAnuncio(anchoActual);
    }
  }

  Future<void> _cargarAnuncio(int ancho) async {
    if (_cargaEnCurso) return;
    _cargaEnCurso = true;

    final anterior = _anuncio;
    if (anterior != null) {
      _anuncio = null;
      _tamanoCargado = null;
      await anterior.dispose();
    }

    // El ancho lo fija la aplicacion; la altura la decide el anuncio servido.
    final tamanoSolicitado =
        AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(ancho);

    final banner = BannerAd(
      adUnitId: AnunciosConfig.bannerIntercaladoId,
      size: tamanoSolicitado,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (anuncio) async {
          // En un banner intercalado el tamano definitivo solo se conoce
          // consultando la plataforma despues de la carga.
          final tamanoReal = await (anuncio as BannerAd).getPlatformAdSize();
          if (!mounted) {
            await anuncio.dispose();
            return;
          }
          setState(() {
            _anuncio = anuncio;
            _tamanoCargado = tamanoReal;
            _cargaEnCurso = false;
          });
        },
        onAdFailedToLoad: (anuncio, error) {
          debugPrint('Banner intercalado no disponible: ${error.message}');
          anuncio.dispose();
          _cargaEnCurso = false;
          if (!mounted) return;
          setState(() {
            _anuncio = null;
            _tamanoCargado = null;
          });
        },
      ),
    );

    await banner.load();
  }

  @override
  void dispose() {
    _anuncio?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final anuncio = _anuncio;
    final tamano = _tamanoCargado;

    // Mientras no haya anuncio la lista no reserva espacio: el feed se ve
    // igual que sin publicidad.
    if (anuncio == null || tamano == null) {
      return const SizedBox.shrink();
    }

    final colores = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PUBLICIDAD',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colores.outline,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: tamano.width.toDouble(),
              height: tamano.height.toDouble(),
              child: AdWidget(ad: anuncio),
            ),
          ),
        ],
      ),
    );
  }
}
