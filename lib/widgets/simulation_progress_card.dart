import 'package:flutter/material.dart';
import '../widgets/tier_info_widget.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';

/// Widget reutilizável para exibir informações de progresso nas telas de simulação.
/// Usa [TierInfoWidget] com dados do [UserCareerProvider].
class SimulationProgressCard extends StatelessWidget {
  final int lives;
  /// Pontos a ganhar ao concluir (ex.: 10 pts)
  final int pointsReward;

  SimulationProgressCard({
    super.key,
    required this.lives,
    this.pointsReward = 10,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Container(
      width: double.infinity,
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(r.radiusMD),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 380;
          if (isSmallScreen) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: r.margin(right: r.spacingXS),
                        child: Icon(
                          index < lives
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.red,
                          size: r.iconMD,
                        ),
                      ),
                    ),
                    SizedBox(width: r.spacingSM),
                    Text(
                      'Vidas: $lives',
                      style: r.bodyMedium.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.spacingMD),
                Row(
                  children: [
                    TierInfoWidget(
                      showProgressBar: false,
                      compact: true,
                    ),
                    const Spacer(),
                    Text(
                      '+$pointsReward pts',
                      style: r.bodySmall.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    3,
                    (index) => Padding(
                      padding: r.margin(right: r.spacingXS),
                      child: Icon(
                        index < lives
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.red,
                        size: r.iconMD,
                      ),
                    ),
                  ),
                  SizedBox(width: r.spacingSM),
                  Text(
                    'Vidas: $lives',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(width: r.spacingLG),
              Container(
                width: 1,
                height: r.isz(28),
                color: AppColors.darkGreenHeader.withValues(alpha: 0.25),
              ),
              SizedBox(width: r.spacingLG),
              Expanded(
                child: TierInfoWidget(
                  showProgressBar: false,
                  compact: true,
                ),
              ),
              Container(
                width: 1,
                height: r.isz(28),
                color: AppColors.darkGreenHeader.withValues(alpha: 0.25),
              ),
              SizedBox(width: r.spacingLG),
              Text(
                '+$pointsReward pts\nao concluir',
                textAlign: TextAlign.center,
                style: r.bodySmall.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
