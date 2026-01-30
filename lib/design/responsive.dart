import 'package:flutter/material.dart';

/// Sistema de Design Responsivo Centralizado
/// 
/// Fornece breakpoints, funções de escala e tokens responsivos
/// para garantir visualização correta em todos os dispositivos.
class Responsive {
  final BuildContext context;
  final MediaQueryData mediaQuery;

  Responsive._(this.context, this.mediaQuery);

  /// Obtém instância de Responsive do contexto
  static Responsive of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Responsive._(context, mediaQuery);
  }

  /// Dimensões da tela
  double get width => mediaQuery.size.width;
  double get height => mediaQuery.size.height;
  
  /// Dimensões úteis (considerando SafeArea)
  double get usableWidth => width;
  double get usableHeight {
    final padding = mediaQuery.padding;
    return height - padding.top - padding.bottom;
  }

  /// Menor dimensão (usada como base para escala)
  double get minDimension => width < height ? width : height;
  
  /// Altura útil mínima (para evitar overflow)
  double get safeMinHeight => usableHeight.clamp(400, double.infinity);

  // ============================================
  // BREAKPOINTS
  // ============================================
  
  static const double breakpointXS = 360;
  static const double breakpointSM = 400;
  static const double breakpointMD = 480;
  static const double breakpointLG = 600;
  
  /// Identifica o breakpoint atual
  Breakpoint get breakpoint {
    if (width < breakpointXS) return Breakpoint.xs;
    if (width < breakpointSM) return Breakpoint.sm;
    if (width < breakpointMD) return Breakpoint.md;
    if (width < breakpointLG) return Breakpoint.lg;
    return Breakpoint.xl;
  }
  
  bool get isXS => breakpoint == Breakpoint.xs;
  bool get isSM => breakpoint == Breakpoint.sm;
  bool get isMD => breakpoint == Breakpoint.md;
  bool get isLG => breakpoint == Breakpoint.lg;
  bool get isXL => breakpoint == Breakpoint.xl;
  bool get isTablet => width >= breakpointLG;
  bool get isMobile => width < breakpointLG;

  // ============================================
  // FUNÇÕES DE ESCALA
  // ============================================
  
  /// Escala baseada na menor dimensão e breakpoint
  /// Usa uma escala progressiva que reduz em telas pequenas e expande em telas grandes
  double _getScaleFactor() {
    // Usar a menor dimensão para manter proporção consistente
    final referenceDimension = minDimension.clamp(320, 720);
    final baseScale = referenceDimension / 360.0; // Base: 360px
    
    switch (breakpoint) {
      case Breakpoint.xs:
        return baseScale.clamp(0.72, 0.86); // Reduz mais em telas pequenas
      case Breakpoint.sm:
        return baseScale.clamp(0.80, 0.95);
      case Breakpoint.md:
        return baseScale.clamp(0.90, 1.02);
      case Breakpoint.lg:
        return baseScale.clamp(1.00, 1.08);
      case Breakpoint.xl:
        // Para telas muito grandes, limitar mais agressivamente
        if (width > 1200) {
          return baseScale.clamp(1.05, 1.12);
        }
        return baseScale.clamp(1.05, 1.15);
    }
  }

  /// Spacing escalável (padding, margin, gaps)
  /// [value] - valor base em pixels
  /// [min] - valor mínimo (opcional)
  /// [max] - valor máximo (opcional)
  double s(double value, {double? min, double? max}) {
    final scale = _getScaleFactor();
    final scaled = value * scale;
    
    if (min != null && max != null) {
      return scaled.clamp(min, max);
    } else if (min != null) {
      return scaled.clamp(min, double.infinity);
    } else if (max != null) {
      return scaled.clamp(0, max);
    }
    
    return scaled;
  }

  /// Font size escalável (com clamp obrigatório)
  /// [value] - tamanho base em pixels
  /// [min] - tamanho mínimo (padrão baseado no breakpoint)
  /// [max] - tamanho máximo (padrão baseado no breakpoint)
  double fs(double value, {double? min, double? max}) {
    final scale = _getScaleFactor();
    final scaled = value * scale;
    
    // Valores padrão de min/max por breakpoint
    final defaultMin = isXS ? 9.0 : (isSM ? 10.0 : 11.0);
    // Limitar melhor os valores máximos - permitir um pouco mais em telas grandes
    final defaultMax = width > 1200 ? 22.0 : (isTablet ? 28.0 : 22.0);
    
    final finalMin = min ?? defaultMin;
    final finalMax = max ?? defaultMax;
    
    return scaled.clamp(finalMin, finalMax);
  }

  /// Icon size escalável
  /// [value] - tamanho base em pixels
  /// [min] - tamanho mínimo (padrão: 16)
  /// [max] - tamanho máximo (padrão: 48)
  double isz(double value, {double? min, double? max}) {
    final scale = _getScaleFactor();
    final scaled = value * scale;
    
    final finalMin = min ?? 16.0;
    final finalMax = max ?? (isTablet ? 48.0 : 40.0);
    
    return scaled.clamp(finalMin, finalMax);
  }

  /// Radius escalável
  /// [value] - raio base em pixels
  /// [min] - raio mínimo (padrão: 4)
  /// [max] - raio máximo (padrão: 32)
  double r(double value, {double? min, double? max}) {
    final scale = _getScaleFactor();
    final scaled = value * scale;
    
    final finalMin = min ?? 4.0;
    final finalMax = max ?? (isTablet ? 40.0 : 32.0);
    
    return scaled.clamp(finalMin, finalMax);
  }

  /// Height escalável (alturas de componentes)
  /// [value] - altura base em pixels
  /// [min] - altura mínima (opcional)
  /// [max] - altura máxima (opcional)
  double h(double value, {double? min, double? max}) {
    final scale = _getScaleFactor();
    final scaled = value * scale;
    
    if (min != null && max != null) {
      return scaled.clamp(min, max);
    } else if (min != null) {
      return scaled.clamp(min, double.infinity);
    } else if (max != null) {
      return scaled.clamp(0, max);
    }
    
    return scaled;
  }

  // ============================================
  // PADDING E MARGIN
  // ============================================
  
  /// Padding escalável
  EdgeInsets pad({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      final scaled = s(all);
      return EdgeInsets.all(scaled);
    }
    
    return EdgeInsets.only(
      top: s(top ?? vertical ?? 0),
      bottom: s(bottom ?? vertical ?? 0),
      left: s(left ?? horizontal ?? 0),
      right: s(right ?? horizontal ?? 0),
    );
  }

  /// Margin escalável
  EdgeInsets margin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return pad(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  // ============================================
  // TOKENS DE DESIGN
  // ============================================
  
  /// Spacing tokens (base 4px)
  double get spacingXS => s(4);
  double get spacingSM => s(8);
  double get spacingMD => s(12);
  double get spacingLG => s(16);
  double get spacingXL => s(20);
  double get spacingXXL => s(24);
  double get spacingXXXL => s(28);
  double get spacingXXXXL => s(32);

  /// Radius tokens
  double get radiusXS => r(4);
  double get radiusSM => r(8);
  double get radiusMD => r(12);
  double get radiusLG => r(16);
  double get radiusXL => r(20);
  double get radiusXXL => r(24);

  /// Icon size tokens
  double get iconXS => isz(16);
  double get iconSM => isz(20);
  double get iconMD => isz(24);
  double get iconLG => isz(28);
  double get iconXL => isz(32);

  /// Typography tokens (com clamp)
  TextStyle get heading1 => TextStyle(
    fontSize: fs(28),
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  TextStyle get heading2 => TextStyle(
    fontSize: fs(24),
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  TextStyle get heading3 => TextStyle(
    fontSize: fs(18),
    fontWeight: FontWeight.bold,
    letterSpacing: -0.2,
    height: 1.4,
  );
  
  TextStyle get bodyLarge => TextStyle(
    fontSize: fs(16),
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  TextStyle get bodyMedium => TextStyle(
    fontSize: fs(14),
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  TextStyle get bodySmall => TextStyle(
    fontSize: fs(12),
    fontWeight: FontWeight.normal,
    height: 1.3,
  );
  
  TextStyle get caption => TextStyle(
    fontSize: fs(11),
    fontWeight: FontWeight.normal,
    height: 1.2,
  );
  
  TextStyle get label => TextStyle(
    fontSize: fs(12),
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  
  TextStyle get button => TextStyle(
    fontSize: fs(16),
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  TextStyle get link => TextStyle(
    fontSize: fs(14),
    fontWeight: FontWeight.normal,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  /// Component heights
  double get appBarHeight => h(60, min: 50, max: 80);
  double get bottomNavHeight => h(60, min: 50, max: 80);
  double get cardMinHeight => h(80, min: 60, max: 120);
  double get buttonHeight => h(48, min: 40, max: 56);
  double get inputHeight => h(48, min: 40, max: 56);

  // ============================================
  // LAYOUT HELPERS
  // ============================================
  
  /// Largura máxima de conteúdo (para tablets)
  double get maxContentWidth => isTablet ? 720 : 420;
  
  /// Padding horizontal padrão do conteúdo
  EdgeInsets get contentInsets => pad(horizontal: 24);
  
  /// Padding horizontal reduzido (para telas pequenas)
  EdgeInsets get contentInsetsSmall => pad(horizontal: 16);
  
  /// Gap padrão entre elementos
  double get defaultGap => spacingLG;
  
  /// Gap pequeno
  double get gapSmall => spacingMD;
  
  /// Gap grande
  double get gapLarge => spacingXL;
}

/// Enum de breakpoints
enum Breakpoint {
  xs, // < 360
  sm, // 360-399
  md, // 400-479
  lg, // 480-599
  xl, // >= 600
}

/// Extensão para facilitar acesso ao Responsive
extension ResponsiveExtension on BuildContext {
  Responsive get r => Responsive.of(this);
  
  // Atalhos para funções de escala
  double s(double value, {double? min, double? max}) => r.s(value, min: min, max: max);
  double fs(double value, {double? min, double? max}) => r.fs(value, min: min, max: max);
  double isz(double value, {double? min, double? max}) => r.isz(value, min: min, max: max);
  double radius(double value, {double? min, double? max}) => r.r(value, min: min, max: max);
  double h(double value, {double? min, double? max}) => r.h(value, min: min, max: max);
  
  // Atalhos para padding/margin
  EdgeInsets pad({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) => r.pad(
    all: all,
    horizontal: horizontal,
    vertical: vertical,
    top: top,
    bottom: bottom,
    left: left,
    right: right,
  );
  
  EdgeInsets margin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) => r.margin(
    all: all,
    horizontal: horizontal,
    vertical: vertical,
    top: top,
    bottom: bottom,
    left: left,
    right: right,
  );
}
