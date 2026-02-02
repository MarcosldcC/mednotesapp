import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';
import '../providers/user_career_provider.dart';
import '../models/career_level.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/simulation_case_selection_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

/// Tela de conclusão de caso clínico (simulação por caso).
/// Diferente da OnCallSimulationCompletedScreen (modo plantão).
class SimulationCaseCompletedScreen extends StatefulWidget {
  final String patientName;
  final int patientAge;
  final int pointsAwarded;
  final int? elapsedSeconds;
  final bool success;

  const SimulationCaseCompletedScreen({
    super.key,
    required this.patientName,
    required this.patientAge,
    this.pointsAwarded = 15,
    this.elapsedSeconds,
    this.success = true,
  });

  @override
  State<SimulationCaseCompletedScreen> createState() =>
      _SimulationCaseCompletedScreenState();
}

class _SimulationCaseCompletedScreenState
    extends State<SimulationCaseCompletedScreen> {
  bool _pointsAwarded = false;
  bool _leveledUp = false;
  int _previousLevelIndex = 0;
  int _previousPointsInTier = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_pointsAwarded && mounted) {
        final career = Provider.of<UserCareerProvider>(context, listen: false);
        _previousLevelIndex = career.levelIndex;
        _previousPointsInTier = career.pointsInTier;
        career.addPoints(widget.pointsAwarded).then((leveledUp) {
          if (mounted) {
            setState(() {
              _pointsAwarded = true;
              _leveledUp = leveledUp;
            });
          }
        });
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
                    // Ícone de sucesso
                    _buildSuccessIcon(r, primaryColor),
                    SizedBox(height: r.spacingLG),
                    Text(
                      'Caso Concluído',
                      style: r.heading1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingXS),
                    Text(
                      'Você finalizou o atendimento do paciente com sucesso.',
                      style: r.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingXXL),
                    // Card do paciente
                    _buildPatientCard(r),
                    SizedBox(height: r.spacingLG),
                    // Card de pontos e progresso
                    Consumer<UserCareerProvider>(
                      builder: (context, career, child) {
                        return _buildProgressCard(r, career);
                      },
                    ),
                    SizedBox(height: r.spacingLG),
                    // Card resumo do desempenho
                    _buildPerformanceCard(r),
                    SizedBox(height: r.spacingXXL),
                    // Botões de ação
                    _buildActionButtons(r, primaryColor),
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

  Widget _buildPatientCard(Responsive r) {
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
                  Container(
                    width: r.h(48, min: 40, max: 56),
                    height: r.h(48, min: 40, max: 56),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(r.radiusMD),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: r.iconMD,
                    ),
                  ),
                  SizedBox(width: r.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.patientName,
                          style: r.heading3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: r.spacingXS),
                        Text(
                          '${widget.patientAge} anos',
                          style: r.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
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

  Widget _buildProgressCard(Responsive r, UserCareerProvider career) {
    final currentLevel = career.currentLevel;
    final progress = career.progressToNextTier;
    final pointsToNext = career.pointsToNextTier;

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
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: r.iconMD,
                  ),
                  SizedBox(width: r.spacingSM),
                  Text(
                    'Progresso na Carreira',
                    style: r.heading3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.spacingLG),
              // Nível atual
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nível Atual',
                        style: r.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: r.spacingXS),
                      Text(
                        currentLevel.displayName,
                        style: r.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: r.pad(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(r.radiusMD),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.lightGreen,
                          size: r.iconSM,
                        ),
                        SizedBox(width: r.spacingXS),
                        Text(
                          '+${widget.pointsAwarded} pts',
                          style: r.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.spacingLG),
              // Barra de progresso
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progresso no Tier',
                        style: r.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        '${career.pointsInTier}/100',
                        style: r.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.spacingSM),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(r.radiusSM),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: r.h(8, min: 6, max: 10),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.lightGreen,
                      ),
                    ),
                  ),
                  SizedBox(height: r.spacingXS),
                  if (pointsToNext > 0)
                    Text(
                      'Faltam $pointsToNext pontos para o próximo tier',
                      style: r.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    )
                  else if (_leveledUp)
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_upward_rounded,
                          color: AppColors.lightGreen,
                          size: r.iconSM,
                        ),
                        SizedBox(width: r.spacingXS),
                        Text(
                          'Parabéns! Você subiu para ${career.currentLevel.displayName}',
                          style: r.bodySmall.copyWith(
                            color: AppColors.lightGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(Responsive r) {
    final items = <(IconData, String)>[];
    
    if (widget.elapsedSeconds != null) {
      final minutes = widget.elapsedSeconds! ~/ 60;
      final seconds = widget.elapsedSeconds! % 60;
      items.add((
        Icons.schedule_rounded,
        'Tempo total: ${minutes}m ${seconds}s',
      ));
    }
    
    items.addAll([
      (Icons.medical_services_rounded, 'Atendimento completo'),
      (Icons.check_circle_rounded, 'Condutas adequadas'),
      (Icons.favorite_rounded, 'Paciente estabilizado'),
    ]);

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
                    'Resumo do desempenho',
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

  Widget _buildActionButtons(Responsive r, Color primaryColor) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const SimulationCaseSelectionScreen(),
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
              'Novo Caso',
              style: r.button.copyWith(color: primaryColor),
            ),
          ),
        ),
        SizedBox(height: r.spacingMD),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white.withOpacity(0.5),
                width: r.s(1.5),
              ),
              padding: r.pad(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.radiusMD),
              ),
            ),
            child: Text(
              'Voltar ao Início',
              style: r.button.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
