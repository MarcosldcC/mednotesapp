import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';
import '../screens/profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../models/on_call_simulation_step.dart';
import 'on_call_simulation_completed_screen.dart';
import 'on_call_mode_screen.dart';
import 'dashboard_screen.dart';
import 'marketplace_screen.dart';
import 'real_time_health_screen.dart';

/// Tela da simulação em andamento - Paciente em PCR (design Figma node 157-764).
/// [initialStep] 0 = primeira decisão, 1-5 = Telas 2-6. [remainingSeconds] repassado ao avançar.
class OnCallSimulationScreen extends StatefulWidget {
  final int initialStep;
  final int? remainingSeconds;

  const OnCallSimulationScreen({
    super.key,
    this.initialStep = 0,
    this.remainingSeconds,
  });

  @override
  State<OnCallSimulationScreen> createState() => _OnCallSimulationScreenState();
}

class _OnCallSimulationScreenState extends State<OnCallSimulationScreen> {
  int _currentIndex = 1; // Raio = Modo Plantão
  late int _remainingSeconds;
  int? _selectedActionIndex;
  bool? _feedbackState; // null = nenhum, true = correto, false = incorreto
  Timer? _timer;

  int get _step => widget.initialStep;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.remainingSeconds ?? 180;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
        if (_remainingSeconds == 0) _timer?.cancel();
      });
      if (_remainingSeconds == 0 && mounted) {
        Future.microtask(() => _showTimeUpAndFinish());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

    final minutes = _remainingSeconds ~/ 60;
    final secs = _remainingSeconds % 60;
    final timeStr = '$minutes:${secs.toString().padLeft(2, '0')}';

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation(r, primaryColor);
        if (shouldExit == true && mounted) {
          // Navega para o Modo Plantão removendo todas as rotas
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OnCallModeScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        drawer: const ProfileMenuScreen(),
        drawerEnableOpenDragGesture: true,
        body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(r, primaryColor),
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _step == 0
                      ? _buildStep0Content(r, primaryColor, timeStr)
                      : _buildStep1To5Content(r, primaryColor, timeStr),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        isWhite: true,
        currentIndex: _currentIndex,
        interceptAllTaps: true,
        onItemTap: (index) async {
          if (index != 1) { // Se não for o próprio Modo Plantão
            final shouldExit = await _showExitConfirmation(r, primaryColor);
            if (shouldExit == true && mounted) {
              // Navega para a tela correspondente
              if (index == 0) {
                // Algoritmos
              } else if (index == 2) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  (route) => false,
                );
              } else if (index == 3) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MarketplaceScreen()),
                  (route) => false,
                );
              } else if (index == 4) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const RealTimeHealthScreen()),
                  (route) => false,
                );
              }
            }
          }
        },
      ),
      ),
    );
  }

  Future<bool?> _showExitConfirmation(Responsive r, Color primaryColor) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        title: Text(
          'Sair do Modo Plantão?',
          style: r.heading3.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Você está em uma simulação em andamento. Deseja realmente sair? O progresso será perdido.',
          style: r.bodyMedium.copyWith(
            color: AppColors.grayText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: r.bodyMedium.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Sair',
              style: r.bodyMedium.copyWith(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return result;
  }

  static const int _step0CorrectIndex = 0;
  static const String _step0FeedbackCorrect =
      'Iniciar monitorização e acesso sem interromper a RCP.';
  static const String _step0FeedbackError =
      'Interromper a RCP neste momento reduz a chance de sobrevida.';

  List<Widget> _buildStep0Content(
      Responsive r, Color primaryColor, String timeStr) {
    return [
      _buildTimerRow(r, primaryColor, timeStr),
      SizedBox(height: r.spacingSM),
      Divider(
        color: Colors.white.withOpacity(0.4),
        thickness: r.s(1),
      ),
      SizedBox(height: r.spacingMD),
      _buildWhiteCard(
        r,
        child: _buildEmergencyCardContent(r, primaryColor),
      ),
      SizedBox(height: r.spacingXXL),
      _buildGlassCard(
        r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Situação',
              style: r.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingSM),
            Text(
              'Paciente de 65 anos, encontrado inconsciente na enfermaria. Sem pulso palpável. Monitor mostra assistolia.',
              style: r.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.95),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: r.spacingXXL),
      _buildGlassCard(
        r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sinais Vitais',
              style: r.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingMD),
            _buildVitalSignsGrid(r, primaryColor),
          ],
        ),
      ),
      SizedBox(height: r.spacingXXL),
      _buildGlassCard(
        r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qual sua primeira ação?',
              style: r.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingMD),
            if (_feedbackState != null && _selectedActionIndex != null)
              Padding(
                padding: r.pad(bottom: r.spacingMD),
                child: Text(
                  _feedbackState! ? _step0FeedbackCorrect : _step0FeedbackError,
                  style: r.bodySmall.copyWith(
                    color: _feedbackState!
                        ? AppColors.lightGreen
                        : AppColors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            _buildActionOption(
              r,
              primaryColor,
              0,
              'Iniciar RCP de alta qualidade imediatamente',
              isCorrect: _selectedActionIndex == 0 ? _feedbackState : null,
              onTap: () => _onOptionTapped(0, _step0CorrectIndex, null, null),
            ),
            SizedBox(height: r.spacingSM),
            _buildActionOption(
              r,
              primaryColor,
              1,
              'Intubar o paciente primeiro',
              isCorrect: _selectedActionIndex == 1 ? _feedbackState : null,
              onTap: () => _onOptionTapped(1, _step0CorrectIndex, _step0FeedbackCorrect, _step0FeedbackError),
            ),
            SizedBox(height: r.spacingSM),
            _buildActionOption(
              r,
              primaryColor,
              2,
              'Administrar adrenalina IV',
              isCorrect: _selectedActionIndex == 2 ? _feedbackState : null,
              onTap: () => _onOptionTapped(2, _step0CorrectIndex, _step0FeedbackCorrect, _step0FeedbackError),
            ),
            SizedBox(height: r.spacingSM),
            _buildActionOption(
              r,
              primaryColor,
              3,
              'Desfibrilar imediatamente',
              isCorrect: _selectedActionIndex == 3 ? _feedbackState : null,
              onTap: () => _onOptionTapped(3, _step0CorrectIndex, _step0FeedbackCorrect, _step0FeedbackError),
            ),
          ],
        ),
      ),
      SizedBox(height: r.spacingXXL),
    ];
  }

  List<Widget> _buildStep1To5Content(
      Responsive r, Color primaryColor, String timeStr) {
    final stepData = OnCallSimulationSteps.stepAt(_step - 1);
    final isLastStep = _step == 5;

    return [
      _buildTimerRow(r, primaryColor, timeStr),
      SizedBox(height: r.spacingSM),
      Divider(
        color: Colors.white.withOpacity(0.4),
        thickness: r.s(1),
      ),
      SizedBox(height: r.spacingMD),
      _buildWhiteCard(
        r,
        child: _buildStepTitleContent(r, primaryColor, stepData.cardTitle),
      ),
      SizedBox(height: r.spacingXXL),
      _buildGlassCard(
        r,
        child: _buildCardContent(r, stepData.cardTitle, stepData.cardContent),
      ),
      SizedBox(height: r.spacingXXL),
      _buildGlassCard(
        r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepData.question,
              style: r.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_feedbackState != null && _selectedActionIndex != null) ...[
              SizedBox(height: r.spacingMD),
              Text(
                _feedbackState! ? stepData.feedbackCorrect : stepData.feedbackError,
                style: r.bodySmall.copyWith(
                  color: _feedbackState!
                      ? AppColors.lightGreen
                      : AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            SizedBox(height: r.spacingMD),
            ...List.generate(4, (i) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i < 3 ? r.spacingSM : 0,
                ),
                child: _buildActionOption(
                  r,
                  primaryColor,
                  i,
                  stepData.options[i],
                  isCorrect: _selectedActionIndex == i ? _feedbackState : null,
                  onTap: () => _onOptionTapped(
                    i,
                    stepData.correctIndex,
                    stepData.feedbackCorrect,
                    stepData.feedbackError,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      SizedBox(height: r.spacingXXL),
    ];
  }

  Widget _buildStepTitleContent(Responsive r, Color primaryColor, String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: r.heading3.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _onOptionTapped(
    int index,
    int correctIndex,
    String? feedbackCorrect,
    String? feedbackError,
  ) {
    if (_feedbackState != null) return; // já respondeu
    final isCorrect = index == correctIndex;
    setState(() {
      _selectedActionIndex = index;
      _feedbackState = isCorrect;
    });
    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        _timer?.cancel();
        if (_step == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => OnCallSimulationScreen(
                initialStep: 1,
                remainingSeconds: _remainingSeconds,
              ),
            ),
          );
        } else if (_step == 5) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const OnCallSimulationCompletedScreen(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => OnCallSimulationScreen(
                initialStep: _step + 1,
                remainingSeconds: _remainingSeconds,
              ),
            ),
          );
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        _timer?.cancel();
        _showErrorPopup();
      });
    }
  }

  void _showErrorPopup() {
    if (!mounted) return;
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context, listen: false);
    final primaryColor =
        settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Simulação Encerrada',
          style: r.heading3.copyWith(color: primaryColor),
        ),
        content: Text(
          'A decisão tomada não está alinhada às diretrizes de PCR. A simulação foi encerrada.',
          style: r.bodyMedium.copyWith(color: AppColors.grayText),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // fecha o dialog
              if (context.mounted) Navigator.of(context).pop(); // volta ao Modo Plantão
            },
            child: Text(
              'Tentar novamente',
              style: r.bodyMedium.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Timer: só relógio em quadrado branco + tempo + Sair, sem card por baixo.
  Widget _buildTimerRow(Responsive r, Color primaryColor, String timeStr) {
    return Row(
      children: [
        Container(
          width: r.h(44, min: 40, max: 52),
          height: r.h(44, min: 40, max: 52),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r.radiusSM),
          ),
          child: Icon(
            Icons.schedule,
            color: primaryColor,
            size: r.iconMD,
          ),
        ),
        SizedBox(width: r.spacingMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tempo restante',
                style: r.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                timeStr,
                style: r.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () async {
            final shouldExit = await _showExitConfirmation(r, primaryColor);
            if (shouldExit == true && mounted) {
              // Navega para o Modo Plantão removendo todas as rotas
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const OnCallModeScreen()),
                (route) => false,
              );
            }
          },
          child: Text(
            'Sair',
            style: r.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Card branco (fundo sólido), sem vidro.
  Widget _buildWhiteCard(Responsive r, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: r.s(8),
            offset: Offset(0, r.s(2)),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Card com efeito de vidro (glassmorphism) para fundo verde.
  Widget _buildGlassCard(Responsive r, {required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r.radiusMD),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: r.pad(all: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: r.s(1),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildEmergencyCardContent(Responsive r, Color primaryColor) {
    return Row(
      children: [
        Container(
          width: r.h(44, min: 40, max: 52),
          height: r.h(44, min: 40, max: 52),
          decoration: BoxDecoration(
            color: AppColors.creamLight,
            borderRadius: BorderRadius.circular(r.radiusSM),
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            color: primaryColor,
            size: r.iconMD,
          ),
        ),
        SizedBox(width: r.spacingMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergência',
                style: r.bodySmall.copyWith(
                  color: AppColors.grayText,
                ),
              ),
              Text(
                'Paciente em PCR',
                style: r.heading3.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomHeader(Responsive r, Color primaryColor) {
    return Builder(
      builder: (context) {
        final settings = Provider.of<SettingsService>(context);
        final headerColor = Colors.white;
        final textColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        final iconColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        final avatarBackgroundColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;

        final avatarRadius = r.h(20, min: 18, max: 22);
        final avatarSize = avatarRadius * 2;

        return Container(
          decoration: BoxDecoration(
            color: headerColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(r.r(30, min: 20, max: 40)),
              bottomRight: Radius.circular(r.r(30, min: 20, max: 40)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(settings.ecoModeEnabled ? 0.05 : 0.1),
                blurRadius: r.s(settings.ecoModeEnabled ? 3 : 4, min: 3, max: 6),
                offset: Offset(0, r.s(settings.ecoModeEnabled ? 1 : 2)),
              ),
            ],
          ),
          padding: r.pad(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final shouldExit = await _showExitConfirmation(r, primaryColor);
                  if (shouldExit == true && mounted) {
                    // Navega para o Modo Plantão removendo todas as rotas
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const OnCallModeScreen()),
                      (route) => false,
                    );
                  } else if (mounted) {
                    Scaffold.of(context).openDrawer();
                  }
                },
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: avatarBackgroundColor,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/medica.png',
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.mediumGreen,
                          child: Icon(
                            Icons.person,
                            size: r.isz(20, min: 18, max: 24),
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.spacingMD),
              Expanded(
                child: Text(
                  'mednotes',
                  style: r.bodyLarge.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: r.h(48, min: 40, max: 56)),
            ],
          ),
        );
      },
    );
  }

  void _showTimeUpAndFinish() {
    _timer?.cancel();
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final r = Responsive.of(context);
        final settings = Provider.of<SettingsService>(context, listen: false);
        final primaryColor =
            settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
        return AlertDialog(
          title: Text(
            'Tempo esgotado',
            style: r.heading3.copyWith(color: primaryColor),
          ),
          content: Text(
            'O tempo acabou antes de você concluir. O modo plantão foi finalizado.',
            style: r.bodyMedium.copyWith(color: AppColors.grayText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // fecha o dialog
                if (context.mounted) Navigator.of(context).pop(); // sai da simulação
              },
              child: Text(
                'OK',
                style: r.bodyMedium.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardContent(Responsive r, String cardTitle, String content) {
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
    // Função para gerar título descritivo baseado no contexto
    String _getContentTitle(String cardTitle, String content) {
      final lowerTitle = cardTitle.toLowerCase();
      final lowerContent = content.toLowerCase();
      
      // Se o card já tem um título específico e o conteúdo é sobre parâmetros/métricas
      if (lowerContent.contains('compress') || 
          lowerContent.contains('profundidade') ||
          lowerContent.contains('recoil') ||
          lowerContent.contains('interrupç')) {
        return 'Parâmetros da RCP';
      }
      
      // Se é sobre sinais vitais/monitoramento
      if (lowerContent.contains('monitor') || 
          lowerContent.contains('fc') ||
          lowerContent.contains('ritmo') ||
          lowerContent.contains('bpm')) {
        return 'Sinais Vitais';
      }
      
      // Se é sobre status/situação
      if (lowerContent.contains('em andamento') ||
          lowerContent.contains('persistência') ||
          lowerContent.contains('sem pulso')) {
        return 'Status Atual';
      }
      
      // Se é sobre causas reversíveis
      if (lowerContent.contains('hipóxia') ||
          lowerContent.contains('hipovolemia') ||
          lowerContent.contains('acidose') ||
          lowerContent.contains('trombo') ||
          lowerContent.contains('tamponamento') ||
          lowerContent.contains('pneumotórax')) {
        return 'Causas Reversíveis (4H e 4T)';
      }
      
      // Se é sobre via aérea/oxigenação
      if (lowerContent.contains('oxigen') ||
          lowerContent.contains('ventil') ||
          lowerContent.contains('via aérea')) {
        return 'Via Aérea e Oxigenação';
      }
      
      // Título padrão baseado no cardTitle
      return 'Informações do Caso';
    }
    
    // Função auxiliar para obter ícone baseado no conteúdo da linha
    IconData _getIconForLine(String line) {
      final lowerLine = line.toLowerCase();
      if (lowerLine.contains('compress')) return Icons.speed_rounded;
      if (lowerLine.contains('profundidade')) return Icons.vertical_align_bottom_rounded;
      if (lowerLine.contains('recoil')) return Icons.refresh_rounded;
      if (lowerLine.contains('interrupç')) return Icons.pause_circle_outline_rounded;
      if (lowerLine.contains('monitor') || lowerLine.contains('ritmo')) return Icons.monitor_heart_rounded;
      if (lowerLine.contains('fc') || lowerLine.contains('frequência')) return Icons.favorite_rounded;
      if (lowerLine.contains('oxigen') || lowerLine.contains('o₂')) return Icons.air_rounded;
      if (lowerLine.contains('pulso')) return Icons.favorite_border_rounded;
      if (lowerLine.contains('hipóxia')) return Icons.air_rounded;
      if (lowerLine.contains('hipovolemia')) return Icons.water_drop_rounded;
      if (lowerLine.contains('acidose')) return Icons.science_rounded;
      if (lowerLine.contains('eletrolít')) return Icons.battery_charging_full_rounded;
      if (lowerLine.contains('trombo') || lowerLine.contains('embol')) return Icons.bloodtype_rounded;
      if (lowerLine.contains('tamponamento')) return Icons.heart_broken_rounded;
      if (lowerLine.contains('pneumotórax')) return Icons.airline_stops_rounded;
      if (lowerLine.contains('rcp')) return Icons.medical_services_rounded;
      if (lowerLine.contains('persistência')) return Icons.trending_flat_rounded;
      return Icons.circle_outlined; // Ícone padrão simples
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título descritivo do card baseado no contexto
        Text(
          _getContentTitle(cardTitle, content),
          style: r.heading3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: r.spacingMD),
        // Lista de informações com ícones
        ...lines.map((line) => Padding(
          padding: r.pad(bottom: r.spacingSM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getIconForLine(line),
                color: AppColors.lightGreen,
                size: r.iconSM,
              ),
              SizedBox(width: r.spacingSM),
              Expanded(
                child: Text(
                  line,
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
    );
  }

  Widget _buildVitalSignsGrid(Responsive r, Color primaryColor) {
    final cellBg = primaryColor.withOpacity(0.6);

    final items = [
      ('Pa', 'Indetectável'),
      ('FC', '0 bpm'),
      ('SpO2', '--'),
      ('Ritmo', 'Assistolia'),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: r.spacingSM,
      crossAxisSpacing: r.spacingSM,
      childAspectRatio: 2.2,
      children: items.map((e) {
        return Container(
          padding: r.pad(all: 12),
          decoration: BoxDecoration(
            color: cellBg,
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: r.s(1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.$1,
                style: r.bodySmall.copyWith(
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: r.spacingXS),
              Text(
                e.$2,
                style: r.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionOption(
    Responsive r,
    Color primaryColor,
    int index,
    String label, {
    bool? isCorrect,
    VoidCallback? onTap,
  }) {
    final isSelected = _selectedActionIndex == index;
    final hasAnswered = _feedbackState != null;
    Color borderColor = Colors.white;
    Color? bgColor;
    Color textColor = Colors.white;

    if (isCorrect == true) {
      borderColor = AppColors.lightGreen;
      bgColor = AppColors.lightGreen.withOpacity(0.3);
      textColor = Colors.white;
    } else if (isCorrect == false) {
      borderColor = AppColors.red;
      bgColor = AppColors.red.withOpacity(0.3);
      textColor = Colors.white;
    } else if (isSelected) {
      bgColor = Colors.white.withOpacity(0.15);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasAnswered ? null : (onTap ?? () => setState(() => _selectedActionIndex = index)),
        borderRadius: BorderRadius.circular(r.radiusMD),
        child: Container(
          width: double.infinity,
          padding: r.pad(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: Border.all(
              color: borderColor,
              width: r.s(1.5),
            ),
          ),
          child: Text(
            label,
            style: r.bodyMedium.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showSimulationExitConfirmation(Responsive r, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sair da simulação?',
          style: r.heading3.copyWith(color: primaryColor),
        ),
        content: Text(
          'O progresso não será salvo.',
          style: r.bodyMedium.copyWith(color: AppColors.grayText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: r.bodyMedium.copyWith(color: primaryColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Sair', style: r.bodyMedium.copyWith(color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
