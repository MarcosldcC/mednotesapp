import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import '../screens/choose_plan_screen.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final List<TextEditingController> _controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    5,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 4) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Card bege ocupa 45% da altura da tela
    return screenHeight * 0.45;
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
          // Header verde escuro com onda no topo (~55% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (45% da tela, sempre colado no bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.45,
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
                padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: r.spacingMD),
                    // Linha separadora
                    Center(
                      child: Container(
                        width: r.isz(40, min: 35, max: 45),
                        height: r.s(4, min: 3, max: 5),
                        decoration: BoxDecoration(
                          color: AppColors.darkGreenHeader,
                          borderRadius: BorderRadius.circular(r.r(2)),
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                    // Título
                    Text(
                      'Verificar Conta',
                      style: r.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingMD),
                    // Texto explicativo
                    Text(
                      'Verifique sua caixa de e-mail e insira abaixo o código de confirmação que chegou.',
                      style: r.bodyMedium.copyWith(
                        color: AppColors.grayText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Campos de código (5 dígitos)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return SizedBox(
                          width: r.isz(56, min: 50, max: 62),
                          height: r.h(56, min: 50, max: 62),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: r.heading2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreenHeader,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(r.radiusMD),
                                borderSide: BorderSide(
                                  color: AppColors.mediumGreen,
                                  width: r.s(1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(r.radiusMD),
                                borderSide: BorderSide(
                                  color: AppColors.mediumGreen,
                                  width: r.s(1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(r.radiusMD),
                                borderSide: BorderSide(
                                  color: AppColors.darkGreenHeader,
                                  width: r.s(2, min: 1.5, max: 2.5),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) => _onCodeChanged(index, value),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Link de reenvio
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: r.bodyMedium.copyWith(
                            color: AppColors.grayText,
                          ),
                          children: [
                            const TextSpan(text: 'Não chegou? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Implementar lógica de reenvio
                                },
                                child: Text(
                                  'Clique para reenviar o código',
                                  style: r.link.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Botão Verificar
                    SizedBox(
                      height: r.h(56, min: 50, max: 64),
                      child: ElevatedButton(
                        onPressed: () {
                          final code = _controllers.map((c) => c.text).join();
                          if (code.length == 5) {
                            // Após verificação, navegar para tela de planos
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChoosePlanScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreenHeader,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Verificar',
                          style: r.button,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

