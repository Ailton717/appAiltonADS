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
  /// Separacion alrededor del anuncio. Se declara una sola vez porque sirve
  /// para dos cosas que deben coincidir: descontar el espacio al medir el
  /// ancho que se le pide al SDK y dibujar ese mismo margen.
  static const EdgeInsets _margen =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// Intentos adicionales cuando la peticion falla, por ejemplo si el
  /// dispositivo todavia no tiene red al abrir la aplicacion.
  static const int _maxReintentos = 2;
  static const Duration _esperaReintento = Duration(seconds: 5);

  BannerAd? _anuncio;
  AdSize? _tamanoCargado;
  bool _cargaEnCurso = false;
  int _reintentos = 0;

  /// Ancho que el layout pide en este momento.
  int _anchoObjetivo = 0;

  /// Ancho con el que se solicito el anuncio actual.
  int _anchoAtendido = 0;

  /// Mantiene el anuncio vivo mientras se desplaza la lista, para no pagar
  /// una recarga cada vez que la fila sale y vuelve a entrar en pantalla.
  @override
  bool get wantKeepAlive => true;

  /// Registra el ancho disponible y agenda la peticion correspondiente.
  ///
  /// Se invoca desde el layout, por lo que la carga se difiere al final del
  /// frame: `build` no debe provocar efectos secundarios ni `setState`.
  void _sincronizarAncho(double anchoDisponible) {
    final ancho = anchoDisponible.truncate();
    if (ancho <= 0 || ancho == _anchoObjetivo) return;

    _anchoObjetivo = ancho;
    _reintentos = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _cargaEnCurso) return;
      if (_anchoObjetivo != _anchoAtendido) {
        _cargarAnuncio(_anchoObjetivo);
      }
    });
  }

  Future<void> _cargarAnuncio(int ancho) async {
    _cargaEnCurso = true;
    _anchoAtendido = ancho;

    final anterior = _anuncio;
    if (anterior != null) {
      setState(() {
        _anuncio = null;
        _tamanoCargado = null;
      });
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
            _reintentos = 0;
          });
          _finalizarCarga();
        },
        onAdFailedToLoad: (anuncio, error) {
          debugPrint('Banner intercalado no disponible: ${error.message}');
          anuncio.dispose();
          if (!mounted) {
            _cargaEnCurso = false;
            return;
          }
          setState(() {
            _anuncio = null;
            _tamanoCargado = null;
          });
          _finalizarCarga();
          _programarReintento();
        },
      ),
    );

    // Si el SDK no quedo disponible, la peticion lanza. El feed debe seguir
    // funcionando sin publicidad, asi que el error se registra y no se
    // propaga.
    try {
      await banner.load();
    } catch (error) {
      debugPrint('No se pudo solicitar el banner intercalado: $error');
      await banner.dispose();
      _cargaEnCurso = false;
    }
  }

  /// Cierra la carga en curso y atiende un ancho que haya cambiado mientras
  /// el anuncio viajaba, por ejemplo al rotar el dispositivo durante la
  /// peticion. Sin esto el banner se quedaria con el tamano anterior.
  void _finalizarCarga() {
    _cargaEnCurso = false;
    if (!mounted) return;
    if (_anchoObjetivo > 0 && _anchoObjetivo != _anchoAtendido) {
      _cargarAnuncio(_anchoObjetivo);
    }
  }

  void _programarReintento() {
    if (_reintentos >= _maxReintentos) return;
    _reintentos++;

    Future.delayed(_esperaReintento, () {
      if (!mounted || _cargaEnCurso || _anchoObjetivo <= 0) return;
      _cargarAnuncio(_anchoObjetivo);
    });
  }

  @override
  void dispose() {
    _anuncio?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LayoutBuilder(
      builder: (context, restricciones) {
        // Ancho real que queda para el anuncio una vez descontado el margen.
        _sincronizarAncho(restricciones.maxWidth - _margen.horizontal);

        final anuncio = _anuncio;
        final tamano = _tamanoCargado;

        // Mientras no haya anuncio la fila no ocupa nada, ni siquiera el
        // margen: el feed se ve igual que sin publicidad.
        if (anuncio == null || tamano == null) {
          return const SizedBox.shrink();
        }

        final colores = Theme.of(context).colorScheme;

        return Padding(
          padding: _margen,
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
      },
    );
  }
}
