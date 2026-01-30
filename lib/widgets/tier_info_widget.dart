import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/career_level.dart';
import '../constants/colors.dart';
import '../constants/career_theme.dart';
import '../design/responsive.dart';
import '../providers/user_career_provider.dart';

/// Widget reutilizável para exibir informações do tier de carreira (15 níveis, 100 pts/tier).
/// Usa [UserCareerProvider] quando [levelIndex] e [pointsInTier] não são fornecidos.
class TierInfoWidget extends StatelessWidget {
  final int? levelIndex;
  final int? pointsInTier;
  final bool showProgressBar;
  final bool compact;

  TierInfoWidget({
    super.key,
    this.levelIndex,
    this.pointsInTier,
    this.showProgressBar = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final career = context.watch<UserCareerProvider>();
    final level = levelIndex != null ? CareerLevel.at(levelIndex!) : career.currentLevel;
    final points = pointsInTier ?? career.pointsInTier;
    final progress = (points / CareerLevel.pointsPerTier).clamp(0.0, 1.0);
    final themeData = CareerTheme.forLevelIndex(level.levelIndex);
    final primaryColor = themeData.primaryColor;

    if (compact) {
      return _buildCompact(context, r, level, points, primaryColor);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: r.h(36, min: 30, max: 44),
              height: r.h(36, min: 30, max: 44),
              decoration: BoxDecoration(
                color: level.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: r.s(2)),
              ),
              child: Center(
                child: Text(
                  level.tierLabel,
                  style: r.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: r.spacingSM * themeData.spacingMultiplier),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.displayName,
                    style: r.heading3.copyWith(
                      color: AppColors.darkGreenHeader,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: r.spacingXS),
                  Text(
                    '$points / ${CareerLevel.pointsPerTier} pts',
                    style: r.bodySmall.copyWith(color: AppColors.grayText),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showProgressBar && !level.isMaxLevel) ...[
          SizedBox(height: r.spacingMD * themeData.spacingMultiplier),
          Text(
            '${CareerLevel.pointsPerTier - points} pts para o próximo tier',
            style: r.bodySmall.copyWith(color: AppColors.grayText),
          ),
          SizedBox(height: r.spacingLG),
          _buildProgressBar(r, progress, level, points, themeData),
        ],
      ],
    );
  }

  Widget _buildCompact(
    BuildContext context,
    Responsive r,
    CareerLevel level,
    int points,
    Color primaryColor,
  ) {
    return Row(
      children: [
        Container(
          width: r.h(28, min: 24, max: 32),
          height: r.h(28, min: 24, max: 32),
          decoration: BoxDecoration(
            color: level.color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.darkGreenHeader, width: r.s(1.5)),
          ),
          child: Center(
            child: Text(
              level.tierLabel,
              style: r.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: r.spacingSM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              level.displayName,
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$points pts',
              style: r.bodySmall.copyWith(color: AppColors.grayText),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    Responsive r,
    double progress,
    CareerLevel level,
    int points,
    CareerThemeData themeData,
  ) {
    final height = r.h(32, min: 28, max: 36);
    final borderRadius = height / 2;
    final nextLevel = level.isMaxLevel ? null : CareerLevel.at(level.levelIndex + 1);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: themeData.animationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: AppColors.darkGreenHeader.withOpacity(0.3),
                  width: r.s(1),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: level.color,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Center(
                  child: Text(
                    '$points/${CareerLevel.pointsPerTier}',
                    style: r.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: height,
                height: height,
                decoration: BoxDecoration(
                  color: level.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: r.s(1)),
                ),
                child: Center(
                  child: Text(
                    level.tierLabel,
                    style: r.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: height,
                height: height,
                decoration: BoxDecoration(
                  color: (nextLevel ?? level).color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: r.s(1)),
                ),
                child: Center(
                  child: Text(
                    nextLevel == null ? 'MAX' : nextLevel.tierLabel,
                    style: r.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
