import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../screens/dashboard_screen.dart';

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
    'APS',
    'Emergência',
    'Pediatria',
    'Cirurgia',
    'Cardiologia',
    'Neurologia',
    'Ginecologia',
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.darkGreenHeader,
      body: Stack(
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
              height: _calculateCardHeight(context),
              decoration: BoxDecoration(
                color: AppColors.creamCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    // Linha separadora
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.darkGreenHeader,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Título
                    Text(
                      'Áreas de interesse',
                      style: AppTextStyles.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Subtítulo
                    Text(
                      'Selecione uma ou mais áreas clínicas',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grayText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Lista de áreas
                    ..._areas.map((area) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildAreaChip(area),
                    )),
                    const SizedBox(height: 32),
                    
                    // Botão Finalizar
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _selectedAreas.isNotEmpty
                            ? () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardScreen(),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreenHeader,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Finalizar',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaChip(String area) {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.darkGreenHeader
                : AppColors.mediumGreen,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          area,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.darkGreenHeader,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
