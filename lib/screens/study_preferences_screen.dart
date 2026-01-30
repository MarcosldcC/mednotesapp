import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import '../screens/dashboard_screen.dart';

class StudyPreferencesScreen extends StatefulWidget {
  const StudyPreferencesScreen({super.key});

  @override
  State<StudyPreferencesScreen> createState() => _StudyPreferencesScreenState();
}

class _StudyPreferencesScreenState extends State<StudyPreferencesScreen> {
  final List<String> _preferences = [
    'Fluxogramas/algoritmos',
    'Casos clínicos interativos',
    'Flashcards',
  ];

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.60;
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light, // Ícones brancos para fundo verde
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.darkGreenHeader,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
        child: Stack(
          children: [
          // Header verde escuro com onda no topo (~40% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (60% da tela)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.60,
                maxHeight: MediaQuery.of(context).size.height * 0.95,
              ),
              decoration: BoxDecoration(
                color: AppColors.creamCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(r.radiusXXL),
                  topRight: Radius.circular(r.radiusXXL),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: r.s(8, min: 6, max: 10),
                    offset: Offset(0, -r.s(2, min: 1, max: 3)),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: r.pad(vertical: r.spacingLG),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicador de progresso fixo (4 linhas - quarta etapa)
                  Padding(
                    padding: r.pad(top: 16, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: r.isz(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreenHeader,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                        SizedBox(width: r.spacingXS),
                        Container(
                          width: r.isz(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreenHeader,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                        SizedBox(width: r.spacingXS),
                        Container(
                          width: r.isz(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreenHeader,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                        SizedBox(width: r.spacingXS),
                        Container(
                          width: r.isz(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreenHeader,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Conteúdo rolável
                  Padding(
                    padding: r.pad(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: r.spacingSM),
                        // Título
                        Text(
                          'Preferências de Estudo',
                          style: r.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingMD),
                        // Instruções
                        Text(
                          'Arraste por ordem de prioridade, sendo o primeiro o mais preferível.',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.grayText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingXL),
                        
                        // Lista de preferências arrastáveis
                        ..._preferences.asMap().entries.map((entry) {
                          return _buildPreferenceItem(entry.value, entry.key, r);
                        }).toList(),
                        SizedBox(height: r.spacingXL),
                        
                        // Botão Finalizar
                        SizedBox(
                          height: r.h(56, min: 50, max: 64),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreenHeader,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(r.radiusMD),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Finalizar',
                              style: r.button.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                      ],
                    ),
                  ),
                ],
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(String preference, int index, Responsive r) {
    final orderNumber = index + 1; // Ordem começa em 1
    return Container(
      key: ValueKey('preference_$index'),
      margin: EdgeInsets.only(bottom: r.spacingMD),
      padding: r.pad(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusMD),
        border: Border.all(
          color: AppColors.darkGreenHeader,
          width: r.s(1),
        ),
      ),
      child: Row(
        children: [
          // Número da ordem (1, 2, 3)
          Container(
            width: r.isz(32, min: 28, max: 36),
            height: r.isz(32, min: 28, max: 36),
            decoration: BoxDecoration(
              color: AppColors.darkGreenHeader,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$orderNumber',
                style: r.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: r.spacingMD),
          Expanded(
            child: Text(
              preference,
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
              ),
            ),
          ),
          // Botões para reordenar
          if (index > 0)
            IconButton(
              icon: Icon(
                Icons.arrow_upward,
                color: AppColors.darkGreenHeader,
                size: r.iconMD,
              ),
              onPressed: () {
                setState(() {
                  final item = _preferences.removeAt(index);
                  _preferences.insert(index - 1, item);
                });
              },
            ),
          if (index < _preferences.length - 1)
            IconButton(
              icon: Icon(
                Icons.arrow_downward,
                color: AppColors.darkGreenHeader,
                size: r.iconMD,
              ),
              onPressed: () {
                setState(() {
                  final item = _preferences.removeAt(index);
                  _preferences.insert(index + 1, item);
                });
              },
            ),
        ],
      ),
    );
  }
}
