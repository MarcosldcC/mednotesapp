import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';
import '../providers/user_career_provider.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/on_call_mode_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

/// Tela exibida quando o usuário conclui a simulação com sucesso.
/// [pointsAwarded] pontos de carreira concedidos ao concluir (padrão 10).
class OnCallSimulationCompletedScreen extends StatefulWidget {
  const OnCallSimulationCompletedScreen({super.key, this.pointsAwarded = 10});

  final int pointsAwarded;

  @override
  State<OnCallSimulationCompletedScreen> createState() => _OnCallSimulationCompletedScreenState();
}

class _OnCallSimulationCompletedScreenState extends State<OnCallSimulationCompletedScreen> {
  bool _pointsAwarded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_pointsAwarded && mounted) {
        _pointsAwarded = true;
        Provider.of<UserCareerProvider>(context, listen: false)
            .addPoints(widget.pointsAwarded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    final primaryColor =
        settings.highContrast ? Colors.black : AppColors.darkGreenHeader;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: primaryColor,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(isWhite: true),
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: r.spacingXL),
                    // Ícone de sucesso central
                    _buildSuccessIcon(r, primaryColor),
                    SizedBox(height: r.spacingLG),
                    Text(
                      'Simulação Concluída',
                      style: r.heading1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingXS),
                    Text(
                      'Você concluiu o caso dentro do tempo e seguindo as diretrizes.',
                      style: r.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingXXL),
                    // Badge destaque
                    _buildBadge(r, widget.pointsAwarded),
                    SizedBox(height: r.spacingXXL),
                    // Card resumo com ícones
                    _buildSummaryCard(r, primaryColor),
                    SizedBox(height: r.spacingXXL),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navega para o Modo Plantão removendo todas as rotas
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const OnCallModeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryColor,
                          padding: r.pad(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Voltar ao Modo Plantão',
                          style: r.button.copyWith(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        isWhite: true,
        currentIndex: 1,
        onItemTap: (_) {},
      ),
    );
  }

  Widget _buildSuccessIcon(Responsive r, Color primaryColor) {
    return Container(
      width: r.h(88, min: 72, max: 104),
      height: r.h(88, min: 72, max: 104),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGreen.withOpacity(0.4),
            blurRadius: r.s(20),
            spreadRadius: r.s(2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: r.s(12),
            offset: Offset(0, r.s(4)),
          ),
        ],
      ),
      child: Icon(
        Icons.check_rounded,
        size: r.iconXL * 2,
        color: AppColors.lightGreen,
      ),
    );
  }

  Widget _buildBadge(Responsive r, int pointsAwarded) {
    return Container(
      padding: r.pad(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(r.radiusXL),
        border: Border.all(
          color: AppColors.lightGreen.withOpacity(0.5),
          width: r.s(1.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_rounded,
            color: AppColors.lightGreen,
            size: r.iconMD,
          ),
          SizedBox(width: r.spacingSM),
          Flexible(
            child: Text(
              'PCR – Assistolia | Conduta Adequada • +${pointsAwarded} pts',
              style: r.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Responsive r, Color primaryColor) {
    final items = [
      (Icons.schedule_rounded, 'Tempo total: ≤ 3 minutos'),
      (Icons.medical_services_rounded, 'Conduta adequada para PCR em assistolia'),
      (Icons.favorite_rounded, 'RCP contínua'),
      (Icons.medication_rounded, 'Uso correto de adrenalina'),
      (Icons.search_rounded, 'Investigação de causas reversíveis'),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(r.radiusLG),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: r.pad(all: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(r.radiusLG),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: r.s(1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.summarize_rounded,
                    color: Colors.white,
                    size: r.iconMD,
                  ),
                  SizedBox(width: r.spacingSM),
                  Text(
                    'Resumo do caso',
                    style: r.heading3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.spacingMD),
              ...items.map((e) => Padding(
                    padding: r.pad(bottom: r.spacingMD),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: r.h(32, min: 28, max: 36),
                          height: r.h(32, min: 28, max: 36),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(r.radiusSM),
                          ),
                          child: Icon(
                            e.$1,
                            color: Colors.white,
                            size: r.iconSM,
                          ),
                        ),
                        SizedBox(width: r.spacingMD),
                        Expanded(
                          child: Text(
                            e.$2,
                            style: r.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.95),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
