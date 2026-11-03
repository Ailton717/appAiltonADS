# appAiltonADS

Aplicacion movil desarrollada en Flutter para la practica de
**Integracion de aplicaciones moviles con servicios en la nube**.

La app presenta un feed de articulos en una lista desplazable e integra el
formato de anuncio asignado por numero de lista.

## Formato de anuncio integrado

| Dato | Valor |
| --- | --- |
| Numero de lista | 3 |
| Formato | Banner adaptable intercalado (*inline adaptive banner*) |
| Unidad de anuncio (Android) | `ca-app-pub-3940256099942544/9214589741` |
| Unidad de anuncio (iOS) | `ca-app-pub-3940256099942544/2435281174` |
| ID de aplicacion AdMob (Android) | `ca-app-pub-3940256099942544~3347511713` |
| SDK | `google_mobile_ads` |

Todos los identificadores son las **unidades oficiales de prueba de Google**.
No se utiliza ningun ID de produccion.

Fuente: <https://developers.google.com/admob/android/test-ads?hl=es-419>

### Por que este formato

El banner adaptable intercalado se coloca *dentro* del contenido desplazable,
a diferencia del banner anclado que queda fijo en un borde de la pantalla.
La aplicacion solicita el anuncio con el ancho realmente disponible y el SDK
decide la altura, por lo que el bloque encaja en cualquier tamano de pantalla
sin recortes ni espacios vacios.

En este proyecto se intercala un anuncio cada tres articulos
(`AnunciosConfig.articulosEntreAnuncios`) y nunca al final de la lista.
Mientras el anuncio no ha cargado, el widget no ocupa espacio, de modo que el
feed se comporta igual que sin publicidad.

## Estructura

```
lib/
  main.dart                          Punto de entrada; inicializa MobileAds
  anuncios/anuncios_config.dart      IDs de prueba y frecuencia del anuncio
  modelos/articulo.dart              Modelo de datos del articulo
  datos/articulos_repositorio.dart   Fuente de datos local del feed
  pantallas/feed_pantalla.dart       Lista que intercala articulos y anuncios
  widgets/articulo_card.dart         Tarjeta visual de cada articulo
  widgets/banner_intercalado.dart    Banner adaptable intercalado
```

Configuracion por plataforma:

- `android/app/src/main/AndroidManifest.xml`: `meta-data` con el
  `com.google.android.gms.ads.APPLICATION_ID`.
- `ios/Runner/Info.plist`: clave `GADApplicationIdentifier`.

## Requisitos

- Flutter 3.47 o superior
- Android SDK (API 21+)

## Ejecucion

```bash
flutter pub get
flutter run
```

Los anuncios de prueba se muestran rotulados como *Test Ad*. Deben verse al
desplazar el feed, despues del tercer articulo y cada tres articulos.

## Historial de versiones

1. `Crear aplicacion de inicio con feed de articulos` - app base sin anuncios.
2. `Integrar banner adaptable intercalado en el feed` - integracion del SDK de
   Google Mobile Ads y del formato asignado.
