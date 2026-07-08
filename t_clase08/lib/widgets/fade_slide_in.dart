import 'package:flutter/material.dart';

/// Anima la entrada de un item de lista (fade + slide hacia arriba) con un
/// retraso proporcional a su índice, logrando un efecto "escalonado" al
/// construirse la pantalla, sin animar cada rebuild (solo una vez, vía
/// [TweenAnimationBuilder] con delay simulado por índice).
class FadeSlideIn extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration baseDelay;

  const FadeSlideIn({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = const Duration(milliseconds: 40),
  });

  @override
  Widget build(BuildContext context) {
    final delayMs = (baseDelay.inMilliseconds * index).clamp(0, 400);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
