import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../constants/colors.dart';
import '../models/career_level.dart';
import '../models/rank_entry.dart';
import '../providers/user_career_provider.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/rank_detail_screen.dart';
import '../services/settings_service.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../design/responsive.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  final PageController _achievementsPageController = PageController();
  final PageController _detailsPageController = PageController();
  int _achievementsCurrentPage = 0;
  int _detailsCurrentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    
    _achievementsPageController.addListener(() {
      setState(() {
        _achievementsCurrentPage = _achievementsPageController.page?.round() ?? 0;
      });
    });
    
    _detailsPageController.addListener(() {
      setState(() {
        _detailsCurrentPage = _detailsPageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _achievementsPageController.dispose();
    _detailsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: _primaryColor(context),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Consumer<UserCareerProvider>(
      builder: (context, career, _) {
        final progress = career.progressToNextTier;
        return Scaffold(
          backgroundColor: AppColors.creamCard,
          drawer: const ProfileMenuScreen(),
          drawerEnableOpenDragGesture: true,
          body: SafeArea(
            child: Column(
              children: [
                const AppHeader(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: r.pad(top: 24, bottom: 0, left: 24, right: 24),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: _primaryColor(context),
                                          size: r.isz(24),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(
                                          minWidth: r.isz(40),
                                          minHeight: r.isz(40),
                                        ),
                                      ),
                                      SizedBox(width: r.spacingSM),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ver Progresso',
                                              style: r.heading1.copyWith(
                                                color: _primaryColor(context),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: r.spacingXS),
                                            Text(
                                              'Veja o andamento do seu progresso:',
                                              style: r.bodyMedium.copyWith(
                                                color: _primaryColor(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildProgressCardWithTabs(progress, r, constraints.maxHeight, career),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
          floatingActionButton: const ChatFloatingButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildProgressCardWithTabs(double progress, Responsive r, double availableHeight, UserCareerProvider career) {
    return Builder(
      builder: (context) {
        final currentLevel = career.currentLevel;
        final nextLevel = career.isMaxLevel ? null : CareerLevel.at(career.levelIndex + 1);
        final pointsInTier = career.pointsInTier;
        final pointsToNext = career.pointsToNextTier;
        final ecoMode = Provider.of<SettingsService>(context).ecoModeEnabled;

        // Usa altura disponível recebida como parâmetro
        
        // Tamanhos responsivos usando tokens (valores mais conservadores)
        final isSmallScreen = r.isXS || r.isSM;
        final isShortScreen = r.height <= 640;
        final extraCardTop = isSmallScreen ? r.h(28, min: 22, max: 34) : 0.0;
        final avatarSize = r.h(120, min: 100, max: 130);
        final avatarTop = -r.h(52, min: 44, max: 58) + extraCardTop;
        final cardRadius = r.radiusXXL;
        
        final progressBarH = r.h(32, min: 28, max: 36);
        final metricIcon = r.iconMD;
        final metricHeight = isShortScreen
            ? r.h(86, min: 80, max: 96)
            : r.h(70, min: 65, max: 85);
        
        final trophySize = isShortScreen
            ? r.h(90, min: 70, max: 100)
            : r.h(120, min: 100, max: 130);
        final trophyIcon = isShortScreen
            ? r.isz(44, min: 36, max: 54)
            : r.isz(60, min: 50, max: 70);
        
        // Altura mínima/máxima para área de abas (mais conservador)
        final minTabsH = isShortScreen
            ? r.h(60, min: 55, max: 75)
            : r.h(120, min: 110, max: 130);
        final maxTabsH = isShortScreen
            ? r.h(170, min: 150, max: 190)
            : r.h(260, min: 220, max: 280);
        final tabsHeightFactor = isShortScreen ? 0.24 : 0.4;
        final tabsTopGap = isShortScreen ? r.spacingXS : r.spacingMD;
        final tabsHeight = (availableHeight * tabsHeightFactor).clamp(minTabsH, maxTabsH);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: r.margin(horizontal: 24, top: extraCardTop),
              decoration: BoxDecoration(
                color: _primaryColor(context),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(cardRadius),
                  topRight: Radius.circular(cardRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(ecoMode ? 0.04 : 0.08),
                    blurRadius: r.s(ecoMode ? 8 : 12, min: 8, max: 16),
                    offset: Offset(0, r.s(ecoMode ? 3 : 6, min: 3, max: 8)),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Parte superior do card (nível, progresso, métricas)
                  Padding(
                    padding: r.pad(
                      horizontal: 20,
                      top: r.h(72, min: 62, max: 82) + (isSmallScreen ? r.spacingSM : 0),
                      bottom: r.spacingLG,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tier e pontos
                        Row(
                          children: [
                            Container(
                              width: r.h(36, min: 30, max: 44),
                              height: r.h(36, min: 30, max: 44),
                              decoration: BoxDecoration(
                                color: currentLevel.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: r.s(2),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  currentLevel.tierLabel,
                                  style: r.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: r.spacingSM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentLevel.displayName,
                                    style: r.heading3.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: r.spacingXS),
                                  Text(
                                    '$pointsInTier / ${CareerLevel.pointsPerTier} pts',
                                    style: r.bodySmall.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: r.spacingMD),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            nextLevel == null
                                ? 'Tier máximo alcançado'
                                : '$pointsToNext pts para ${nextLevel.displayName}',
                            style: r.bodySmall.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),

                        SizedBox(height: r.spacingLG),

                        _buildProgressBar(
                          progress,
                          r,
                          progressBarH,
                          currentLevel: currentLevel,
                          nextLevel: nextLevel,
                          pointsInTier: pointsInTier,
                          career: career,
                        ),

                        SizedBox(height: r.spacingLG),

                        _buildMetrics(r, metricHeight, metricIcon, career),

                        SizedBox(height: isShortScreen ? r.spacingMD : r.spacingXXL),

                        _buildTabs(r),
                        SizedBox(height: tabsTopGap),
                      ],
                    ),
                  ),

                  // Área de abas com altura responsiva
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minTabsH,
                      maxHeight: maxTabsH,
                    ),
                    child: ClipRect(
                      child: SizedBox(
                        height: tabsHeight,
                        child: _buildTabContent(
                          r: r,
                          trophySize: trophySize,
                          trophyIcon: trophyIcon,
                          career: career,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: r.spacingSM),
                ],
              ),
            ),

            // Avatar responsivo posicionado acima do card
            Positioned(
              top: avatarTop,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _primaryColor(context),
                      width: r.s(4, min: 3, max: 5),
                    ),
                    color: AppColors.creamCard,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/medica.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: r.isz(60, min: 40, max: 80),
                          color: _primaryColor(context),
                        );
                      },
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

  Widget _buildProgressBar(
    double progress,
    Responsive r,
    double height, {
    required CareerLevel currentLevel,
    required CareerLevel? nextLevel,
    required int pointsInTier,
    required UserCareerProvider career,
  }) {
    final badgeSize = height;
    final borderRadius = height / 2;

    return Stack(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: _primaryColor(context),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: r.s(1),
            ),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0,
            end: progress.clamp(0.0, 1.0),
          ),
          duration: Provider.of<SettingsService>(context).ecoModeEnabled
              ? Duration.zero
              : const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return FractionallySizedBox(
              widthFactor: value,
              child: child,
            );
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: currentLevel.color,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Center(
              child: Text(
                '$pointsInTier/${CareerLevel.pointsPerTier}',
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
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: currentLevel.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: r.s(1)),
            ),
            child: Center(
              child: Text(
                currentLevel.tierLabel,
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
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: (nextLevel ?? currentLevel).color,
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
  }

  Widget _buildMetrics(Responsive r, double height, double iconSize, UserCareerProvider career) {
    final rankStr = career.rankInTier != null ? '#${career.rankInTier}' : '—';
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: _buildMetricItem(
              r,
              Icons.star_outline,
              'PONTOS',
              '${career.pointsInTier}/100',
              iconSize,
            ),
          ),
          Container(
            width: r.s(1),
            height: height,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildMetricItem(
              r,
              Icons.leaderboard,
              'RANKING',
              rankStr,
              iconSize,
              onTap: () {
                final entries = _buildTierRankEntries(career);
                final userRank = entries.indexWhere((e) => e.isUser) + 1;
                if (userRank > 0) career.setRankInTier(userRank);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RankDetailScreen.byTier(
                      levelIndex: career.levelIndex,
                      userName: AppConstants.kDisplayName,
                      userPoints: career.pointsInTier,
                      userRank: userRank,
                      entries: entries,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    Responsive r,
    IconData icon,
    String label,
    String value,
    double iconSize,
    {VoidCallback? onTap}
  ) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(icon, color: Colors.white, size: iconSize),
        SizedBox(height: r.spacingSM),
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: r.bodySmall.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        SizedBox(height: r.spacingXS),
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: r.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(r.radiusMD),
        onTap: onTap,
        child: content,
      ),
    );
  }

  Widget _buildTabs(Responsive r) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _tabController.animateTo(0);
            },
            child: Column(
              children: [
                Text(
                  'Conquistas',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: r.spacingXS),
                AnimatedContainer(
                  duration: Provider.of<SettingsService>(context).ecoModeEnabled
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: r.s(_selectedTab == 0 ? 10 : 6, min: 6, max: 12),
                  height: r.s(_selectedTab == 0 ? 10 : 6, min: 6, max: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0 ? Colors.white : Colors.white24,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _tabController.animateTo(1);
            },
            child: Column(
              children: [
                Text(
                  'Detalhes',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: r.spacingXS),
                AnimatedContainer(
                  duration: Provider.of<SettingsService>(context).ecoModeEnabled
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: r.s(_selectedTab == 1 ? 10 : 6, min: 6, max: 12),
                  height: r.s(_selectedTab == 1 ? 10 : 6, min: 6, max: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1 ? Colors.white : Colors.white24,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTabContent({
    required Responsive r,
    required double trophySize,
    required double trophyIcon,
    required UserCareerProvider career,
  }) {
    return IndexedStack(
      index: _selectedTab,
      children: [
        _buildAchievementsTab(r, trophySize, trophyIcon, career),
        _buildDetailsTab(r),
      ],
    );
  }

  Widget _buildAchievementsTab(Responsive r, double trophySize, double trophyIcon, UserCareerProvider career) {
    final isShortScreen = r.height <= 640;
    final achievements = _buildTierAchievements(career);
    final ecoMode = Provider.of<SettingsService>(context).ecoModeEnabled;

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _achievementsPageController,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: r.pad(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxTrophy = isShortScreen
                        ? constraints.maxHeight * 0.45
                        : trophySize;
                    final trophy =
                        trophySize.clamp(0.0, maxTrophy).toDouble();
                    final icon =
                        trophyIcon.clamp(0.0, trophy * 0.6).toDouble();
                    final tierColor = CareerLevel.allLevels[index].color;

                    return Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: r.pad(
                          top: isShortScreen ? 0 : r.spacingSM,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: trophy,
                              height: trophy,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: tierColor,
                                  width: r.s(1),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: tierColor.withOpacity(ecoMode ? 0.15 : 0.25),
                                    blurRadius: r.s(ecoMode ? 8 : 10, min: 6, max: 14),
                                    offset: Offset(0, r.s(ecoMode ? 3 : 4, min: 2, max: 6)),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.emoji_events,
                                color: tierColor,
                                size: icon,
                              ),
                            ),
                            SizedBox(
                              height: isShortScreen ? r.s(2) : r.spacingMD,
                            ),
                            Text(
                              achievements[index],
                              style: (isShortScreen ? r.bodySmall : r.bodyMedium).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: isShortScreen ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: isShortScreen ? r.spacingXS : r.spacingSM),
        _buildPageIndicator(r, achievements.length, _achievementsCurrentPage),
      ],
    );
  }


  Widget _buildPageIndicator(Responsive r, int totalPages, int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return Container(
          margin: r.margin(horizontal: 4),
          width: r.s(isActive ? 24 : 8, min: 6, max: 28),
          height: r.s(8, min: 6, max: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(r.r(4)),
          ),
        );
      }),
    );
  }


  List<Widget> _getDetailsItems(BuildContext context, Responsive r) {
    return [
      // Página 1: Emergências
      Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        padding: r.pad(all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Lacunas Identificadas pelo Dr. Axon',
                    style: r.heading3.copyWith(
                      color: _primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: _primaryColor(context),
                    size: r.iconMD,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: r.iconMD,
                    minHeight: r.iconMD,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingMD),
            _buildGapItem(
              context: context,
              r: r,
              icon: Icons.warning_amber_rounded,
              title: 'Emergências',
              description: 'Baixa exposição a cenários de tempo crítico com poucas decisões sob pressão',
            ),
          ],
        ),
      ),
      // Página 2: Neurologia
      Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        padding: r.pad(all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Lacunas Identificadas pelo Dr. Axon',
                    style: r.heading3.copyWith(
                      color: _primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: _primaryColor(context),
                    size: r.iconMD,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: r.iconMD,
                    minHeight: r.iconMD,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingMD),
            _buildGapItem(
              context: context,
              r: r,
              icon: Icons.warning_amber_rounded,
              title: 'Neurologia',
              description: 'Baixa exposição a cenários de tempo crítico com poucas decisões sob pressão',
            ),
          ],
        ),
      ),
      // Página 3: Cardiologia
      Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        padding: r.pad(all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Lacunas Identificadas pelo Dr. Axon',
                    style: r.heading3.copyWith(
                      color: _primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: _primaryColor(context),
                    size: r.iconMD,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: r.iconMD,
                    minHeight: r.iconMD,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingMD),
            _buildGapItem(
              context: context,
              r: r,
              icon: Icons.warning_amber_rounded,
              title: 'Cardiologia',
              description: 'Baixa exposição a cenários de tempo crítico com poucas decisões sob pressão',
            ),
          ],
        ),
      ),
      // Página 4: Perfil Clínico Atual
      Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        padding: r.pad(all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Dr. Axon - Perfil Clínico Atual',
                    style: r.heading3.copyWith(
                      color: _primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: _primaryColor(context),
                    size: r.iconMD,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: r.iconMD,
                    minHeight: r.iconMD,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingMD),
            Text(
              'Você tem maior domínio em Abordagem da Torácica, mas apresenta menor exposição a abordagens neurológicas e casos de urgência cardiovascular.',
              style: r.bodyMedium.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ],
        ),
      ),
      // Página 5: Foco sugerido para evolução
      Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        padding: r.pad(all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Dr. Axon - Foco sugerido para evolução',
                    style: r.heading3.copyWith(
                      color: _primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: _primaryColor(context),
                    size: r.iconMD,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: r.iconMD,
                    minHeight: r.iconMD,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingMD),
            Text(
              'Priorize Abordagem da Torácica - nível intermediário e casos de dor torácica aguda, pois eles têm alto impacto em plantões e provas práticas.',
              style: r.bodyMedium.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildDetailsTab(Responsive r) {
    final isShortScreen = r.height <= 640;
    final detailsItems = _getDetailsItems(context, r);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: PageView.builder(
            controller: _detailsPageController,
            itemCount: detailsItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: r.pad(left: 20, right: 20, top: 10, bottom: 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: detailsItems[index],
                  ),
                ),
              );
            },
          ),
        ),
          SizedBox(height: isShortScreen ? r.spacingXS : r.spacingSM),
        _buildPageIndicator(r, detailsItems.length, _detailsCurrentPage),
      ],
    );
  }

  Widget _buildGapItem({
    required BuildContext context,
    required Responsive r,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: r.h(48, min: 40, max: 56),
          height: r.h(48, min: 40, max: 56),
          decoration: BoxDecoration(
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(r.radiusSM),
          ),
          child: Icon(
            icon,
          color: _primaryColor(context),
            size: r.iconMD,
          ),
        ),
        SizedBox(width: r.spacingLG),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: r.heading3.copyWith(
                color: _primaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: r.spacingXS),
              Text(
                description,
                style: r.bodySmall.copyWith(
                  color: AppColors.grayText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _primaryColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    return settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
  }

  List<String> _buildTierAchievements(UserCareerProvider career) {
    final currentIndex = career.levelIndex;
    if (currentIndex < 0) return const [];
    return CareerLevel.allLevels
        .take(currentIndex + 1)
        .map((level) => '${level.displayName} conquistado')
        .toList();
  }

  List<RankEntry> _buildTierRankEntries(UserCareerProvider career) {
    final userPoints = career.pointsInTier;
    final raw = [
      (name: 'Fernanda Souza', points: 98),
      (name: 'Lucas Martins', points: 95),
      (name: 'Camila Rocha', points: 91),
      (name: 'Bruno Lima', points: 88),
      (name: 'Marina Alves', points: 85),
      (name: 'Paula Mendes', points: 82),
      (name: 'Henrique Melo', points: 78),
      (name: 'Isabela Cunha', points: 75),
      (name: 'Renato Dias', points: 72),
      (name: 'Juliana Prado', points: 68),
      (name: 'Ricardo Costa', points: 65),
      (name: 'Ana Ferreira', points: 62),
      (name: 'Pedro Santos', points: 60),
      (name: AppConstants.kDisplayName, points: userPoints),
      (name: 'Carla Lima', points: 55),
    ];
    raw.sort((a, b) => b.points.compareTo(a.points));
    return List.generate(raw.length, (i) {
      final e = raw[i];
      return RankEntry(
        name: e.name,
        exp: e.points,
        rank: i + 1,
        points: e.points,
        isUser: e.name == AppConstants.kDisplayName,
      );
    });
  }
}
