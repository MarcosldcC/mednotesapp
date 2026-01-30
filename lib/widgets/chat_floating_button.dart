import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../providers/simulation_state_provider.dart';
import '../screens/chat_screen.dart';
import '../services/settings_service.dart';

/// Componente reutilizável para o botão flutuante de chat
/// Usa o ícone robot.svg com background redondo
class ChatFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ChatFloatingButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final r = Responsive.of(context);
    
    return GestureDetector(
      onTap: onPressed ?? () {
        final simState = context.read<SimulationStateProvider>();
        if (simState.simulationInProgress) {
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      },
      child: Container(
        width: r.isz(56, min: 50, max: 64),
        height: r.isz(56, min: 50, max: 64),
        decoration: BoxDecoration(
          color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: r.s(8, min: 6, max: 10),
              offset: Offset(0, r.s(4, min: 3, max: 5)),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/robot.svg',
            width: r.isz(28, min: 24, max: 32),
            height: r.isz(28, min: 24, max: 32),
            fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
