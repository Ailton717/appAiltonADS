import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'pantallas/feed_pantalla.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // El SDK de Google Mobile Ads debe quedar inicializado antes de solicitar
  // cualquier anuncio; de lo contrario la primera peticion falla.
  await MobileAds.instance.initialize();

  runApp(const AppAiltonAds());
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
