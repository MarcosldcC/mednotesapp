import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../screens/payment_success_screen.dart';

class ReviewDataScreen extends StatefulWidget {
  final String cardNumber;
  final String cardName;
  final String expiryDate;

  const ReviewDataScreen({
    super.key,
    required this.cardNumber,
    required this.cardName,
    required this.expiryDate,
  });

  @override
  State<ReviewDataScreen> createState() => _ReviewDataScreenState();
}

class _ReviewDataScreenState extends State<ReviewDataScreen> {
  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.65;
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
          // Header verde escuro com onda no topo (~35% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Premium Mensal',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$39.90',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (65% da tela, sempre colado no bottom)
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
                    const SizedBox(height: 24),
                    // Header com botão voltar e título
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: AppColors.darkGreenHeader,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Revisar Dados',
                            style: AppTextStyles.heading2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Balance do botão voltar
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Informações de vigência
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grayText,
                        ),
                        children: [
                          const TextSpan(text: 'Vigência do Plano: '),
                          TextSpan(
                            text: 'Mensal',
                            style: TextStyle(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: ' Vencimento: '),
                          TextSpan(
                            text: '25',
                            style: TextStyle(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Visualização do cartão
                    _buildCardVisual(),
                    const SizedBox(height: 32),
                    
                    // Título Benefícios
                    Text(
                      'Benefícios do Plano:',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Lista de benefícios em duas colunas
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBenefit('Personalização inteligente de perfil'),
                              _buildBenefit('Análises personalizadas de condutas e estudos'),
                              _buildBenefit('Casos clínicos ilimitados'),
                              _buildBenefit('Recomendações e trilhas adaptadas por IA'),
                              _buildBenefit('Acesso completo ao Marketplace'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBenefit('Gamificação avançada'),
                              _buildBenefit('Chat com IA clínica'),
                              _buildBenefit('Modo Plantão ilimitado'),
                              _buildBenefit('Modo offline'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Botão Próximo
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentSuccessScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreenHeader,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Próximo',
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

  String _formatCardNumber(String number) {
    if (number.isEmpty) return '0000 0000 0000 0000';
    String cleaned = number.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += cleaned[i];
    }
    return formatted;
  }

  String _formatExpiryDate(String date) {
    if (date.isEmpty) return '00/00';
    String cleaned = date.replaceAll('/', '');
    if (cleaned.length >= 2) {
      return '${cleaned.substring(0, 2)}/${cleaned.length > 2 ? cleaned.substring(2) : '00'}';
    }
    return date.padRight(4, '0');
  }

  Widget _buildCardVisual() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _formatCardNumber(widget.cardNumber),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nome',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.cardName.isEmpty ? 'Nome Sob.' : widget.cardName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _formatExpiryDate(widget.expiryDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.credit_card,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.darkGreenHeader,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 12,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
