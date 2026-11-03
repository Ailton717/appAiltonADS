import 'package:flutter/material.dart';

import '../datos/articulos_repositorio.dart';
import '../modelos/articulo.dart';
import '../widgets/articulo_card.dart';

/// Pantalla principal: lista desplazable de articulos.
class FeedPantalla extends StatefulWidget {
  const FeedPantalla({super.key});

  @override
  State<FeedPantalla> createState() => _FeedPantallaState();
}

class _FeedPantallaState extends State<FeedPantalla> {
  final List<Articulo> _articulos =
      const ArticulosRepositorio().obtenerArticulos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Feed'),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _articulos.length,
        itemBuilder: (context, indice) {
          return ArticuloCard(articulo: _articulos[indice]);
        },
      ),
    );
  }
}
