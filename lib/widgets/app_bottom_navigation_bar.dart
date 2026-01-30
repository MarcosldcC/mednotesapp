import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../services/settings_service.dart';
import '../screens/dashboard_screen.dart';
import '../screens/on_call_mode_screen.dart';
import '../screens/real_time_health_screen.dart';
import '../screens/marketplace_screen.dart';
import '../screens/clinical_algorithms_screen.dart';
import '../design/responsive.dart';

/// Componente reutilizável para o bottom navigation bar
/// Padroniza altura, padding, bordas e estilos em todas as telas
/// 
/// [isWhite] - Se true, o background será branco (para telas com background verde)
///             Se false, o background será verde (padrão)
/// [currentIndex] - Índice do item selecionado (padrão: 2 - Home)
/// [onItemTap] - Callback quando um item é clicado (opcional)
class AppBottomNavigationBar extends StatelessWidget {
  final bool isWhite;
  final int? currentIndex;
  final Function(int)? onItemTap;
  /// Quando true (ex.: tela de simulação do modo plantão), qualquer toque
  /// chama [onItemTap] em vez da navegação padrão, para permitir diálogo de confirmação.
  final bool interceptAllTaps;

  const AppBottomNavigationBar({
    super.key,
    this.isWhite = false,
    this.currentIndex,
    this.onItemTap,
    this.interceptAllTaps = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final r = Responsive.of(context);
    
    // Determina a cor do background
    final backgroundColor = isWhite
        ? Colors.white
        : (settings.highContrast ? Colors.black : AppColors.darkGreenHeader);
    
    // Índice selecionado (padrão: 2 - Home)
    final selectedIndex = currentIndex ?? 2;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(r.r(30, min: 20, max: 40)),
          topRight: Radius.circular(r.r(30, min: 20, max: 40)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              settings.ecoModeEnabled ? 0.05 : 0.1,
            ),
            blurRadius: r.s(
              settings.ecoModeEnabled ? 3 : 4,
              min: 3,
              max: 6,
            ),
            offset: Offset(0, -r.s(settings.ecoModeEnabled ? 1 : 2)),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: r.bottomNavHeight,
          padding: r.pad(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                r,
                'assets/images/Vector.svg',
                0,
                selectedIndex,
                isWhite,
                settings,
              ),
              _buildNavItem(
                context,
                r,
                'assets/images/Vector-1.svg',
                1,
                selectedIndex,
                isWhite,
                settings,
              ),
              _buildNavItem(
                context,
                r,
                'assets/images/Icon.svg',
                2,
                selectedIndex,
                isWhite,
                settings,
              ),
              _buildNavItem(
                context,
                r,
                'assets/images/Vector-2.svg',
                3,
                selectedIndex,
                isWhite,
                settings,
              ),
              _buildNavItem(
                context,
                r,
                'assets/images/Vector-3.svg',
                4,
                selectedIndex,
                isWhite,
                settings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    Responsive r,
    String imagePath,
    int index,
    int selectedIndex,
    bool isWhite,
    SettingsService settings,
  ) {
    final isSelected = selectedIndex == index;
    
    // Cores para background verde
    Color activeColor;
    Color inactiveColor;
    
    if (isWhite) {
      // Background branco
      activeColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
      inactiveColor = settings.highContrast ? Colors.black54 : AppColors.darkGreenHeader;
    } else {
      // Background verde/preto
      activeColor = settings.highContrast
          ? Colors.white
          : const Color(0xFFFBF8EF);
      inactiveColor = settings.highContrast
          ? Colors.white70
          : const Color(0xFFB8E6D0);
    }

    return GestureDetector(
      onTap: () {
        // Modo plantão (simulação): interceptar todos os toques para mostrar "tem certeza que quer sair?"
        if (interceptAllTaps && onItemTap != null) {
          onItemTap!(index);
          return;
        }
        // Navegações padrão
        if (index == 4) {
          // Coração (Vector-3.svg) - Saúde em Tempo Real
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RealTimeHealthScreen(),
            ),
          );
        } else if (index == 3) {
          // Marketplace (Vector-2.svg)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MarketplaceScreen(),
            ),
          );
        } else if (index == 2) {
          // Home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
          );
        } else if (index == 1) {
          // Raio (Vector-1.svg) - Modo Plantão
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OnCallModeScreen(),
            ),
          );
        } else if (index == 0) {
          // Vector.svg - Algoritmos Clínicos / Casos Clínicos
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClinicalAlgorithmsScreen(),
            ),
          );
        }
      },
      child: Container(
        padding: r.pad(all: 8),
        child: SizedBox(
          width: r.isz(24, min: 20, max: 28),
          height: r.isz(24, min: 20, max: 28),
          child: SvgPicture.asset(
            imagePath,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              isSelected ? activeColor : inactiveColor,
              isSelected ? BlendMode.srcATop : BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
