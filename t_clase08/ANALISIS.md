# Taller 08 — Native UI Re-Engineering & UX Analysis

**App seleccionada:** **Deuna** — billetera digital / red de pagos QR
interoperable usada en Ecuador (permite enviar, cobrar y pagar entre
distintos bancos con solo un número de celular).
**Tecnología:** Flutter (Skia/Impeller, sin WebViews).
**Referencia visual:** capturas reales de la app (pantallas Inicio,
Beneficios, Mapa, Billetera y Tú) provistas para el clon.

## Fase A — Selección y Análisis

### Definición de mercado
Deuna está dirigida principalmente a:

- **Edad:** 16–45 años. Incluye explícitamente a menores desde los 12 años
  ("Deuna Jóvenes" y la cuenta para hijos/as en la pantalla Billetera), algo
  poco común en banca tradicional.
- **Intereses:** pagos instantáneos entre personas y negocios vía QR,
  recargas de celular, pago de servicios, transporte (Metro de Quito),
  descuentos en comercios afiliados ("Deuna Veci").
- **Nivel socioeconómico:** medio y medio-bajo; al ser una red interbancaria
  (no exige cuenta de un banco específico) reduce la barrera de entrada
  frente a apps bancarias tradicionales.

### Psicología del color
Paleta implementada en [`lib/theme/app_colors.dart`](lib/theme/app_colors.dart)
a partir de las capturas reales:

| Rol | Color | Justificación |
|---|---|---|
| Background | Blanco `#FFFFFF` | Simplicidad y confianza inmediata: una billetera de uso diario (varias veces al día) debe leerse rápido, sin fricción visual. |
| Primario | Morado `#5A2D82` | Diferencia a Deuna de los azules/amarillos de la banca tradicional; el morado se asocia a innovación y a una marca "neutral" entre bancos, coherente con ser una red interbancaria y no de un banco específico. |
| Acento | Verde menta `#1FCDA6` | Reservado para "lo nuevo" (badges "Nuevo" en Beneficios/Billetera) y ahorro/recompensa; el verde refuerza connotación de dinero/beneficio sin competir visualmente con el morado de marca. |
| Semánticos | Verde `#1FA971` (positivo), Rojo `#E5484D` (negativo), Ámbar `#E0A233` (pendiente) | Código de semáforo universal para el signo de un movimiento. |

*Nota:* los valores hexadecimales son una aproximación visual a partir de
las capturas (no se contó con el manual de marca oficial de Deuna).

### Auditoría de componentes (listas/iterables a clonar)
1. **Grid de acciones rápidas** (Transferir, Transferir a otro banco,
   Recargar, Cobrar, Retirar, Recarga celular, Pagar servicios, Metro de
   Quito, Deuna Jóvenes, Invita y Gana) — `GridView.builder` 4 columnas.
2. **Movimientos / historial de transacciones** — lista vertical extensa
   (100 registros simulados), accesible desde "Ver más" en Inicio o al
   tocar una cuenta en Billetera.
3. **Beneficios (Club Deuna)** — lista vertical con ítems bloqueados
   (candado) vs. desbloqueados.
4. **Directorio de negocios (Mapa)** — lista de comercios "Deuna Veci"
   sincronizada con pines en el mapa simulado.
5. **Cuentas (Billetera)** y **opciones de perfil (Tú)** — listas
   adicionales más cortas.
6. *(Extra)* **Promociones** — carrusel horizontal tipo banner, tanto en
   Inicio como en la pestaña Promociones de Beneficios.

## Fase B — Desarrollo Técnico

- **Modelos:** `WalletTransaction`, `WalletContact`, `WalletPromo`,
  `QuickAction`, `BenefitItem`, `WalletAccount`, `Business` (`lib/models/`).
- **Datos simulados:** `lib/data/mock_data.dart` genera 100 transacciones y
  20 contactos con `Random` semillado, para probar el scroll con volumen
  realista, además de las acciones, beneficios, cuentas y negocios del mapa.
- **Listas:** todas implementadas con `ListView.builder` / `GridView.builder`
  / `SliverList.builder` (construcción perezosa), equivalente al
  `RecyclerView` de Android o `LazyColumn` de Compose.
- **Mapa simulado:** en vez de integrar un SDK de mapas real (requeriría
  API key y tiles de red, fuera del alcance del taller), `FakeMap`
  (`lib/widgets/fake_map.dart`) dibuja calles abstractas con `CustomPainter`
  y ubica pines de negocios en coordenadas relativas — mantiene el 100% de
  renderizado nativo (sin WebView) exigido por el taller.
- **Animaciones de entrada escalonadas** (`FadeSlideIn`) se limitan a los
  primeros ítems visibles (`index < 12`) en listas largas para no penalizar
  el rendimiento del scroll profundo — decisión explícita de eficiencia.

## Fase C — Crítica y Propuesta de Mejora

**Falla detectada en la app original:** para buscar un movimiento o
contacto específico, el flujo típico exige entrar primero al historial y
luego tocar un ícono de lupa que despliega el campo de búsqueda (un tap
extra antes de poder escribir).

**Mejora implementada:** en `MovementsScreen`
(`lib/screens/movements_screen.dart`), `ContactsScreen`
(`lib/screens/contacts_screen.dart`) y `MapScreen`
(`lib/screens/map_screen.dart`) el campo de búsqueda es **persistente**
(siempre visible arriba, combinable con los chips de filtro por tipo en
Movimientos), eliminando el tap adicional y reduciendo el tiempo para
encontrar un movimiento, contacto o negocio puntual.

## Criterios de evaluación — cómo se cubren

| Criterio | Cómo se aborda |
|---|---|
| Fidelidad visual | Tema claro morado/menta calcado de capturas reales: header con avatar y notificaciones, tarjeta de saldo con fila de recarga, grid 4 columnas, botón "Escanear QR", nav inferior de 5 pestañas con badges "Nuevo". |
| Eficiencia de listas | `ListView.builder`/`GridView.builder`/`Sliver*.builder` en todas las listas; animaciones de entrada acotadas a los primeros ítems. |
| Análisis de producto | Ver secciones de mercado y color arriba. |
| Propuesta de mejora | Buscador persistente en Movimientos, Contactos y Mapa. |
| Código limpio | Separación en `models/`, `data/`, `theme/`, `widgets/`, `screens/`; widgets pequeños de responsabilidad única. |
