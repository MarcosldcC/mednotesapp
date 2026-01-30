import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../design/responsive.dart';
import '../screens/location_selection_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  String? _selectedProfile;

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.50;
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
      body: Stack(
        children: [
          // Header verde escuro com onda no topo (~50% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (50% da tela, sempre colado no bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.50,
                maxHeight: MediaQuery.of(context).size.height * 0.90,
              ),
              decoration: BoxDecoration(
                color: AppColors.creamCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(r.r(45, min: 35, max: 50)),
                  topRight: Radius.circular(r.r(45, min: 35, max: 50)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: r.s(8),
                    offset: Offset(0, -r.s(2)),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: r.pad(vertical: r.spacingLG),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicador de progresso fixo (4 linhas - primeira etapa)
                  Padding(
                    padding: r.pad(top: 16, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: r.s(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreenHeader,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                        SizedBox(width: r.spacingXS),
                        Container(
                          width: r.s(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.grayLight,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                        SizedBox(width: r.spacingXS),
                        Container(
                          width: r.s(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.grayLight,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                        SizedBox(width: r.spacingXS),
                        Container(
                          width: r.s(24, min: 20, max: 28),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.grayLight,
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
                          'Qual é você hoje?',
                          style: r.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingLG),
                        // Subtítulo
                        Text(
                          'Selecione a opção que melhor descreve você',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.grayText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingXXXXL),
                        
                        // Opções de perfil
                        _buildProfileOption('Estudante de Medicina', 'student'),
                        SizedBox(height: r.spacingLG),
                        _buildProfileOption('Interno (5° - 6° Ano)', 'intern'),
                        SizedBox(height: r.spacingLG),
                        _buildProfileOption('Residente (R1 - R2)', 'resident'),
                        SizedBox(height: r.spacingLG),
                        _buildProfileOption('Médico Generalista / APS', 'doctor'),
                        SizedBox(height: r.spacingXXXXL),
                        
                        // Botão Próximo
                        SizedBox(
                          height: r.h(56, min: 48, max: 64),
                          child: ElevatedButton(
                            onPressed: _selectedProfile != null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LocationSelectionScreen(),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreenHeader,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(r.radiusLG),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Próximo',
                              style: r.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: r.spacingXXXXL),
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
    );
  }

  Widget _buildProfileOption(String label, String value) {
    final r = Responsive.of(context);
    final isSelected = _selectedProfile == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProfile = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: r.pad(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkGreenHeader : Colors.white,
          borderRadius: BorderRadius.circular(r.radiusLG),
          border: Border.all(
            color: isSelected
                ? AppColors.darkGreenHeader
                : AppColors.mediumGreen.withOpacity(0.3),
            width: isSelected ? r.s(2) : r.s(1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.darkGreenHeader.withOpacity(0.3),
                    blurRadius: r.s(8),
                    offset: Offset(0, r.s(4)),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: r.bodyLarge.copyWith(
                  color: isSelected ? Colors.white : AppColors.darkGreenHeader,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: r.isz(24, min: 20, max: 28),
                height: r.isz(24, min: 20, max: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: r.isz(16, min: 14, max: 20),
                  color: AppColors.darkGreenHeader,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
