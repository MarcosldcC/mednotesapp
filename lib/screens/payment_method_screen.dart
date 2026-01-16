import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../screens/add_card_screen.dart';
import '../screens/review_data_screen.dart';
import '../screens/payment_success_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedMethod;

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.70;
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
      backgroundColor: AppColors.darkGreenHeader,
      body: Stack(
        children: [
          // Header verde escuro com onda no topo (~30% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (70% da tela, sempre colado no bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: _calculateCardHeight(context),
              decoration: BoxDecoration(
                color: AppColors.creamCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    // Linha separadora
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.darkGreenHeader,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Título
                    Text(
                      'Método de Pagamento',
                      style: AppTextStyles.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Seção Cartão de Crédito ou Débito
                    Text(
                      'Cartão de Crédito ou Débito',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentOption(
                      icon: Icons.credit_card,
                      label: 'Adicionar novo cartão',
                      value: 'card',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCardScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Seção Outros meios de pagamento
                    Text(
                      'Outros meios de pagamento',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentOption(
                      icon: Icons.apple,
                      label: 'Apple Pay',
                      value: 'apple',
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      icon: Icons.account_circle,
                      label: 'Google Pay',
                      value: 'google',
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      icon: Icons.payment,
                      label: 'PayPal',
                      value: 'paypal',
                    ),
                    const SizedBox(height: 32),
                    
                    // Botão Continuar
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _selectedMethod != null
                            ? () {
                                if (_selectedMethod == 'card') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddCardScreen(),
                                    ),
                                  );
                                } else {
                                  // Para outros métodos de pagamento, vai direto para sucesso
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
                          backgroundColor: AppColors.darkGreenHeader,
                          disabledBackgroundColor: AppColors.mediumGreen.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Continuar',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedMethod == value
                ? AppColors.darkGreenHeader
                : AppColors.mediumGreen,
            width: _selectedMethod == value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.darkGreenHeader,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grayText,
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
  }
}
