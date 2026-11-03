import 'package:flutter/material.dart';

import '../modelos/articulo.dart';

/// Tarjeta que muestra un articulo dentro del feed.
class ArticuloCard extends StatelessWidget {
  const ArticuloCard({super.key, required this.articulo});

  final Articulo articulo;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final colores = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colores.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    articulo.categoria.toUpperCase(),
                    style: temaTexto.labelSmall?.copyWith(
                      color: colores.onSecondaryContainer,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.schedule, size: 14, color: colores.outline),
                const SizedBox(width: 4),
                Text(
                  '${articulo.minutosLectura} min',
                  style: temaTexto.labelSmall?.copyWith(color: colores.outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(articulo.titulo, style: temaTexto.titleMedium),
            const SizedBox(height: 8),
            Text(
              articulo.resumen,
              style: temaTexto.bodyMedium?.copyWith(
                color: colores.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
