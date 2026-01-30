import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import 'change_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  
  const VerifyCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Verificar se todos os campos estão preenchidos
    if (_codeControllers.every((controller) => controller.text.isNotEmpty)) {
      _verifyCode();
    }
  }

  void _verifyCode() {
    final code = _codeControllers.map((c) => c.text).join();
    
    if (code.length == 6) {
      // Aqui você validaria o código com o backend
      // Por enquanto, vamos apenas navegar para a tela de trocar senha
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.creamCard,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: r.pad(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: r.spacingXL),
              
              // Botão voltar
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.darkGreenHeader,
                  size: r.iconMD,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: r.iconMD,
                  minHeight: r.iconMD,
                ),
              ),
              SizedBox(height: r.spacingLG),
              
              // Título
              Text(
                'Verificar Código',
                style: r.heading2.copyWith(
                  color: AppColors.darkGreenHeader,
                ),
              ),
              SizedBox(height: r.spacingMD),
              
              // Descrição
              Text(
                'Enviamos um código de verificação para ${widget.email}. Por favor, insira o código abaixo.',
                style: r.bodyMedium.copyWith(
                  color: AppColors.darkGreenHeader,
                ),
              ),
              SizedBox(height: r.spacingXL),
              
              // Campos de código
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: r.isz(45, min: 40, max: 50),
                    height: r.h(60, min: 55, max: 65),
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: r.heading2.copyWith(
                        color: AppColors.darkGreenHeader,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
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
                            width: r.s(2, min: 1.5, max: 2.5),
                          ),
                        ),
                      ),
                      onChanged: (value) => _onCodeChanged(index, value),
                    ),
                  ),
                ),
              ),
              SizedBox(height: r.spacingXL),
              
              // Botão Reenviar código
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Código reenviado!',
                          style: r.bodyMedium,
                        ),
                        backgroundColor: AppColors.darkGreenHeader,
                      ),
                    );
                  },
                  child: Text(
                    'Reenviar código',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
