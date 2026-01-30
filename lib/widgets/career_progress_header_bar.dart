import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/career_level.dart';
import '../constants/colors.dart';
import '../constants/career_theme.dart';
import '../design/responsive.dart';
import '../providers/user_career_provider.dart';

/// Barra de progresso principal da carreira: categoria + tier, barra 0–100 pts, ranking no tier.
/// Usa [UserCareerProvider]. [rankInTier] opcional; se null, exibe "—".
class CareerProgressHeaderBar extends StatelessWidget {
  final int? rankInTier;
  final bool compact;

  const CareerProgressHeaderBar({
    super.key,
    this.rankInTier,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final career = context.watch<UserCareerProvider>();
    final level = career.currentLevel;
    final points = career.pointsInTier;
    final progress = career.progressToNextTier;
    final themeData = CareerTheme.forLevelIndex(level.levelIndex);
    final rank = rankInTier ?? career.rankInTier;

    if (compact) {
      return _buildCompact(context, r, level, points, progress, rank, themeData);
    }

    return Container(
      width: double.infinity,
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: level.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(r.radiusMD),
        border: Border.all(
          color: level.color.withOpacity(0.35),
          width: r.s(1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                level.displayName,
                style: r.heading3.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (rank != null)
                Text(
                  'Ranking atual: #$rank',
                  style: r.bodySmall.copyWith(color: AppColors.grayText),
                )
              else
                Text(
                  'Ranking atual: —',
                  style: r.bodySmall.copyWith(color: AppColors.grayText),
                ),
            ],
          ),
          SizedBox(height: r.spacingSM),
          Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
                  duration: themeData.animationDuration,
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(r.h(24, min: 20, max: 28) / 2),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(level.color),
                        minHeight: r.h(10, min: 8, max: 14),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: r.spacingSM),
              Text(
                '$points / ${CareerLevel.pointsPerTier} pts',
                style: r.bodySmall.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(
    BuildContext context,
    Responsive r,
    CareerLevel level,
    int points,
    double progress,
    int? rank,
    CareerThemeData themeData,
  ) {
    return Row(
      children: [
        Container(
          padding: r.pad(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: level.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(r.radiusSM),
          ),
          child: Text(
            level.displayName,
            style: r.bodySmall.copyWith(
              color: level.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: r.spacingSM),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
            duration: themeData.animationDuration,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(level.color),
                  minHeight: 6,
                ),
              );
            },
          ),
        ),
        SizedBox(width: r.spacingXS),
        Text(
          '$points/100',
          style: r.bodySmall.copyWith(
            color: AppColors.grayText,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (rank != null) ...[
          SizedBox(width: r.spacingSM),
          Text(
            '#$rank',
            style: r.bodySmall.copyWith(
              color: AppColors.grayText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
