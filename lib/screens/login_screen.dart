import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    
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
            child: const SizedBox.expand(),
          ),
          
          // Card bege fixado na parte inferior (sobrepondo a médica)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMedicaImage(r),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.creamForm,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: r.s(8),
                          offset: Offset(0, -r.s(2)),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            // Título
                            Text(
                              'Entre na sua conta',
                              style: r.heading2.copyWith(
                                color: settings.highContrast
                                    ? Colors.black
                                    : AppColors.darkGreenHeader,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: r.spacingXL),
                        
                        // Campo E-mail
                        Text(
                          'E-mail',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Digite seu e-mail',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              borderSide: BorderSide(
                                color: AppColors.darkGreenHeader,
                                width: r.s(1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              borderSide: BorderSide(
                                color: AppColors.darkGreenHeader,
                                width: r.s(1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              borderSide: BorderSide(
                                color: AppColors.darkGreenHeader,
                                width: r.s(2),
                              ),
                            ),
                            contentPadding: r.pad(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo é obrigatório';
                            }
                            if (!value.contains('@')) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: r.spacingLG),
                        
                        // Campo Senha
                        Text(
                          'Senha',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Digite sua senha',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              borderSide: BorderSide(
                                color: AppColors.darkGreenHeader,
                                width: r.s(1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              borderSide: BorderSide(
                                color: AppColors.darkGreenHeader,
                                width: r.s(1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              borderSide: BorderSide(
                                color: AppColors.darkGreenHeader,
                                width: r.s(2),
                              ),
                            ),
                            contentPadding: r.pad(horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.darkGreenHeader,
                                size: r.iconMD,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo é obrigatório';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: r.spacingXXL),
                        
                        // Botão Entrar
                        SizedBox(
                          height: r.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Navega diretamente para o dashboard
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreenHeader,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(r.radiusLG),
                              ),
                              elevation: r.s(2, min: 1, max: 4),
                              shadowColor: Colors.black.withOpacity(0.12),
                            ),
                            child: Text(
                              'Entrar',
                              style: r.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: r.spacingXXL),
                        
                        // Link para criar conta
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: r.bodyMedium.copyWith(
                                  color: AppColors.darkGreenHeader,
                                ),
                                children: [
                                  const TextSpan(text: 'ou '),
                                  TextSpan(
                                    text: 'Crie uma Conta',
                                    style: r.bodyLarge.copyWith(
                                      color: AppColors.darkGreenHeader,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: r.spacingSM), // Espaço menor após o link
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}

Widget _buildMedicaImage(Responsive r) {
  return Center(
    child: SizedBox(
      width: math.min(
        r.width * 0.5,
        r.h(350, min: 250, max: 380),
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
              size: r.h(180, min: 120, max: 220),
              color: Colors.white70,
            ),
          );
        },
      ),
    ),
  );
}

class DecorativePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.7,
      0,
      size.height,
    );
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
