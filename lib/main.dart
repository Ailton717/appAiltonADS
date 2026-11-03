import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'pantallas/feed_pantalla.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // La inicializacion del SDK no se espera antes de dibujar: si el
  // dispositivo no tiene Google Play Services, los tiene desactualizados o
  // esta sin red, esa llamada puede fallar o no responder nunca. Bloquear
  // runApp con ella deja la aplicacion sin pintar y el sistema la cierra.
  //
  // El feed debe abrir siempre; la publicidad es un extra que puede faltar.
  unawaited(_inicializarAnuncios());

  runApp(const AppAiltonAds());
}

Future<void> _inicializarAnuncios() async {
  try {
    await MobileAds.instance.initialize();
  } catch (error, rastro) {
    debugPrint('No se pudo inicializar Google Mobile Ads: $error');
    debugPrintStack(stackTrace: rastro);
  }
}

class AppAiltonAds extends StatelessWidget {
  const AppAiltonAds({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Feed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
        useMaterial3: true,
      ),
      home: const FeedPantalla(),
    );
  }
}
