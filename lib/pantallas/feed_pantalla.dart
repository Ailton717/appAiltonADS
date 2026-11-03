import 'package:flutter/material.dart';

import '../anuncios/anuncios_config.dart';
import '../datos/articulos_repositorio.dart';
import '../modelos/articulo.dart';
import '../widgets/articulo_card.dart';
import '../widgets/banner_intercalado.dart';

/// Marcador que ocupa una posicion de la lista reservada a un anuncio.
class _RanuraAnuncio {
  const _RanuraAnuncio(this.numero);

  /// Orden del anuncio dentro del feed, usado como clave del widget.
  final int numero;
}

/// Pantalla principal: lista desplazable de articulos con anuncios
/// intercalados entre el contenido.
class FeedPantalla extends StatefulWidget {
  const FeedPantalla({super.key});

  @override
  State<FeedPantalla> createState() => _FeedPantallaState();
}

class _FeedPantallaState extends State<FeedPantalla> {
  late final List<Object> _elementos = _intercalarAnuncios(
    const ArticulosRepositorio().obtenerArticulos(),
  );

  /// Reparte los articulos y coloca una ranura de anuncio cada
  /// [AnunciosConfig.articulosEntreAnuncios] articulos.
  ///
  /// No se agrega un anuncio al final de la lista: el ultimo bloque de
  /// contenido cierra el feed.
  List<Object> _intercalarAnuncios(List<Articulo> articulos) {
    final elementos = <Object>[];
    var anunciosColocados = 0;

    for (var i = 0; i < articulos.length; i++) {
      elementos.add(articulos[i]);

      final cerroBloque = (i + 1) % AnunciosConfig.articulosEntreAnuncios == 0;
      final quedaContenido = i < articulos.length - 1;
      if (cerroBloque && quedaContenido) {
        elementos.add(_RanuraAnuncio(anunciosColocados));
        anunciosColocados++;
      }
    }

    return elementos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Feed'),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _elementos.length,
        itemBuilder: (context, indice) {
          final elemento = _elementos[indice];
          if (elemento is _RanuraAnuncio) {
            return BannerIntercalado(key: ValueKey('anuncio-${elemento.numero}'));
          }
          return ArticuloCard(articulo: elemento as Articulo);
        },
      ),
    );
  }
}
