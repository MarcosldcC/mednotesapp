import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/decision_flowchart.dart';
import '../widgets/flashcard_widget.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../providers/recent_protocols_provider.dart';
import 'simulation_case_selection_screen.dart';
import 'profile_menu_screen.dart';

/// Tela de detalhe do algoritmo clínico com fluxograma
class AlgorithmDetailScreen extends StatefulWidget {
  final String algorithmTitle;

  const AlgorithmDetailScreen({
    super.key,
    required this.algorithmTitle,
  });

  @override
  State<AlgorithmDetailScreen> createState() => _AlgorithmDetailScreenState();
}

class _AlgorithmDetailScreenState extends State<AlgorithmDetailScreen> {
  final Map<int, bool> _flashcardAnswers = {};

  // Dados mock de flashcards
  final List<Map<String, String>> _flashcards = [
    {
      'question': 'Paciente chega ao pronto atendimento com dor torácica. Qual a primeira abordagem?',
      'answer': 'Avaliar estabilidade hemodinâmica (ABC), sinais vitais, nível de consciência e iniciar monitorização cardíaca + oxigênio se necessário.',
    },
    {
      'question': 'Quais são os principais diagnósticos diferenciais em dor torácica aguda?',
      'answer': 'IAM, TEP (Tromboembolismo Pulmonar) e disseção aórtica devem sempre ser considerados em dor torácica aguda.',
    },
    {
      'question': 'Qual o tempo máximo para realização do ECG em paciente com dor torácica?',
      'answer': 'O ECG deve ser realizado em até 10 minutos após a chegada do paciente ao pronto atendimento.',
    },
  ];

  /// Preparado para futuramente receber PDF do backend.
  void _onExportPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Exportação em desenvolvimento. Em breve você poderá baixar o PDF.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSave() {
    Provider.of<RecentProtocolsProvider>(context, listen: false)
        .add(widget.algorithmTitle);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Salvo. Aparecerá em Protocolos recentes no início.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
                            child: Text(
                              widget.algorithmTitle,
                              style: r.heading1.copyWith(
                                color: AppColors.darkGreenHeader,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXXL),

                      // Alerta clínico (sem borda)
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: r.pad(all: 16),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.darkGreenHeader,
                                size: r.iconLG,
                              ),
                              SizedBox(width: r.spacingMD),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Alerta Clínico',
                                      style: r.heading3.copyWith(
                                        color: AppColors.darkGreenHeader,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: r.spacingXS),
                                    Text(
                                      'Sempre considerar IAM, TEP e disseção aórtica em dor torácica aguda. Avaliação imediata necessária.',
                                      style: r.bodyMedium.copyWith(
                                        color: AppColors.grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: r.spacingXL),

                      // Botões de ação (lado a lado, responsivo)
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              r,
                              'Exportar PDF',
                              Icons.download,
                              _onExportPdf,
                            ),
                          ),
                          SizedBox(width: r.spacingMD),
                          Expanded(
                            child: _buildActionButton(
                              r,
                              'Salvar',
                              Icons.save,
                              _onSave,
                            ),
                          ),
                          SizedBox(width: r.spacingMD),
                          Expanded(
                            child: _buildActionButton(
                              r,
                              'Simular Caso',
                              Icons.play_circle_outline,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SimulationCaseSelectionScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXXL),

                      // Fluxograma de decisão
                      SizedBox(
                        width: double.infinity,
                        child: DecisionFlowchart(
                        steps: [
                          const FlowchartStep(
                            number: 1,
                            title: 'Paciente com dor torácica',
                            backgroundColor: AppColors.darkGreenHeader,
                            textColor: Colors.white,
                          ),
                          FlowchartStep(
                            number: 2,
                            title: 'Avaliação Inicial',
                            items: [
                              'Avaliação Inicial',
                              'ECG em até 10 minutos.',
                              'Oximetria',
                              'Acesso venoso',
                            ],
                          ),
                        ],
                        branches: const [
                          FlowchartBranch(
                            title: 'Sinais de Alarme?',
                            items: [
                              'Supra ST',
                              'Instabilidade',
                              'Dispneia Grande',
                            ],
                          ),
                          FlowchartBranch(
                            title: 'Estável?',
                            items: ['Investigação complementar'],
                          ),
                        ],
                        ),
                      ),
                      SizedBox(height: r.spacingXL),

                      // Passo final
                      SizedBox(
                        width: double.infinity,
                        child: GlassCard(
                          isDarkBackground: false,
                          padding: r.pad(all: 16),
                          borderRadius: r.radiusMD,
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3. Conduta',
                              style: r.heading3.copyWith(
                                color: AppColors.darkGreenHeader,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: r.spacingMD),
                            _buildBulletItem(r, 'AAS 200mg VO'),
                            _buildBulletItem(r, 'Clopidogrel 300mg VO'),
                            _buildBulletItem(r, 'Heraprina conforme protocolo'),
                            _buildBulletItem(r, 'Ativar hermodinâmica se IAMCSST'),
                          ],
                        ),
                        ),
                      ),
                      SizedBox(height: r.spacingXXL),

                      // Seção de flashcards
                      if (_flashcards.isNotEmpty) ...[
                        Text(
                          'Flashcards',
                          style: r.heading2.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: r.spacingXL),
                        ..._flashcards.asMap().entries.map((entry) {
                          final index = entry.key;
                          final flashcard = entry.value;
                          return Padding(
                            padding: r.pad(bottom: r.spacingXL),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _flashcardAnswers[index] = !(_flashcardAnswers[index] ?? false);
                                });
                              },
                              child: FlashcardWidget(
                                question: flashcard['question']!,
                                answer: flashcard['answer']!,
                                showAnswer: _flashcardAnswers[index] ?? false,
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: r.spacingXXL),
                      ],
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

  Widget _buildActionButton(
    Responsive r,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreenHeader,
          foregroundColor: Colors.white,
          padding: r.pad(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.radiusMD),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: r.iconMD),
            SizedBox(width: r.spacingSM),
            Flexible(
              child: Text(
                label,
                style: r.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
