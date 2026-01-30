import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../models/rank_entry.dart';
import 'glass_card.dart';

/// Card de uma linha do ranking por tier: posição, avatar, nome, pontuação 0–100, barra de progresso.
/// Glassmorphism, borda sutil animada (pulse) para Top 3.
class RankingEntryCard extends StatefulWidget {
  final RankEntry entry;
  final Color accentColor;
  final bool useGlass;
  final bool pulseBorder;

  const RankingEntryCard({
    super.key,
    required this.entry,
    required this.accentColor,
    this.useGlass = true,
    this.pulseBorder = false,
  });

  @override
  State<RankingEntryCard> createState() => _RankingEntryCardState();
}

class _RankingEntryCardState extends State<RankingEntryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final entry = widget.entry;
    final points = entry.points ?? entry.exp.clamp(0, 100);
    final progress = (points / 100).clamp(0.0, 1.0);
    final isUser = entry.isUser;
    final isTop3 = entry.rank <= 3;

    Widget cardContent = Padding(
      padding: r.pad(all: 14),
      child: Row(
        children: [
          Text(
            '#${entry.rank}',
            style: r.heading3.copyWith(
              color: isUser ? Colors.white : widget.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: r.spacingSM),
          _buildAvatar(r, isUser),
          SizedBox(width: r.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.name,
                  style: r.bodyMedium.copyWith(
                    color: isUser ? Colors.white : AppColors.darkGreenHeader,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: r.spacingXS),
                Text(
                  '$points / 100 pts',
                  style: r.bodySmall.copyWith(
                    color: isUser ? Colors.white70 : AppColors.grayText,
                  ),
                ),
                SizedBox(height: r.spacingXS),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: (isUser ? Colors.white : Colors.grey[300])!.withOpacity(0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isUser ? Colors.white : widget.accentColor,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.useGlass && !isUser) {
      cardContent = GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: r.radiusMD,
        useGlass: widget.useGlass,
        child: cardContent,
      );
    }

    Widget container = Container(
      decoration: BoxDecoration(
        color: isUser ? widget.accentColor : null,
        borderRadius: BorderRadius.circular(r.radiusMD),
        border: isUser
            ? null
            : (widget.pulseBorder && isTop3
                ? null
                : Border.all(
                    color: widget.accentColor.withOpacity(0.3),
                    width: r.s(1),
                  )),
        boxShadow: [
          if (isUser)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: r.s(10, min: 6, max: 14),
              offset: Offset(0, r.s(4, min: 2, max: 6)),
            ),
        ],
      ),
      child: widget.useGlass && !isUser && widget.pulseBorder && isTop3
          ? AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(r.radiusMD),
                    border: Border.all(
                      color: widget.accentColor.withOpacity(_pulseAnimation.value),
                      width: r.s(1.5),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(r.radiusMD),
                    child: child,
                  ),
                );
              },
              child: cardContent,
            )
          : cardContent,
    );

    return container;
  }

  Widget _buildAvatar(Responsive r, bool isUser) {
    final color = isUser ? Colors.white : widget.accentColor;
    return Container(
      width: r.h(44, min: 40, max: 50),
      height: r.h(44, min: 40, max: 50),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: r.s(2)),
        color: isUser ? color.withOpacity(0.2) : Colors.white,
      ),
      child: Icon(
        Icons.person,
        color: color,
        size: r.iconMD,
      ),
    );
  }
}
