import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import '../screens/study_preferences_screen.dart';

class InterestAreasScreen extends StatefulWidget {
  const InterestAreasScreen({super.key});

  @override
  State<InterestAreasScreen> createState() => _InterestAreasScreenState();
}

class _InterestAreasScreenState extends State<InterestAreasScreen> {
  final Set<String> _selectedAreas = {};

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.65;
  }

  final List<String> _areas = [
    'Clínica Médica',
    'Medicina de Família e Comunidade (MFC)',
    'Pediatria',
    'Ginecologia e Obstetrícia',
    'Medicina Intensiva',
    'Geriatria',
    'Infectologia',
    'Cirurgia Geral',
    'Ortopedia e Traumatologia',
    'Anestesiologia',
  ];

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
          // Header verde escuro com onda no topo (~35% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (65% da tela, sempre colado no bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.65,
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
                  // Indicador de progresso fixo (4 linhas - terceira etapa)
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
                            color: AppColors.grayLight,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Conteúdo
                  Padding(
                    padding: r.pad(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: r.spacingSM),
                        // Título
                        Text(
                          'Áreas de interesse',
                          style: r.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingMD),
                        // Subtítulo
                        Text(
                          'Selecione uma ou mais especialidades.',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.grayText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingXL),
                        
                        // Lista de áreas
                        ..._areas.map((area) => Padding(
                          padding: EdgeInsets.only(bottom: r.spacingMD),
                          child: _buildAreaChip(area, r),
                        )),
                        SizedBox(height: r.spacingXL),
                        
                        // Botão Finalizar
                        SizedBox(
                          height: r.h(56, min: 50, max: 64),
                          child: ElevatedButton(
                            onPressed: _selectedAreas.isNotEmpty
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const StudyPreferencesScreen(),
                                      ),
                                    );
                                  }
                                : null,
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

  Widget _buildAreaChip(String area, Responsive r) {
    final isSelected = _selectedAreas.contains(area);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAreas.remove(area);
          } else {
            _selectedAreas.add(area);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: r.pad(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.radiusXXL), // Mais arredondado (pill shape)
          border: Border.all(
            color: isSelected
                ? AppColors.darkGreenHeader
                : AppColors.mediumGreen.withOpacity(0.3),
            width: r.s(isSelected ? 2 : 1, min: 1, max: 2.5),
          ),
        ),
        child: Text(
          area,
          style: r.bodyMedium.copyWith(
            color: AppColors.darkGreenHeader,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
