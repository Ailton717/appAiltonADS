# appAiltonADS

Aplicacion movil desarrollada en Flutter para la practica de
**Integracion de aplicaciones moviles con servicios en la nube**.

La app presenta un feed de articulos en una lista desplazable. Sobre esta
base se integra posteriormente el formato de anuncio asignado.

## Estructura

```
lib/
  main.dart                     Punto de entrada y tema de la aplicacion
  modelos/articulo.dart         Modelo de datos del articulo
  datos/articulos_repositorio.dart  Fuente de datos local del feed
  pantallas/feed_pantalla.dart  Pantalla principal con la lista
  widgets/articulo_card.dart    Tarjeta visual de cada articulo
```

## Requisitos

- Flutter 3.47 o superior
- Android SDK (API 21+)

## Ejecucion

```bash
flutter pub get
flutter run
```
