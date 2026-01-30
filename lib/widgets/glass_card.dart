import 'dart:ui';
import 'package:flutter/material.dart';
import '../design/responsive.dart';
import '../constants/colors.dart';

/// Card com efeito de vidro (glassmorphism) para fundos claros.
/// Mantém legibilidade do texto com opacidade branca elevada.
/// Não usar em alertas ou tabelas.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma = 10,
    this.colorOpacity = 0.82,
    this.borderOpacity = 0.35,
    this.useGlass = true,
    /// Se true, assume fundo escuro (verde) e usa borda branca. Se false, assume fundo claro e usa borda verde.
    this.isDarkBackground = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double blurSigma;
  final double colorOpacity;
  final double borderOpacity;
  /// Se false (ex.: alto contraste), renderiza como container sólido sem blur.
  final bool useGlass;
  final bool isDarkBackground;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final radius = borderRadius ?? r.radiusMD;
    final padding = this.padding ?? r.pad(all: 16);

    // Define cor da borda baseado no fundo
    final borderColor = isDarkBackground 
        ? Colors.white.withOpacity(0.4)  // Borda branca para fundo verde
        : AppColors.darkGreenHeader.withOpacity(0.3);  // Borda verde para fundo claro

    if (!useGlass) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isDarkBackground 
                ? Colors.white.withOpacity(0.3)
                : AppColors.darkGreenHeader.withOpacity(0.3),
            width: r.s(1.5),
          ),
        ),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(colorOpacity),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor,
              width: r.s(1.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
