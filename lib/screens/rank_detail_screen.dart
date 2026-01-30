import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../models/career_level.dart';
import '../models/rank_entry.dart';
export '../models/rank_entry.dart';
import '../constants/career_theme.dart';
import '../services/settings_service.dart';
import '../widgets/app_header.dart';
import '../widgets/ranking_entry_card.dart';

/// Tela de detalhe do ranking. Suporta ranking por tier (levelIndex + pontos 0–100)
/// ou legado (title/subtitle + exp).
class RankDetailScreen extends StatelessWidget {
  const RankDetailScreen({
    super.key,
    this.title,
    this.subtitle,
    required this.userName,
    this.userExp,
    this.userPoints,
    required this.userRank,
    required this.entries,
    this.levelIndex,
  });

  final String? title;
  final String? subtitle;
  final String userName;
  final int? userExp;
  final int? userPoints;
  final int userRank;
  final List<RankEntry> entries;
  final int? levelIndex;

  /// Construtor para ranking por tier: "Ranking — Residente II"
  factory RankDetailScreen.byTier({
    required int levelIndex,
    required String userName,
    required int userPoints,
    required int userRank,
    required List<RankEntry> entries,
  }) {
    return RankDetailScreen(
      levelIndex: levelIndex,
      userName: userName,
      userPoints: userPoints,
      userRank: userRank,
      entries: entries,
    );
  }

  bool get _isTierRanking => levelIndex != null;

  String get _effectiveTitle {
    if (_isTierRanking) {
      return 'Ranking — ${CareerLevel.at(levelIndex!).displayName}';
    }
    return title ?? 'Ranking';
  }

  String get _effectiveSubtitle {
    if (_isTierRanking) {
      return 'Classificação no seu tier atual';
    }
    return subtitle ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    final primaryColor =
        settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
    final level = _isTierRanking ? CareerLevel.at(levelIndex!) : null;
    final themeData = level != null ? CareerTheme.forLevelIndex(level.levelIndex) : null;
    final accentColor = level?.color ?? primaryColor;

    return Scaffold(
      backgroundColor: AppColors.creamCard,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: primaryColor,
                            size: r.iconMD,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: r.iconMD,
                            minHeight: r.iconMD,
                          ),
                        ),
                        SizedBox(width: r.spacingSM),
                        Expanded(
                          child: Text(
                            _effectiveTitle,
                            style: r.heading2.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_effectiveSubtitle.isNotEmpty) ...[
                      SizedBox(height: r.spacingSM),
                      Text(
                        _effectiveSubtitle,
                        style: r.bodyMedium.copyWith(
                          color: settings.highContrast
                              ? Colors.black
                              : AppColors.grayText,
                        ),
                      ),
                    ],
                    SizedBox(height: r.spacingLG),
                    _buildUserRankCard(
                      context,
                      r,
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                    ),
                    SizedBox(height: r.spacingLG),
                    Text(
                      'Ranking',
                      style: r.heading3.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    ...entries.map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(bottom: r.spacingSM),
                        child: RankingEntryCard(
                          entry: entry,
                          accentColor: accentColor,
                          useGlass: true,
                          pulseBorder: entry.rank <= 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRankCard(
    BuildContext context,
    Responsive r, {
    required Color primaryColor,
    required Color accentColor,
  }) {
    final points = _isTierRanking ? (userPoints ?? 0) : (userExp ?? 0);
    final displayValue = _isTierRanking ? '$points / 100 pts' : 'Experiência: $points';
    final ecoMode = Provider.of<SettingsService>(context).ecoModeEnabled;

    return Container(
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(r.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(ecoMode ? 0.06 : 0.12),
            blurRadius: r.s(ecoMode ? 8 : 12, min: 8, max: 16),
            offset: Offset(0, r.s(ecoMode ? 3 : 6, min: 3, max: 8)),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(r, primaryColor: Colors.white),
          SizedBox(width: r.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: r.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: r.spacingXS),
                Text(
                  displayValue,
                  style: r.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
                if (_isTierRanking && levelIndex != null)
                  Padding(
                    padding: EdgeInsets.only(top: r.spacingXS),
                    child: Container(
                      padding: r.pad(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(r.radiusSM),
                      ),
                      child: Text(
                        CareerLevel.at(levelIndex!).displayName,
                        style: r.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '#$userRank',
            style: r.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
    Responsive r, {
    required Color primaryColor,
  }) {
    return Container(
      width: r.h(44, min: 40, max: 50),
      height: r.h(44, min: 40, max: 50),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: r.s(2)),
        color: Colors.white,
      ),
      child: Icon(
        Icons.person,
        color: primaryColor,
        size: r.iconMD,
      ),
    );
  }
}
