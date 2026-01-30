import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../design/responsive.dart';
import '../screens/login_screen.dart';

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
    final r = Responsive.of(context);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light, // Ícones brancos para fundo verde
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
              child: const SizedBox.expand(),
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
                        builder: (context) => const LoginScreen(),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMedicaImage(r),
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.creamBackground,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: r.s(8),
                            offset: Offset(0, -r.s(2)),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: r.pad(
                          horizontal: 24,
                          top: r.spacingLG,
                          bottom: r.spacingLG,
                        ),
                        child: _buildWelcomeContent(context, r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildWelcomeContent(BuildContext context, Responsive r) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: r.spacingLG),
      // Linha separadora
      Center(
        child: Container(
          width: r.h(40, min: 32, max: 48),
          height: r.s(4, min: 3, max: 5),
          decoration: BoxDecoration(
            color: AppColors.darkGreenHeader,
            borderRadius: BorderRadius.circular(r.r(2)),
          ),
        ),
      ),
      SizedBox(height: r.spacingXL),
      // Título "Seja bem-vindo ao"
      Text(
        'Seja bem-vindo ao',
        style: GoogleFonts.montserrat(
          textStyle: r.heading2,
          color: AppColors.darkGreenHeader,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
      // Título "MedNotes"
      Text(
        'MedNotes',
        style: GoogleFonts.montserrat(
          textStyle: r.heading1,
          color: AppColors.darkGreenHeader,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: r.spacingLG),
      // Texto descritivo
      Text(
        'Protocolos clínicos baseados em evidências, organizados para decisões rápidas, seguras e confiáveis.',
        style: r.bodyLarge.copyWith(
          color: AppColors.grayText,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: r.spacingXXXXL),
      // Botão "Vamos Começar"
      SizedBox(
        width: double.infinity,
        height: r.buttonHeight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreenButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r.radiusLG),
            ),
            elevation: r.s(2, min: 1, max: 4),
            shadowColor: Colors.black.withOpacity(0.12),
          ),
          child: Text(
            'Vamos Começar',
            style: r.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(height: r.spacingXS),
    ],
  );
}

Widget _buildMedicaImage(Responsive r) {
  return Center(
    child: SizedBox(
      width: math.min(
        r.width * 0.5,
        r.h(320, min: 200, max: 360),
      ),
      child: Image.asset(
        'assets/images/medica.png',
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
            ),
            child: Icon(
              Icons.person,
              size: r.h(160, min: 110, max: 200),
              color: Colors.white70,
            ),
          );
        },
      ),
    ),
  );
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
