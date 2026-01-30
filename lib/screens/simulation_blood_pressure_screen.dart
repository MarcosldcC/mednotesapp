import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../widgets/patient_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/simulation_progress_card.dart';
import '../widgets/simulation_chronometer_bar.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../providers/simulation_state_provider.dart';
import 'simulation_classification_screen.dart';
import 'simulation_case_selection_screen.dart';
import 'dashboard_screen.dart';
import 'clinical_algorithms_screen.dart';
import 'on_call_mode_screen.dart';
import 'marketplace_screen.dart';
import 'real_time_health_screen.dart';
import 'profile_menu_screen.dart';

/// Tela de medida de pressão arterial na simulação
class SimulationBloodPressureScreen extends StatefulWidget {
  final String patientName;
  final int patientAge;

  const SimulationBloodPressureScreen({
    super.key,
    required this.patientName,
    required this.patientAge,
  });

  @override
  State<SimulationBloodPressureScreen> createState() =>
      _SimulationBloodPressureScreenState();
}

class _SimulationBloodPressureScreenState
    extends State<SimulationBloodPressureScreen> {
  Future<bool?> _showExitConfirmation(Responsive r) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.radiusLG)),
        title: Text('Sair da simulação?', style: r.heading3.copyWith(color: AppColors.darkGreenHeader, fontWeight: FontWeight.bold)),
        content: Text('Ao sair você perde o progresso e as 3 vidas. Deseja realmente sair?', style: r.bodyMedium.copyWith(color: AppColors.grayText)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancelar', style: r.bodyMedium.copyWith(color: AppColors.grayText))),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Sair', style: r.bodyMedium.copyWith(color: AppColors.red, fontWeight: FontWeight.bold))),
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
      final screen = switch (targetNavIndex) {
        0 => const ClinicalAlgorithmsScreen(),
        1 => const OnCallModeScreen(),
        2 => const DashboardScreen(),
        3 => const MarketplaceScreen(),
        4 => const RealTimeHealthScreen(),
        _ => const SimulationCaseSelectionScreen(),
      };
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => screen), (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SimulationCaseSelectionScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async { if (didPop) return; await _handleExitSimulation(); },
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
                      SimulationChronometerBar(onSairTap: () => _handleExitSimulation()),
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

                      // Seção de medida de pressão arterial
                      Text(
                        'Medida de Pressão Arterial',
                        style: r.heading2.copyWith(
                          color: AppColors.darkGreenHeader,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: r.spacingXL),

                      GlassCard(
                        isDarkBackground: false,
                        padding: r.pad(all: 20),
                        borderRadius: r.radiusMD,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Resultado médio:',
                                    style: r.bodyMedium.copyWith(
                                      color: AppColors.grayText,
                                    ),
                                  ),
                                  SizedBox(height: r.spacingSM),
                                  Text(
                                    '150 / 94 mmHg',
                                    style: r.heading1.copyWith(
                                      color: AppColors.darkGreenHeader,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBulletItem(r, 'Repouso adequado'),
                                  _buildBulletItem(r, 'Técnica correta'),
                                  _buildBulletItem(r, 'Duas medidas'),
                                  _buildBulletItem(r, 'Ambos os braços'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: r.spacingXL),

                      // Botão prosseguir
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SimulationClassificationScreen(
                                  patientName: widget.patientName,
                                  patientAge: widget.patientAge,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreenHeader,
                            foregroundColor: Colors.white,
                            padding: r.pad(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                            ),
                          ),
                          child: Text(
                            'Prosseguir',
                            style: r.button.copyWith(color: Colors.white),
                          ),
                        ),
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

  Widget _buildBulletItem(Responsive r, String text) {
    return Padding(
      padding: r.pad(bottom: r.spacingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: r.bodyMedium.copyWith(
              color: AppColors.darkGreenHeader,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
