import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import '../screens/payment_success_screen.dart';

class ReviewDataScreen extends StatefulWidget {
  final String cardNumber;
  final String cardName;
  final String expiryDate;
  /// Ex.: "Premium Mensal" ou "Premium Anual"
  final String planLabel;
  /// Ex.: "R\$ 39,90" ou "R\$ 383,04"
  final String amount;
  final bool isAnnual;

  const ReviewDataScreen({
    super.key,
    required this.cardNumber,
    required this.cardName,
    required this.expiryDate,
    this.planLabel = 'Premium Mensal',
    this.amount = 'R\$ 39,90',
    this.isAnnual = false,
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
                child: Center(
                  child: Container(
                    padding: r.pad(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(r.radiusMD),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.planLabel,
                          style: r.heading2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: r.spacingSM),
                        Text(
                          widget.amount,
                          style: r.heading1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior (65% da tela, sempre colado no bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(r.radiusXXL),
                topRight: Radius.circular(r.radiusXXL),
              ),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.65,
                  maxHeight: MediaQuery.of(context).size.height * 0.95,
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
                    SizedBox(height: r.spacingLG),
                    // Header com botão voltar e título
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: r.iconMD,
                          ),
                          color: AppColors.darkGreenHeader,
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: r.iconMD,
                            minHeight: r.iconMD,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Revisar Dados',
                            style: r.heading2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: r.isz(48, min: 40, max: 56)), // Balance do botão voltar
                      ],
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Informações de vigência
                    RichText(
                      text: TextSpan(
                        style: r.bodyMedium.copyWith(
                          color: AppColors.grayText,
                        ),
                        children: [
                          const TextSpan(text: 'Vigência do Plano: '),
                          TextSpan(
                            text: 'Mensal',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: ' Vencimento: '),
                          TextSpan(
                            text: '25',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Visualização do cartão
                    _buildCardVisual(r),
                    SizedBox(height: r.spacingXL),
                    
                    // Título Benefícios
                    Text(
                      'Benefícios do Plano:',
                      style: r.heading3.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingMD),
                    
                    // Lista de benefícios em duas colunas
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBenefit('Personalização inteligente de perfil', r),
                              _buildBenefit('Análises personalizadas de condutas e estudos', r),
                              _buildBenefit('Casos clínicos ilimitados', r),
                              _buildBenefit('Recomendações e trilhas adaptadas por IA', r),
                              _buildBenefit('Acesso completo ao Marketplace', r),
                            ],
                          ),
                        ),
                        SizedBox(width: r.spacingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBenefit('Gamificação avançada', r),
                              _buildBenefit('Chat com IA clínica', r),
                              _buildBenefit('Modo Plantão ilimitado', r),
                              _buildBenefit('Modo offline', r),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Botão Próximo
                    SizedBox(
                      height: r.h(56, min: 50, max: 64),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentSuccessScreen(
                                planLabel: widget.planLabel,
                                amount: widget.amount,
                                isAnnual: widget.isAnnual,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreenHeader,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Confirmar pagamento',
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

  Widget _buildCardVisual(Responsive r) {
    return Container(
      height: r.h(200, min: 180, max: 220),
      padding: r.pad(all: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkGreenHeader,
            Color(0xFF1A554C),
          ],
        ),
        borderRadius: BorderRadius.circular(r.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: r.isz(48, min: 40, max: 56),
                height: r.h(36, min: 30, max: 42),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4C5A9),
                  borderRadius: BorderRadius.circular(r.radiusSM),
                ),
              ),
              Container(
                width: r.isz(50, min: 40, max: 60),
                height: r.h(40, min: 30, max: 50),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(r.radiusXS),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _formatCardNumber(widget.cardNumber),
            style: r.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: r.spacingLG),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome',
                    style: r.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    widget.cardName.isEmpty ? 'Nome Sob.' : widget.cardName,
                    style: r.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data',
                    style: r.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _formatExpiryDate(widget.expiryDate),
                    style: r.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.credit_card,
                color: Colors.white,
                size: r.iconLG,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String text, Responsive r) {
    return Padding(
      padding: EdgeInsets.only(bottom: r.spacingMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.isz(20, min: 18, max: 22),
            height: r.isz(20, min: 18, max: 22),
            decoration: BoxDecoration(
              color: AppColors.darkGreenHeader,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: r.isz(12, min: 10, max: 14),
            ),
          ),
          SizedBox(width: r.spacingSM),
          Expanded(
            child: Text(
              text,
              style: r.bodyMedium.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
