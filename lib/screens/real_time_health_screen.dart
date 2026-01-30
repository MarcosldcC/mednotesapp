import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/glass_card.dart';
import '../screens/profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import 'trending_news_screen.dart';

class RealTimeHealthScreen extends StatelessWidget {
  const RealTimeHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.creamCard,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppHeader(),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.spacingXXL),
                    
                    // Título e subtítulo
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.darkGreenHeader,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saúde em Tempo Real',
                                style: r.heading1.copyWith(
                                  color: AppColors.darkGreenHeader,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: r.spacingXS),
                              Text(
                                'Se atualize de tudo que está acontecendo no mundo da saúde.',
                                style: r.bodyMedium.copyWith(
                                  color: AppColors.darkGreenHeader,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Seção: Noticias em Alta
                    _buildTrendingNewsSection(context),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Alertas Epidemiológicos
                    _buildEpidemiologicalAlertsSection(),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Incidência por Região
                    _buildIncidenceByRegionSection(),
                    SizedBox(height: r.spacingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 4),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTrendingNewsSection(BuildContext context) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Noticias em Alta',
                  style: r.heading3.copyWith(
                    color: AppColors.darkGreenHeader,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrendingNewsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Ver Mais',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingLG),
            _buildNewsCard(
              headline: 'Brasil Registra alta no número de óbitos por picadas de escorpião',
              source: 'Fonte: Health Brasil',
              timeAgo: 'Há quatro dias',
              url: null, // URL virá do backend
            ),
            SizedBox(height: r.spacingMD),
            _buildNewsCard(
              headline: 'Brasil Registra alta no número de óbitos por picadas de escorpião',
              source: 'Fonte: Health Brasil',
              timeAgo: 'Há quatro dias',
              url: null, // URL virá do backend
            ),
            SizedBox(height: r.spacingMD),
            _buildNewsCard(
              headline: 'Brasil Registra alta no número de óbitos por picadas de escorpião',
              source: 'Fonte: Health Brasil',
              timeAgo: 'Há quatro dias',
              url: null, // URL virá do backend
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewsCard({
    required String headline,
    required String source,
    required String timeAgo,
    String? url,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        final isLargeText = MediaQuery.textScaleFactorOf(context) > 1.3;
        return GlassCard(
          padding: r.pad(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: r.bodyMedium.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: r.spacingSM),
              Text(
                source,
                style: r.bodySmall.copyWith(
                  color: AppColors.grayText,
                ),
              ),
              SizedBox(height: r.spacingXS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: r.isz(14, min: 12, max: 18),
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
                  GestureDetector(
                    onTap: () async {
                      if (url != null && url.isNotEmpty) {
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                    child: isLargeText
                        ? Icon(
                            Icons.visibility,
                            color: AppColors.darkGreenHeader,
                            size: r.iconXS,
                          )
                        : Text(
                            'Ver mais >',
                            style: r.bodySmall.copyWith(
                              color: AppColors.darkGreenHeader,
                              decoration: url != null && url.isNotEmpty 
                                  ? TextDecoration.underline 
                                  : TextDecoration.none,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEpidemiologicalAlertsSection() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alertas Epidemiológicos',
              style: r.heading3.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingXS),
            Text(
              'Dados epidemiológicos atualizados',
              style: r.bodySmall.copyWith(
                color: AppColors.grayText,
              ),
            ),
            SizedBox(height: r.spacingXS),
            Text(
              'Última atualização: Hoje, 14:30',
              style: r.caption.copyWith(
                color: AppColors.grayText,
              ),
            ),
            SizedBox(height: r.spacingLG),
            _buildAlertCard(
              disease: 'Dengue',
              region: 'Sudeste',
              percentage: '+45%',
              isIncrease: true,
            ),
            SizedBox(height: r.spacingMD),
            _buildAlertCard(
              disease: 'Covid-19',
              region: 'Sul',
              percentage: '-12%',
              isIncrease: false,
            ),
            SizedBox(height: r.spacingMD),
            _buildAlertCard(
              disease: 'Influenza',
              region: 'Centro-Oeste',
              percentage: '+25%',
              isIncrease: true,
              isOrange: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlertCard({
    required String disease,
    required String region,
    required String percentage,
    required bool isIncrease,
    bool isOrange = false,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        final borderColor = isOrange 
            ? AppColors.orange 
            : (isIncrease ? AppColors.red : AppColors.darkGreenHeader);
        final iconColor = isOrange 
            ? AppColors.orange 
            : (isIncrease ? AppColors.red : AppColors.darkGreenHeader);
        final textColor = isOrange 
            ? AppColors.orange 
            : (isIncrease ? AppColors.red : AppColors.darkGreenHeader);
        final backgroundColor = isOrange 
            ? AppColors.orange.withOpacity(0.05)
            : (isIncrease 
                ? AppColors.red.withOpacity(0.05)
                : AppColors.creamCard);

        return Container(
          padding: r.pad(all: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: Border.all(
              color: borderColor.withOpacity(0.3),
              width: r.s(1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: r.h(40, min: 36, max: 48),
                height: r.h(40, min: 36, max: 48),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor,
                    width: r.s(1.5),
                  ),
                ),
                child: Icon(
                  isOrange ? Icons.warning_amber : Icons.warning_rounded,
                  color: iconColor,
                  size: r.iconSM,
                ),
              ),
              SizedBox(width: r.spacingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease,
                      style: r.bodyMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingXS),
                    Text(
                      region,
                      style: r.bodySmall.copyWith(
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                percentage,
                style: r.heading3.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIncidenceByRegionSection() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incidência por Região',
              style: r.heading3.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingMD),
            // Tabela
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(r.radiusMD),
                border: Border.all(
                  color: AppColors.mediumGreen.withOpacity(0.3),
                  width: r.s(1),
                ),
              ),
              child: Column(
                children: [
                  // Cabeçalho da tabela
                  Container(
                    padding: r.pad(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.creamCard,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(r.radiusMD),
                        topRight: Radius.circular(r.radiusMD),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Região',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Dengue',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Covid',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Influenza',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Linha de dados: SP
                  _buildTableRow('SP', '1250', '340', '180'),
                  // Divisor
                  Divider(
                    height: r.s(1),
                    thickness: r.s(1),
                    color: AppColors.mediumGreen.withOpacity(0.2),
                  ),
                  // Linha de dados: RJ
                  _buildTableRow('RJ', '890', '220', '150'),
                  // Divisor
                  Divider(
                    height: r.s(1),
                    thickness: r.s(1),
                    color: AppColors.mediumGreen.withOpacity(0.2),
                  ),
                  // Linha de dados: MG
                  _buildTableRow('MG', '650', '180', '96'),
                ],
              ),
            ),
            SizedBox(height: r.spacingSM),
            Text(
              'Casos por 100 mil habitantes',
              style: r.bodySmall.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableRow(String region, String dengue, String covid, String influenza) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          padding: r.pad(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  region,
                  style: r.bodyMedium.copyWith(
                    color: AppColors.darkGreenHeader,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  dengue,
                  style: r.bodyMedium.copyWith(
                    color: AppColors.darkGreenHeader,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  covid,
                  style: r.bodyMedium.copyWith(
                    color: AppColors.darkGreenHeader,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  influenza,
                  style: r.bodyMedium.copyWith(
                    color: AppColors.darkGreenHeader,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
