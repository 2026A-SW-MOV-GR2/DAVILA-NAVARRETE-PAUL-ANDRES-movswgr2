import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pantalla de escaneo QR con cámara real (sin decodificación de QR: el
/// taller pide fidelidad visual de la UI, no un lector de códigos
/// funcional). Calca la pantalla de "Escanear QR" de Deuna: recuadro
/// redondeado sobre la vista de cámara, botón de volver, linterna y
/// atajo a "Código único de pago".
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _torchOn = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initFuture = _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = 'No se encontró ninguna cámara en este dispositivo.');
        return;
      }
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(back, ResolutionPreset.medium, enableAudio: false);
      await controller.initialize();
      if (!mounted) return;
      setState(() => _controller = controller);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'No se pudo acceder a la cámara.\n$e');
    }
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null) return;
    final next = !_torchOn;
    try {
      await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      setState(() => _torchOn = next);
    } catch (_) {
      // Algunos dispositivos/emuladores no tienen flash: se ignora.
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          return Stack(
            fit: StackFit.expand,
            children: [
              if (_controller != null && _controller!.value.isInitialized)
                Center(child: CameraPreview(_controller!))
              else if (_error == null)
                const Center(child: CircularProgressIndicator(color: Colors.white)),
              const _ScannerOverlay(),
              SafeArea(child: _TopBar(torchOn: _torchOn, onTorchTap: _toggleTorch)),
              const _BottomHint(),
              if (_error != null) _ErrorState(message: _error!),
            ],
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool torchOn;
  final VoidCallback onTorchTap;

  const _TopBar({required this.torchOn, required this.onTorchTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RoundIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          _RoundIconButton(
            icon: torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            onTap: onTorchTap,
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

/// Oscurece toda la pantalla salvo el recuadro central redondeado, igual
/// al recorte de la cámara nativa sobre el visor.
class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth * 0.78;
        final holeRect = Rect.fromLTWH(
          (constraints.maxWidth - side) / 2,
          constraints.maxHeight * 0.24,
          side,
          side,
        );
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _HolePainter(holeRect: holeRect)),
            Positioned(
              left: 24,
              right: 24,
              top: holeRect.bottom + 24,
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                      children: [
                        TextSpan(text: 'Escanea un QR '),
                        TextSpan(
                          text: 'deuna!',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'para hacer pagos, retiros o verificaciones',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HolePainter extends CustomPainter {
  final Rect holeRect;

  const _HolePainter({required this.holeRect});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(holeRect, const Radius.circular(28));
    final overlay = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(rrect),
    );
    canvas.drawPath(overlay, Paint()..color = Colors.black.withValues(alpha: 0.55));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _HolePainter oldDelegate) => oldDelegate.holeRect != holeRect;
}

class _BottomHint extends StatelessWidget {
  const _BottomHint();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 32,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dialpad_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text('Código único de pago',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.videocam_off_rounded, color: Colors.white54, size: 40),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Volver', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
