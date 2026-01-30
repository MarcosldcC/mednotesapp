import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../design/responsive.dart';
import '../screens/verify_account_screen.dart';
import '../screens/login_screen.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  static const int _minPasswordLength = 8;
  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'[0-9]');
  static final RegExp _hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`~]');

  bool _passwordHasMinLength(String s) => s.length >= _minPasswordLength;
  bool _passwordHasUppercase(String s) => _hasUppercase.hasMatch(s);
  bool _passwordHasLowercase(String s) => _hasLowercase.hasMatch(s);
  bool _passwordHasDigit(String s) => _hasDigit.hasMatch(s);
  bool _passwordHasSpecial(String s) => _hasSpecial.hasMatch(s);
  bool _passwordMeetsAll(String s) =>
      _passwordHasMinLength(s) &&
      _passwordHasUppercase(s) &&
      _passwordHasLowercase(s) &&
      _passwordHasDigit(s) &&
      _passwordHasSpecial(s);
  
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Card bege ocupa 80% da altura da tela
    return screenHeight * 0.80;
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
          // Header verde escuro com onda no topo (~20% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (altura base 632px, responsivo)
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
                  // Limita o arrasto para baixo (não permite arrastar para cima além do bottom)
                  _dragOffset = math.min(0, details.primaryDelta!);
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
                
                // Se arrastar para baixo com velocidade suficiente, volta para tela anterior
                if (details.primaryVelocity != null && details.primaryVelocity! > 500) {
                  // Anima o card para fora da tela
                  _animationController.forward().then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  // Volta suavemente para a posição original
                  setState(() {
                    _dragOffset = 0.0;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.80,
                  maxHeight: MediaQuery.of(context).size.height * 0.95,
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
                  padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                          'Faça login ou registre-se em segundos',
                          style: r.heading2.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingXL),
                        
                        // Campo Nome
                        Text(
                          'Nome',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                        _buildTextField(
                          controller: _firstNameController,
                          hintText: 'Digite seu nome',
                        ),
                        SizedBox(height: r.spacingLG),
                        
                        // Campo Sobrenome
                        Text(
                          'Sobrenome',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                        _buildTextField(
                          controller: _lastNameController,
                          hintText: 'Digite seu sobrenome',
                        ),
                        SizedBox(height: r.spacingLG),
                        
                        // Campo E-mail
                        Text(
                          'E-mail',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Digite seu e-mail',
                          keyboardType: TextInputType.emailAddress,
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
                        _buildPasswordField(
                          controller: _passwordController,
                          hintText: 'Digite sua senha',
                          obscureText: _obscurePassword,
                          onToggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          onChanged: () => setState(() {}),
                        ),
                        SizedBox(height: r.spacingSM),
                        _buildPasswordRequirements(r),
                        SizedBox(height: r.spacingLG),
                        
                        // Campo Repetir Senha
                        Text(
                          'Repetir Senha',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          hintText: 'Digite sua senha novamente',
                          obscureText: _obscureConfirmPassword,
                          onToggle: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        SizedBox(height: r.spacingXXL),
                        
                        // Aceite dos termos
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptedTerms,
                              activeColor: AppColors.darkGreenHeader,
                              onChanged: (value) {
                                setState(() {
                                  _acceptedTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Li e aceito os ',
                                    style: r.bodySmall.copyWith(
                                      color: AppColors.darkGreenHeader,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showTermsPdfModal();
                                    },
                                    child: Text(
                                      'Termos de Uso',
                                      style: r.bodySmall.copyWith(
                                        color: AppColors.darkGreenHeader,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: r.spacingLG),

                        // Botão Criar Conta
                        SizedBox(
                          height: r.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_acceptedTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Você precisa aceitar os Termos de Uso.'),
                                  ),
                                );
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const VerifyAccountScreen(),
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
                              'Criar Conta',
                              style: r.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: r.spacingMD),
                        
                        // Link para login
                        Padding(
                          padding: r.pad(bottom: 16),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
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
                                    const TextSpan(text: 'ou faça o '),
                                    TextSpan(
                                      text: 'Login',
                                      style: r.bodyLarge.copyWith(
                                        color: AppColors.darkGreenHeader,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: ', se já tiver conta.'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    final r = Responsive.of(context);
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: r.bodyMedium.copyWith(
          color: AppColors.grayText,
        ),
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
      style: r.bodyMedium.copyWith(
        color: AppColors.darkGreenHeader,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordRequirements(Responsive r) {
    final s = _passwordController.text;
    final items = [
      (_passwordHasMinLength(s), 'Pelo menos $_minPasswordLength caracteres'),
      (_passwordHasUppercase(s), 'Uma letra maiúscula'),
      (_passwordHasLowercase(s), 'Uma letra minúscula'),
      (_passwordHasDigit(s), 'Um número'),
      (_passwordHasSpecial(s), 'Um caractere especial (!@#\$%^&* etc.)'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) {
        final ok = e.$1;
        return Padding(
          padding: r.pad(bottom: r.spacingXS),
          child: Row(
            children: [
              Icon(
                ok ? Icons.check_circle : Icons.circle_outlined,
                size: r.isz(18, min: 16, max: 20),
                color: ok ? AppColors.darkGreenHeader : AppColors.grayText,
              ),
              SizedBox(width: r.spacingSM),
              Expanded(
                child: Text(
                  e.$2,
                  style: r.bodySmall.copyWith(
                    color: ok ? AppColors.darkGreenHeader : AppColors.grayText,
                    fontWeight: ok ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
    VoidCallback? onChanged,
  }) {
    final r = Responsive.of(context);
    
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (_) => onChanged?.call(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: r.bodyMedium.copyWith(
          color: AppColors.grayText,
        ),
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
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.darkGreenHeader,
            size: r.iconMD,
          ),
          onPressed: onToggle,
        ),
      ),
      style: r.bodyMedium.copyWith(
        color: AppColors.darkGreenHeader,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        if (controller == _passwordController) {
          if (!_passwordHasMinLength(value)) {
            return 'Mínimo $_minPasswordLength caracteres';
          }
          if (!_passwordHasUppercase(value)) {
            return 'Inclua uma letra maiúscula';
          }
          if (!_passwordHasLowercase(value)) {
            return 'Inclua uma letra minúscula';
          }
          if (!_passwordHasDigit(value)) {
            return 'Inclua um número';
          }
          if (!_passwordHasSpecial(value)) {
            return 'Inclua um caractere especial';
          }
        }
        if (controller == _confirmPasswordController) {
          if (value != _passwordController.text) {
            return 'As senhas não coincidem';
          }
        }
        return null;
      },
    );
  }

  Future<void> _showTermsPdfModal() async {
    final r = Responsive.of(context);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Termos de Uso',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Em breve você encontrará aqui os termos completos de uso do aplicativo.',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          );
        },
      ),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: r.pad(horizontal: 16, vertical: 16),
          child: SizedBox(
            height: r.h(520, min: 420, max: 640),
            child: Column(
              children: [
                Expanded(
                  child: PdfPreview(
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    build: (format) => doc.save(),
                  ),
                ),
                Padding(
                  padding: r.pad(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreenHeader,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(r.radiusMD),
                        ),
                      ),
                      child: Text(
                        'Fechar',
                        style: r.button.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
