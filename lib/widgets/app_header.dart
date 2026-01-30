import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/settings_service.dart';
import '../screens/notifications_screen.dart';
import '../design/responsive.dart';
import '../providers/simulation_state_provider.dart';

/// Componente reutilizável para o header superior das telas
/// Padroniza altura, padding, bordas e estilos em todas as telas
/// 
/// [isWhite] - Se true, o header será branco (para telas com background verde)
///             Se false, o header será verde (padrão)
class AppHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final bool showNotifications;
  final bool isWhite;

  const AppHeader({
    super.key,
    this.onNotificationTap,
    this.showNotifications = true,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final r = Responsive.of(context);
    
    // Determina as cores baseado na variante
    final headerColor = isWhite
        ? Colors.white
        : (settings.highContrast ? Colors.black : AppColors.darkGreenHeader);
    
    final textColor = isWhite
        ? (settings.highContrast ? Colors.black : AppColors.darkGreenHeader)
        : Colors.white;
    
    final iconColor = isWhite
        ? (settings.highContrast ? Colors.black : AppColors.darkGreenHeader)
        : Colors.white;
    
    final avatarBackgroundColor = isWhite
        ? (settings.highContrast ? Colors.black : AppColors.darkGreenHeader)
        : Colors.white;

    final avatarRadius = r.h(20, min: 18, max: 22); // Usar h() para tamanhos de componentes
    final avatarSize = avatarRadius * 2;

    return Container(
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(r.r(30, min: 20, max: 40)),
          bottomRight: Radius.circular(r.r(30, min: 20, max: 40)),
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
            offset: Offset(0, r.s(settings.ecoModeEnabled ? 1 : 2)),
          ),
        ],
      ),
      padding: r.pad(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Avatar clicável (menu lateral - indisponível durante simulação de caso)
          Builder(
            builder: (context) {
              final simState = context.watch<SimulationStateProvider>();
              final inSimulation = simState.simulationInProgress;
              return GestureDetector(
                onTap: () {
                  if (inSimulation) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Indisponível enquanto simula caso clínico.',
                          style: r.bodyMedium.copyWith(color: Colors.white),
                        ),
                        backgroundColor: AppColors.darkGreenHeader,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  Scaffold.of(context).openDrawer();
                },
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: avatarBackgroundColor,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/medica.png',
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isWhite ? AppColors.mediumGreen : AppColors.mediumGreen,
                        child: Icon(
                          Icons.person,
                          size: r.isz(20, min: 18, max: 24),
                          color: isWhite ? Colors.white : Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
            },
          ),
          SizedBox(width: r.spacingLG),
          // Logo mednotes
          Expanded(
            child: Text(
              'mednotes',
              style: r.bodyLarge.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Ícone de notificação (indisponível durante simulação de caso)
          if (showNotifications)
            Builder(
              builder: (context) {
                final simState = context.watch<SimulationStateProvider>();
                final inSimulation = simState.simulationInProgress;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(r.r(24)),
                    onTap: () {
                      if (inSimulation) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Indisponível enquanto simula caso clínico.',
                              style: r.bodyMedium.copyWith(color: Colors.white),
                            ),
                            backgroundColor: AppColors.darkGreenHeader,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      if (onNotificationTap != null) {
                        onNotificationTap!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      }
                    },
                child: Container(
                  padding: r.pad(all: 8),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: iconColor,
                    size: r.isz(28, min: 24, max: 32),
                  ),
                ),
              ),
            );
              },
            )
          else
            SizedBox(width: r.isz(48, min: 40, max: 56)), // Espaço para manter alinhamento quando não há notificação
        ],
      ),
    );
  }
}
