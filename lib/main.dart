import 'package:flutter/material.dart';

import 'pantallas/feed_pantalla.dart';

void main() {
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
