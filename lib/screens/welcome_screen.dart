import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Fundo verde ocupando toda a tela
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.darkGreenHeader,
            ),
            child: CustomPaint(
              painter: DiagonalPatternPainter(),
              child: Stack(
                children: [
                  // Imagem da médica - responsiva com tamanho legal
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.35, // Parte inferior da médica no topo do card (35% é a nova altura do card)
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: math.min(math.max(MediaQuery.of(context).size.width * 0.65, 300.0), 450.0), // 65% da largura, min 300px, max 450px
                        child: Image.asset(
                          'assets/images/medica.png',
                          fit: BoxFit.contain, // Mostra a imagem completa sem cortar
                          alignment: Alignment.bottomCenter, // Alinha pela parte inferior
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 200,
                                color: Colors.white70,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Card bege fixado na parte inferior (sobrepondo a médica)
          AnimatedPositioned(
            duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: _dragOffset,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragStart: (details) {
                setState(() {
                  _isDragging = true;
                });
              },
              onVerticalDragUpdate: (details) {
                setState(() {
                  // Limita o arrasto para cima (não permite arrastar para baixo além do bottom)
                  _dragOffset = math.max(0, -details.primaryDelta!);
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
                
                // Se arrastar para cima com velocidade suficiente, vai para próxima tela
                if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
                  // Anima o card para fora da tela
                  _animationController.forward().then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  });
                } else {
                  // Volta suavemente para a posição original
                  setState(() {
                    _dragOffset = 0.0;
                  });
                }
              },
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35, // Card ocupa 35% da altura da tela
                  decoration: BoxDecoration(
                    color: AppColors.creamBackground,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      const SizedBox(height: 16),
                      // Linha separadora
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.darkGreenHeader,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Título "Seja bem-vindo ao"
                      Text(
                        'Seja bem-vindo ao',
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Título "MedNotes"
                      Text(
                        'MedNotes',
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Texto descritivo
                      Text(
                        'Protocolos clínicos baseados em evidências, organizados para decisões rápidas, seguras e confiáveis.',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.grayText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Botão "Vamos Começar"
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreenButton,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Vamos Começar',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Espaço menor após o botão
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkGreenHeader.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 25.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
