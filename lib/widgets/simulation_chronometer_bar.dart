import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../providers/simulation_state_provider.dart';

/// Barra de cronômetro da simulação de caso (tempo decorrido + Sair).
/// Estilo adaptado ao tema verde da simulação (não modo plantão).
/// [onSairTap] deve mostrar o diálogo de confirmação e, se confirmado, chamar
/// [SimulationStateProvider.endSimulation] e navegar para a tela de seleção de casos.
class SimulationChronometerBar extends StatelessWidget {
  final VoidCallback onSairTap;

  const SimulationChronometerBar({
    super.key,
    required this.onSairTap,
  });

  static String formatElapsed(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final simState = context.watch<SimulationStateProvider>();
    final timeStr = formatElapsed(simState.elapsedSeconds);

    return Container(
      padding: r.pad(all: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(r.radiusMD),
        border: Border.all(
          color: AppColors.darkGreenHeader.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: r.h(44, min: 40, max: 52),
            height: r.h(44, min: 40, max: 52),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.radiusSM),
            ),
            child: Icon(
              Icons.timer_outlined,
              color: AppColors.darkGreenHeader,
              size: r.iconMD,
            ),
          ),
          SizedBox(width: r.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tempo',
                  style: r.bodySmall.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
                Text(
                  timeStr,
                  style: r.heading3.copyWith(
                    color: AppColors.darkGreenHeader,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSairTap,
            child: Text(
              'Sair',
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
