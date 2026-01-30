import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../widgets/patient_card.dart';
import '../widgets/multiple_choice_option.dart';
import '../widgets/simulation_progress_card.dart';
import '../widgets/simulation_chronometer_bar.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../providers/simulation_state_provider.dart';
import 'simulation_blood_pressure_screen.dart';
import 'simulation_case_selection_screen.dart';
import 'dashboard_screen.dart';
import 'clinical_algorithms_screen.dart';
import 'on_call_mode_screen.dart';
import 'marketplace_screen.dart';
import 'real_time_health_screen.dart';
import 'profile_menu_screen.dart';

/// Tela de triagem inicial da simulação
class SimulationTriageScreen extends StatefulWidget {
  final String patientName;
  final int patientAge;

  const SimulationTriageScreen({
    super.key,
    required this.patientName,
    required this.patientAge,
  });

  @override
  State<SimulationTriageScreen> createState() => _SimulationTriageScreenState();
}

class _SimulationTriageScreenState extends State<SimulationTriageScreen> {
  int? _selectedOption;
  bool _hasAnswered = false;
  bool _isWrong = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SimulationStateProvider>().startSimulation();
      }
    });
  }

  static const int _correctIndex = 1; // B - Medir pressão arterial corretamente
  static const String _drAxonTipCorrect = 'Cefaleia é um sintoma comum e inespecífico. Antes de formular hipóteses, é necessário avaliar dados objetivos. Medir a pressão arterial é conduta essencial na primeira avaliação.';
  static const String _drAxonTipWrong = 'Antes de prescrever ou solicitar exames complexos, avalie sinais vitais e dados objetivos. A triagem inicial deve incluir medição da pressão arterial.';
  static const String _whyWrongA = 'Prescrever analgésico e liberar sem avaliar pressão e outros sinais vitais pode mascarar uma emergência (ex.: crise hipertensiva, AVC).';
  static const String _whyWrongC = 'Solicitar tomografia sem antes avaliar pressão e quadro clínico não segue o raciocínio clínico adequado e pode expor o paciente a exames desnecessários.';

  Future<bool?> _showExitConfirmation(Responsive r) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        title: Text(
          'Sair da simulação?',
          style: r.heading3.copyWith(
            color: AppColors.darkGreenHeader,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Ao sair você perde o progresso e as 3 vidas. Deseja realmente sair?',
          style: r.bodyMedium.copyWith(color: AppColors.grayText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: r.bodyMedium.copyWith(color: AppColors.grayText),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
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
  }

  Future<void> _handleExitSimulation({int? targetNavIndex}) async {
    final r = Responsive.of(context);
    final ok = await _showExitConfirmation(r);
    if (ok != true || !mounted) return;
    context.read<SimulationStateProvider>().endSimulation();
    if (targetNavIndex != null) {
      Widget screen;
      switch (targetNavIndex) {
        case 0: screen = const ClinicalAlgorithmsScreen(); break;
        case 1: screen = const OnCallModeScreen(); break;
        case 2: screen = const DashboardScreen(); break;
        case 3: screen = const MarketplaceScreen(); break;
        case 4: screen = const RealTimeHealthScreen(); break;
        default: screen = const SimulationCaseSelectionScreen();
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => screen),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SimulationCaseSelectionScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _handleExitSimulation();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const ProfileMenuScreen(),
        drawerEnableOpenDragGesture: false,
        body: SafeArea(
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: r.pad(horizontal: 24, top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Botão voltar e título
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColors.darkGreenHeader,
                                size: r.isz(24),
                              ),
                              onPressed: _handleExitSimulation,
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
                                  'Simulação de Atendimento',
                                  style: r.heading1.copyWith(
                                    color: AppColors.darkGreenHeader,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: r.spacingXS),
                                Text(
                                  'Paciente com dor torácica',
                                  style: r.bodyMedium.copyWith(
                                    color: AppColors.grayText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingMD),
                      // Cronômetro + Sair (tempo para resolver o caso)
                      SimulationChronometerBar(onSairTap: _handleExitSimulation),
                      SizedBox(height: r.spacingXXL),

                      // Informações de progresso/tier (vidas do provider)
                      Consumer<SimulationStateProvider>(
                        builder: (_, simState, __) => SimulationProgressCard(
                          lives: simState.lives,
                          pointsReward: 10,
                        ),
                      ),
                      SizedBox(height: r.spacingXL),

                      // Card de informações do paciente (ocultar/exibir persiste)
                      Consumer<SimulationStateProvider>(
                        builder: (_, simState, __) => PatientCard(
                          patientName: widget.patientName,
                          patientAge: widget.patientAge,
                          symptom:
                              'Dor de cabeça persistente há 3 dias e histórico de pressão alta sem tratamento regular.',
                          previousHistory:
                              'Hipertensão arterial não tratada, sobrepeso, sedentarismo e pai faleceu de infarto aos 55 anos.',
                          usualMedication: 'Apenas 1-2 vezes AINE para dores',
                          isCollapsed: simState.isCaseHidden(widget.patientName),
                          onToggleCollapse: () => simState.toggleCaseVisibility(widget.patientName),
                        ),
                      ),
                      SizedBox(height: r.spacingXL),

                      // Seção de triagem inicial
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Triagem Inicial',
                              style: r.heading2.copyWith(
                                color: AppColors.darkGreenHeader,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: r.spacingMD),
                            Text(
                              'Qual deve ser sua primeira conduta?',
                              style: r.bodyLarge.copyWith(
                                color: AppColors.darkGreenHeader,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: r.spacingXL),

                      // Opções de múltipla escolha (errou = vermelho + perde vida + Dr. Axon)
                      MultipleChoiceOption(
                        letter: 'A',
                        text: 'Prescrever analgésico e liberar',
                        isSelected: _selectedOption == 0 && !_isWrong,
                        isWrong: _hasAnswered && _selectedOption == 0 && _isWrong,
                        onTap: () => _onOptionTap(0),
                      ),
                      SizedBox(height: r.spacingMD),
                      MultipleChoiceOption(
                        letter: 'B',
                        text: 'Medir pressão arterial corretamente',
                        isSelected: _selectedOption == 1,
                        isCorrect: _selectedOption == 1 && _hasAnswered,
                        isWrong: false,
                        onTap: () => _onOptionTap(1),
                      ),
                      SizedBox(height: r.spacingMD),
                      MultipleChoiceOption(
                        letter: 'C',
                        text: 'Solicitar tomografia de crânio',
                        isSelected: _selectedOption == 2 && !_isWrong,
                        isWrong: _hasAnswered && _selectedOption == 2 && _isWrong,
                        onTap: () => _onOptionTap(2),
                      ),
                      SizedBox(height: r.spacingXXL),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 2,
        interceptAllTaps: true,
        onItemTap: (index) async {
          if (index != 2) await _handleExitSimulation(targetNavIndex: index);
        },
      ),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),
    );
  }

  void _onOptionTap(int index) {
    if (_hasAnswered) return;
    final simState = context.read<SimulationStateProvider>();
    final isCorrect = index == _correctIndex;
    setState(() {
      _selectedOption = index;
      _hasAnswered = true;
      _isWrong = !isCorrect;
    });
    if (isCorrect) {
      _showDrAxonTipPopup(
        tip: _drAxonTipCorrect,
        isCorrect: true,
        onContinue: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimulationBloodPressureScreen(
                patientName: widget.patientName,
                patientAge: widget.patientAge,
              ),
            ),
          );
        },
      );
    } else {
      simState.decrementLife();
      final whyWrong = index == 0 ? _whyWrongA : _whyWrongC;
      _showDrAxonTipPopup(
        tip: '$_drAxonTipWrong\n\nPor que está errado: $whyWrong',
        isCorrect: false,
        correctAnswerLabel: 'B',
        correctAnswerText: 'Medir pressão arterial corretamente',
        onContinue: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimulationBloodPressureScreen(
                patientName: widget.patientName,
                patientAge: widget.patientAge,
              ),
            ),
          );
        },
      );
    }
  }

  void _showDrAxonTipPopup({
    required String tip,
    required bool isCorrect,
    required VoidCallback onContinue,
    String? correctAnswerLabel,
    String? correctAnswerText,
  }) {
    final r = Responsive.of(context);
    final showCorrect = !isCorrect && correctAnswerLabel != null && correctAnswerText != null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.radiusLG),
        ),
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.warning_amber_rounded,
              color: isCorrect ? AppColors.darkGreenHeader : AppColors.red,
              size: r.iconLG,
            ),
            SizedBox(width: r.spacingSM),
            Text(
              'Dr. Axon',
              style: r.heading3.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCorrect) ...[
                Container(
                  padding: r.pad(all: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreenHeader.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(r.radiusMD),
                    border: Border.all(color: AppColors.darkGreenHeader.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A resposta correta é: ',
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$correctAnswerLabel - $correctAnswerText',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: r.spacingMD),
              ],
              Text(
                tip,
                style: r.bodyMedium.copyWith(
                  color: AppColors.grayText,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onContinue();
            },
            child: Text(
              isCorrect ? 'Continuar' : 'Prosseguir',
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
