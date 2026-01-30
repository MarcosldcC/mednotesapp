import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import '../screens/interest_areas_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? _selectedUF;

  final List<String> _ufs = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

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
          
          // Card bege na parte inferior (50% da tela)
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
                  // Indicador de progresso fixo (4 linhas - segunda etapa)
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
                            color: AppColors.grayLight,
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
                  // Conteúdo rolável
                  Padding(
                    padding: r.pad(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: r.spacingSM),
                        // Título
                        Text(
                          'Onde você atua/estuda?',
                          style: r.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingMD),
                        // Subtítulo
                        Text(
                          'Selecione sua UF',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.grayText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingXL),
                        
                        // Campo dropdown
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(r.radiusMD),
                            border: Border.all(
                              color: AppColors.darkGreenHeader,
                              width: r.s(1),
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedUF,
                            decoration: InputDecoration(
                              hintText: 'Selecionar',
                              hintStyle: r.bodyMedium.copyWith(
                                color: AppColors.grayText,
                              ),
                              border: InputBorder.none,
                              contentPadding: r.pad(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.darkGreenHeader,
                                size: r.iconMD,
                              ),
                            ),
                            style: r.bodyMedium,
                            items: _ufs.map((uf) {
                              return DropdownMenuItem<String>(
                                value: uf,
                                child: Text(
                                  uf,
                                  style: r.bodyMedium.copyWith(
                                    color: AppColors.darkGreenHeader,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedUF = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: r.spacingXL),
                        
                        // Botão Próximo
                        SizedBox(
                          height: r.h(56, min: 50, max: 64),
                          child: ElevatedButton(
                            onPressed: _selectedUF != null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const InterestAreasScreen(),
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
                              disabledBackgroundColor: AppColors.grayLight,
                              disabledForegroundColor: AppColors.grayText,
                            ),
                            child: Text(
                              'Próximo',
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
}
