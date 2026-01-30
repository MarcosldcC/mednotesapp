import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import 'add_card_registration_screen.dart';
import 'payment_success_screen.dart';

class PaymentMethodRegistrationScreen extends StatefulWidget {
  const PaymentMethodRegistrationScreen({super.key});

  @override
  State<PaymentMethodRegistrationScreen> createState() => _PaymentMethodRegistrationScreenState();
}

class _PaymentMethodRegistrationScreenState extends State<PaymentMethodRegistrationScreen> {
  String? _selectedMethod;

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.75;
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
      backgroundColor: AppColors.darkGreenHeader,
      body: Stack(
        children: [
          // Header verde escuro com onda no topo (~25% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.75,
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
                    SizedBox(height: r.spacingXXL),
                    
                    // Header com botão voltar e título
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.darkGreenHeader,
                            size: r.iconMD,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Método de Pagamento',
                            style: r.heading2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: r.h(48, min: 40, max: 56)), // Balance do botão voltar
                      ],
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção Cartão de Crédito ou Débito
                    Text(
                      'Cartão de Crédito ou Débito',
                      style: r.heading3.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingLG),
                    _buildPaymentOption(
                      icon: Icons.credit_card_outlined,
                      label: 'Adicionar novo cartão',
                      value: 'card_new',
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção Outros meios de pagamento
                    Text(
                      'Outros meios de pagamento',
                      style: r.heading3.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingLG),
                    _buildPaymentOption(
                      icon: Icons.apple,
                      label: 'Apple Pay',
                      value: 'apple',
                    ),
                    SizedBox(height: r.spacingMD),
                    _buildPaymentOption(
                      icon: Icons.account_circle,
                      label: 'Google Pay',
                      value: 'google',
                    ),
                    SizedBox(height: r.spacingMD),
                    _buildPaymentOption(
                      icon: Icons.payment,
                      label: 'PayPal',
                      value: 'paypal',
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Botão Próximo
                    SizedBox(
                      height: r.h(56, min: 48, max: 64),
                      child: ElevatedButton(
                        onPressed: _canProceed
                            ? () {
                                if (_selectedMethod == 'card_new') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddCardRegistrationScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PaymentSuccessScreen(),
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canProceed
                              ? AppColors.darkGreenHeader
                              : AppColors.grayLight,
                          foregroundColor: _canProceed ? Colors.white : AppColors.grayText,
                          disabledBackgroundColor: AppColors.grayLight,
                          disabledForegroundColor: AppColors.grayText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusLG),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Próximo',
                          style: r.bodyMedium.copyWith(
                            color: _canProceed ? Colors.white : AppColors.grayText,
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
          ),
        ],
      ),
    );
  }

  bool get _canProceed => _selectedMethod != null;

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        final selected = _selectedMethod == value;
        return InkWell(
          onTap: onTap ?? () {
            setState(() {
              _selectedMethod = value;
            });
          },
          borderRadius: BorderRadius.circular(r.radiusMD),
          child: Container(
            padding: r.pad(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.radiusMD),
              border: Border.all(
                color: selected ? AppColors.darkGreenHeader : AppColors.mediumGreen,
                width: selected ? r.s(2) : r.s(1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.darkGreenHeader,
                  size: r.iconMD,
                ),
                SizedBox(width: r.spacingLG),
                Expanded(
                  child: Text(
                    label,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                  ),
                ),
                Radio<String>(
                  value: value,
                  groupValue: _selectedMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMethod = newValue;
                    });
                  },
                  activeColor: AppColors.darkGreenHeader,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
