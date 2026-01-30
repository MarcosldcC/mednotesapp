import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Transição Circular Reveal (Radial Color Transition)
/// 
/// Cria uma animação onde um círculo se expande do centro da tela,
/// revelando a próxima tela com a cor de fundo correspondente.
/// 
/// Características:
/// - Inicia no centro exato da tela
/// - Expande suavemente até cobrir 100% da viewport
/// - Cor do círculo = cor de fundo da próxima tela
/// - Duração: 250ms (entre 220ms e 280ms)
/// - Easing: ease-out (Curves.decelerate)
/// - Sem fade, bounce ou blur
/// - Conteúdo aparece apenas após expansão completa
class CircularRevealRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Color revealColor;
  final Duration transitionDuration;

  CircularRevealRoute({
    required this.child,
    required this.revealColor,
    this.transitionDuration = const Duration(milliseconds: 250),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _CircularRevealTransition(
              animation: animation,
              revealColor: revealColor,
              child: child,
            );
          },
        );
}

class _CircularRevealTransition extends StatelessWidget {
  final Animation<double> animation;
  final Color revealColor;
  final Widget child;

  const _CircularRevealTransition({
    required this.animation,
    required this.revealColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;
    
    // Calcula o raio máximo necessário para cobrir toda a tela
    // Usa a distância do centro até o canto mais distante
    final maxRadius = math.sqrt(
      math.pow(screenSize.width - centerX, 2) +
      math.pow(screenSize.height - centerY, 2),
    );

    // Aplica easing ease-out (decelerate)
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.decelerate,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        // Calcula o raio atual baseado na animação
        final currentRadius = maxRadius * curvedAnimation.value;

        return ClipPath(
          clipper: _CircularRevealClipper(
            centerX: centerX,
            centerY: centerY,
            radius: currentRadius,
          ),
          child: Container(
            color: revealColor,
            child: Opacity(
              // Conteúdo aparece apenas após expansão completa (95% da animação)
              opacity: curvedAnimation.value >= 0.95 ? 1.0 : 0.0,
              child: this.child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// Clipper customizado para criar o efeito de círculo em expansão
class _CircularRevealClipper extends CustomClipper<Path> {
  final double centerX;
  final double centerY;
  final double radius;

  _CircularRevealClipper({
    required this.centerX,
    required this.centerY,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Cria um círculo no centro com o raio atual
    // Este é o caminho que será revelado
    path.addOval(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius,
      ),
    );
    
    return path;
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) {
    return oldClipper.radius != radius ||
        oldClipper.centerX != centerX ||
        oldClipper.centerY != centerY;
  }
}
