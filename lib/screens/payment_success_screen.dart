import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../screens/profile_selection_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  /// Plano contratado: ex. "Premium Mensal" ou "Premium Anual"
  final String planLabel;
  /// Valor exibido: ex. "R\$ 39,90" ou "R\$ 383,04"
  final String amount;
  /// true = anual, false = mensal
  final bool isAnnual;

  const PaymentSuccessScreen({
    super.key,
    this.planLabel = 'Premium Mensal',
    this.amount = 'R\$ 39,90',
    this.isAnnual = false,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.darkGreenHeader,
      body: SafeArea(
        child: Padding(
          padding: r.pad(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Card central (conteúdo em destaque)
              Container(
                width: double.infinity,
                padding: r.pad(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: AppColors.creamCard,
                  borderRadius: BorderRadius.circular(r.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícone verde de confirmação (sempre visível)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Icon(
                          Icons.check_circle,
                          size: r.isz(80, min: 64, max: 100),
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    // Badge Mensal ou Anual
                    Container(
                      padding: r.pad(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreenHeader.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(r.radiusMD),
                        border: Border.all(
                          color: AppColors.darkGreenHeader.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        widget.isAnnual ? 'Plano Anual' : 'Plano Mensal',
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingLG),
                    // Título Parabéns
                    Text(
                      'Parabéns',
                      style: r.heading1.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingSM),
                    // Subtítulo Pagamento realizado com sucesso
                    Text(
                      'Pagamento realizado com sucesso',
                      style: r.bodyLarge.copyWith(
                        color: AppColors.grayText,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacingXL),
                    // Resumo do plano em faixa verde clara
                    Container(
                      width: double.infinity,
                      padding: r.pad(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreenHeader.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(r.radiusMD),
                        border: Border.all(
                          color: AppColors.darkGreenHeader.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.planLabel,
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: r.spacingXS),
                          Text(
                            widget.amount,
                            style: r.heading2.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Botão Avançar
              SizedBox(
                width: double.infinity,
                height: r.h(56, min: 48, max: 64),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.creamCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.radiusLG),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Avançar',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: r.spacingXXXXL),
            ],
          ),
        ),
      ),
    );
  }
}
