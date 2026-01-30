import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/real_time_health_screen.dart';
import '../screens/marketplace_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/eco_mode_screen.dart';
import '../screens/on_call_mode_screen.dart';
import '../screens/clinical_algorithms_screen.dart';
import '../screens/algorithm_detail_screen.dart';
import '../services/settings_service.dart';
import '../providers/user_career_provider.dart';
import '../providers/recent_protocols_provider.dart';
import '../utils/theme_helper.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../widgets/glass_card.dart';
import '../design/responsive.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2; // Home está no meio (índice 2)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light, // Ícones brancos para fundo verde
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header com avatar, logo e notificação
            const AppHeader(),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.spacingXXL),
                    
                    // Seção: Seu Nível de Performance
                    _buildPerformanceSection(),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Olá Paola!
                    _buildGreetingSection(),
                    SizedBox(height: r.spacingXXL),
                    
                    // Barra de busca
                    _buildSearchBar(),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Ações Rápidas
                    _buildQuickActionsSection(),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Modo Eco Ativo
                    _buildEcoModeSection(),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Protocolos Recentes
                    _buildRecentProtocolsSection(),
                    SizedBox(height: r.spacingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTap: (index) {
          // Apenas atualiza o índice para índices que não têm navegação padrão
          // (índices 0 e 1). Os índices 2, 3 e 4 são tratados pelo componente.
          if (index != 2 && index != 3 && index != 4) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  Widget _buildPerformanceSection() {
    final r = Responsive.of(context);

    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        final textColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        final subtitleColor = settings.highContrast ? Colors.black : AppColors.grayText;
        final ecoMode = settings.ecoModeEnabled;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seu Nível de Performance',
              style: r.heading2.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingSM),
            Text(
              'Acompanhe seu progresso no MedNotes',
              style: r.bodyMedium.copyWith(
                color: subtitleColor,
              ),
            ),
            SizedBox(height: r.spacingLG),
            Consumer<UserCareerProvider>(
              builder: (context, career, child) {
                final cardColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
                final tierLabel = career.currentLevel.displayName;
                final pointsStr = '${career.pointsInTier}/100';
                final rankStr = career.rankInTier != null ? '#${career.rankInTier}' : '—';
                return Container(
                  padding: r.pad(left: 20, right: 20, top: 20, bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(r.radiusLG),
                    border: settings.highContrast
                        ? Border.all(color: Colors.white, width: r.s(2))
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(ecoMode ? 0.06 : 0.12),
                        blurRadius: r.s(ecoMode ? 8 : 12, min: 8, max: 16),
                        offset: Offset(0, r.s(ecoMode ? 3 : 6, min: 3, max: 8)),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: r.pad(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildMetricItem(Icons.workspace_premium, 'TIER', tierLabel),
                            ),
                            Container(
                              width: r.s(1),
                              height: r.h(70, min: 60, max: 80),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Expanded(
                              child: _buildMetricItem(Icons.star_outline, 'PONTOS', pointsStr),
                            ),
                            Container(
                              width: r.s(1),
                              height: r.h(70, min: 60, max: 80),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Expanded(
                              child: _buildMetricItem(Icons.leaderboard, 'RANKING', rankStr),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: r.s(1),
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      SizedBox(height: r.spacingXS),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProgressScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: r.pad(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Ver Mais',
                            style: r.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value) {
    final r = Responsive.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: r.iconMD),
        SizedBox(height: r.spacingSM),
        Text(
          label,
          style: r.bodySmall.copyWith(
            color: Colors.white70,
          ),
        ),
        SizedBox(height: r.spacingXS),
        Text(
          value,
          style: r.heading3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection() {
    final r = Responsive.of(context);
    
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        final textColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        final subtitleColor = settings.highContrast ? Colors.black : AppColors.grayText;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá ${AppConstants.kDisplayName}!',
              style: r.heading2.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingSM),
            Text(
              'O que você precisa hoje?',
              style: r.bodyMedium.copyWith(
                color: subtitleColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    final r = Responsive.of(context);
    
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        return GlassCard(
          useGlass: !settings.highContrast,
          padding: r.pad(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.search, color: AppColors.grayText, size: r.iconMD),
              SizedBox(width: r.spacingMD),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar sintoma, doença ou protocolo...',
                    hintStyle: r.bodyMedium.copyWith(
                      color: AppColors.grayText,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: r.bodyMedium.copyWith(
                    color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                  ),
                  onChanged: (value) {
                    // Aqui você pode implementar a lógica de busca
                    // Por exemplo, filtrar resultados baseado no valor digitado
                  },
                  onSubmitted: (value) {
                    // Aqui você pode implementar a ação quando o usuário pressionar Enter
                    // Por exemplo, navegar para uma tela de resultados de busca
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsSection() {
    final r = Responsive.of(context);
    
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        final textColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações Rápidas',
              style: r.heading2.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        SizedBox(height: r.spacingLG),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClinicalAlgorithmsScreen(),
                    ),
                  );
                },
                child: _buildQuickActionCard(
                  imagePath: 'assets/images/Vector.svg',
                  title: 'Algoritmos',
                  subtitle: 'Fluxogramas clínicos',
                  isHighlighted: false,
                ),
              ),
            ),
            SizedBox(width: r.spacingMD),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnCallModeScreen(),
                    ),
                  );
                },
                child: _buildQuickActionCard(
                  imagePath: 'assets/images/Vector-1.svg',
                  title: 'Modo Plantão',
                  subtitle: 'Decisões Rápidas',
                  isHighlighted: true,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: r.spacingMD),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarketplaceScreen(),
                      ),
                    );
                  },
                  child: _buildQuickActionCard(
                    imagePath: 'assets/images/Vector-2.svg',
                    title: 'Marketplace',
                    subtitle: 'Produtos e serviços',
                    isHighlighted: false,
                  ),
                ),
              ),
              SizedBox(width: r.spacingMD),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RealTimeHealthScreen(),
                      ),
                    );
                  },
                  child: _buildQuickActionCard(
                    imagePath: 'assets/images/Vector-3.svg',
                    title: 'Saúde em Tempo Real',
                    subtitle: 'Dados epidemiológicos',
                    isHighlighted: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
      },
    );
  }

  Widget _buildQuickActionCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required bool isHighlighted,
  }) {
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        final r = Responsive.of(context);
        final ecoMode = settings.ecoModeEnabled;
        final useGlass = !settings.highContrast && !isHighlighted;
        final cardColor = settings.highContrast
            ? (isHighlighted ? Colors.black : Colors.white)
            : (isHighlighted ? AppColors.darkGreenHeader : Colors.white);
        final borderColor = settings.highContrast
            ? Colors.black
            : AppColors.darkGreenHeader;

        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: r.iconXL,
              height: r.iconXL,
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  settings.highContrast
                      ? (isHighlighted ? Colors.white : Colors.black)
                      : (isHighlighted ? Colors.white : AppColors.darkGreenHeader),
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: r.spacingMD),
            Text(
              title,
              style: r.bodyLarge.copyWith(
                color: settings.highContrast
                    ? (isHighlighted ? Colors.white : Colors.black)
                    : (isHighlighted ? Colors.white : AppColors.darkGreenHeader),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingXS),
            Text(
              subtitle,
              style: r.bodySmall.copyWith(
                color: settings.highContrast
                    ? (isHighlighted ? Colors.white70 : Colors.black)
                    : (isHighlighted ? Colors.white70 : AppColors.grayText),
              ),
            ),
          ],
        );

        if (useGlass) {
          return GlassCard(
            useGlass: true,
            padding: r.pad(all: 16),
            child: content,
          );
        }

        return Container(
          padding: r.pad(all: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: Border.all(
              color: borderColor,
              width: settings.highContrast ? 2 : (isHighlighted ? 0 : 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(ecoMode ? 0.04 : (isHighlighted ? 0.14 : 0.08)),
                blurRadius: r.s(ecoMode ? 7 : 10, min: 6, max: 14),
                offset: Offset(0, r.s(ecoMode ? 2 : 4, min: 2, max: 6)),
              ),
            ],
          ),
          child: content,
        );
      },
    );
  }

  Widget _buildEcoModeSection() {
    final r = Responsive.of(context);
    
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        final cardColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        final isLargeText = MediaQuery.textScaleFactorOf(context) > 1.3;
        final ecoMode = settings.ecoModeEnabled;
        return Container(
          padding: r.pad(all: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: settings.highContrast 
                ? Border.all(color: Colors.white, width: r.s(2))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(ecoMode ? 0.06 : 0.12),
                blurRadius: r.s(ecoMode ? 8 : 12, min: 8, max: 16),
                offset: Offset(0, r.s(ecoMode ? 3 : 6, min: 3, max: 8)),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(r.radiusMD),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EcoModeScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.eco, color: Colors.white, size: r.iconXL),
                SizedBox(width: r.spacingLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.ecoModeEnabled
                            ? 'Modo Eco Ativo'
                            : 'Conheça o Modo Eco',
                        style: r.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: r.spacingXS),
                      Text(
                        settings.ecoModeEnabled
                            ? 'Economizando energia e dados.'
                            : 'Veja como o MedNotes reduz o impacto.',
                        style: r.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EcoModeScreen(),
                      ),
                    );
                  },
                  child: isLargeText
                      ? Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: r.iconSM,
                        )
                      : Text(
                          'Ver mais >',
                          style: r.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentProtocolsSection() {
    final r = Responsive.of(context);

    return Consumer2<SettingsService, RecentProtocolsProvider>(
      builder: (context, settings, recent, child) {
        final textColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        final subtitleColor = settings.highContrast ? Colors.black : AppColors.grayText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Protocolos Recentes',
                    style: r.heading2.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver',
                        style: r.bodyMedium.copyWith(
                          color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                        ),
                      ),
                      SizedBox(width: r.spacingXS),
                      Icon(Icons.swipe, color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader, size: r.iconSM),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingLG),
            if (recent.titles.isEmpty)
              GlassCard(
                useGlass: !settings.highContrast,
                padding: EdgeInsets.zero,
                child: Container(
                  height: r.h(100, min: 80, max: 120),
                  alignment: Alignment.center,
                  child: Text(
                    'Nenhum protocolo recente',
                    style: r.bodyMedium.copyWith(color: subtitleColor),
                  ),
                ),
              )
            else
              GlassCard(
                useGlass: !settings.highContrast,
                padding: r.pad(all: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recent.titles.take(5).toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final title = entry.value;
                    final isLast = index == (recent.titles.length > 5 ? 4 : recent.titles.length - 1);
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : r.spacingMD),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlgorithmDetailScreen(
                                algorithmTitle: title,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: AppColors.darkGreenHeader,
                              size: r.iconSM,
                            ),
                            SizedBox(width: r.spacingSM),
                            Expanded(
                              child: Text(
                                title,
                                style: r.bodyMedium.copyWith(color: textColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: subtitleColor,
                              size: r.iconSM,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }


}
