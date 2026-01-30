import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';

/// Card de algoritmo clínico com efeito glass para listagem
class AlgorithmCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeAgo;
  final VoidCallback? onTap;
  final VoidCallback? onInfoTap;

  const AlgorithmCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.onTap,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return SizedBox(
      width: double.infinity,
      child: GlassCard(
        isDarkBackground: false,
        padding: r.pad(all: 16),
        borderRadius: r.radiusMD,
        child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.radiusMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: r.heading3.copyWith(
                          color: AppColors.darkGreenHeader,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: r.spacingXS),
                      Text(
                        subtitle,
                        style: r.bodySmall.copyWith(
                          color: AppColors.grayText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onInfoTap != null)
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: AppColors.darkGreenHeader,
                      size: r.iconMD,
                    ),
                    onPressed: onInfoTap,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: r.iconMD,
                      minHeight: r.iconMD,
                    ),
                  ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.darkGreenHeader,
                  size: r.iconSM,
                ),
              ],
            ),
            SizedBox(height: r.spacingMD),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: r.iconXS,
                  color: AppColors.grayText,
                ),
                SizedBox(width: r.spacingXS),
                Text(
                  timeAgo,
                  style: r.bodySmall.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
