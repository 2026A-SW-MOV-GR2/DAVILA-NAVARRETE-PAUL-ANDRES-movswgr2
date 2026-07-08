# T. Clase 06 — Ciclo de vida y persistencia en Flutter

Contador implementado para el taller "La batalla del estado". El código vive en:

- [lib/main.dart](lib/main.dart) — arranque de la app, define `restorationScopeId`.
- [lib/counter_page.dart](lib/counter_page.dart) — pantalla del contador, observador de ciclo de vida y restauración de estado.
- [lib/lifecycle_logger.dart](lib/lifecycle_logger.dart) — helper para imprimir los logs con el mismo nombre que Android nativo.

## Cómo se mapea el ciclo de vida en Flutter

Flutter no tiene una "Activity" propia: el motor corre dentro de una única `FlutterActivity` nativa y expone los cambios a través de dos mecanismos distintos:

| Evento Android nativo | Equivalente en Flutter | Dónde se engancha |
|---|---|---|
| `onCreate` | `State.initState()` | Se ejecuta una sola vez al crear el `State`. |
| `onStart` | `initState()` (primera vez) / tras `AppLifecycleState.paused → resumed` | No hay callback separado; se infiere. |
| `onResume` | `didChangeDependencies()` (primer frame) y `AppLifecycleState.resumed` | `WidgetsBindingObserver.didChangeAppLifecycleState` |
| `onPause` | `AppLifecycleState.inactive` | ídem |
| `onStop` | `AppLifecycleState.paused` (o `hidden`) | ídem |
| `onRestart` | Transición `paused/hidden → resumed` | Se detecta comparando con el estado anterior. |
| `onDestroy` | `State.dispose()` / `AppLifecycleState.detached` | Solo se dispara si el widget se remueve del árbol, **no** en una rotación. |
| `onSaveInstanceState` / `onRestoreInstanceState` | `RestorationMixin` + `RestorableProperty` (`RestorableInt`) | `registerForRestoration` en `restoreState()`. |

## Experimento: rotación

**El contador NO vuelve a 0 al rotar.** A diferencia de una `Activity` Android nativa (que por defecto se destruye y recrea en cada cambio de configuración, obligando a usar `onSaveInstanceState`), el proyecto Flutter generado ya trae en
`android/app/src/main/AndroidManifest.xml`:

```xml
android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
```

Esto le dice a Android que **no destruya la Activity** ante esos cambios; Flutter solo recibe el nuevo tamaño/orientación y vuelve a llamar a `build()`, pero el objeto `State` (y por lo tanto `_count`) sigue vivo. Por eso, en los logs de una rotación **no aparece `onDestroy` ni `onCreate`**, solo se ve `build()` ejecutándose de nuevo.

> Esta es la "pista" del taller: en Flutter la solución no es igual a Android nativo. No necesitas guardar el estado manualmente para sobrevivir a una rotación; necesitas `RestorationMixin` únicamente para sobrevivir a la **muerte del proceso** (cuando el sistema operativo mata la app en segundo plano por falta de memoria).

## Experimento: multitarea / muerte de proceso

Al salir al Home y volver, si Android no mató el proceso, la secuencia es:

```
onPause()
onStop()
...
onRestart()
onStart()
onResume()
```

y el contador se mantiene porque el `State` nunca se destruyó.

Para forzar el caso real que sí borra el estado (el que en Android nativo resuelve `onSaveInstanceState`), hay que activar en el dispositivo **Opciones de desarrollador → No conservar actividades**, salir al Home y volver. Ahí sí se ve:

```
onPause()
onStop()
onDestroy()
[proceso recreado]
onCreate()
onStart()
onRestoreInstanceState() -> count = <valor guardado>
onResume()
```

y el contador se recupera gracias a `RestorableInt`, que persiste automáticamente el valor a través del canal de restauración de Android.

## Qué se usó para no perder el estado

- `WidgetsBindingObserver` + `didChangeAppLifecycleState` para registrar los eventos de ciclo de vida en consola.
- `RestorationMixin` + `RestorableInt` (en vez de `onSaveInstanceState`/`onRestoreInstanceState`) para persistir el contador ante la muerte real del proceso.
- `restorationScopeId` en `MaterialApp` para habilitar la restauración en toda la app.
