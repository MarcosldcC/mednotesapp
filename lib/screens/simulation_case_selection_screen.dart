import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../widgets/patient_card.dart';
import '../widgets/simulation_progress_card.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../providers/simulation_state_provider.dart';
import 'simulation_triage_screen.dart';
import 'profile_menu_screen.dart';

/// Tela de seleção de caso de simulação
class SimulationCaseSelectionScreen extends StatefulWidget {
  const SimulationCaseSelectionScreen({super.key});

  @override
  State<SimulationCaseSelectionScreen> createState() =>
      _SimulationCaseSelectionScreenState();
}

class _SimulationCaseSelectionScreenState
    extends State<SimulationCaseSelectionScreen> {
  // Dados mock de pacientes
  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'João Silva',
      'age': 52,
      'symptom':
          'Dor de cabeça persistente há 3 dias e histórico de pressão alta sem tratamento regular.',
      'previousHistory':
          'Hipertensão arterial não tratada, sobrepeso, sedentarismo e pai faleceu de infarto aos 55 anos.',
      'usualMedication': 'Apenas 1-2 vezes AINE para dores',
      'imagePath': null,
    },
    {
      'name': 'Luana Rocha',
      'age': 32,
      'symptom':
          'Dor de cabeça persistente há 3 dias e histórico de pressão alta sem tratamento regular.',
      'previousHistory':
          'Hipertensão arterial não tratada, sobrepeso, sedentarismo e pai faleceu de infarto aos 55 anos.',
      'usualMedication': 'Apenas 1-2 vezes AINE para dores',
      'imagePath': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
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
                      SizedBox(height: r.spacingXXL),

                      // Informações de progresso/tier
                      _buildProgressCard(r),
                      SizedBox(height: r.spacingXL),

                      // Lista de pacientes (ocultar/exibir persiste entre telas)
                      ..._patients.map((patient) {
                        final simState = context.watch<SimulationStateProvider>();
                        final isHidden = simState.isCaseHidden(patient['name'] as String);
                        return Padding(
                          padding: r.pad(bottom: r.spacingXL),
                          child: isHidden
                              ? _buildHiddenCaseBar(r, patient, simState)
                              : PatientCard(
                                  patientName: patient['name'],
                                  patientAge: patient['age'],
                                  symptom: patient['symptom'],
                                  previousHistory: patient['previousHistory'],
                                  usualMedication: patient['usualMedication'],
                                  patientImagePath: patient['imagePath'],
                                  isCollapsed: false,
                                  onToggleCollapse: () => simState.toggleCaseVisibility(patient['name'] as String),
                                  onStartSimulation: () {
                                    simState.resetLives();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SimulationTriageScreen(
                                          patientName: patient['name'],
                                          patientAge: patient['age'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        );
                      }),
                      SizedBox(height: r.spacingXXL),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProgressCard(Responsive r) {
    final simState = context.watch<SimulationStateProvider>();
    return SimulationProgressCard(
      lives: simState.lives,
      pointsReward: 10,
    );
  }

  Widget _buildHiddenCaseBar(Responsive r, Map<String, dynamic> patient, SimulationStateProvider simState) {
    return Container(
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(r.radiusMD),
        border: Border.all(color: AppColors.darkGreenHeader.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: AppColors.darkGreenHeader, size: r.iconMD),
          SizedBox(width: r.spacingMD),
          Expanded(
            child: Text(
              'Caso ${patient['name']}',
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => simState.toggleCaseVisibility(patient['name'] as String),
            child: Text(
              'Exibir',
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
