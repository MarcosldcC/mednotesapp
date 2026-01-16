import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class FreePlanDetailScreen extends StatelessWidget {
  const FreePlanDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              // Card simplificado
              Expanded(
                child: _buildSimpleCard(),
              ),
              const SizedBox(width: 16),
              // Card detalhado
              Expanded(
                child: _buildDetailedCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge FREE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'FREE',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Preço
          Text(
            'R\$ 0,00',
            style: AppTextStyles.heading1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '/ mês',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Link Ver detalhes
          GestureDetector(
            onTap: () {
              // Scroll para card detalhado ou mostrar mais informações
            },
            child: Text(
              'Ver detalhes',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge FREE
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'FREE',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Preço
          Center(
            child: Column(
              children: [
                Text(
                  'R\$ 0,00',
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '/ mês',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Lista de features
          _buildFeature('Protocolos essenciais'),
          _buildFeature('Casos clínicos limitados'),
          _buildFeature('Modo Plantão reduzido'),
          _buildFeature('Marketplace'),
          _buildFeature('Módulo "Você Sabia?"'),
          _buildFeature('Saúde em Tempo Real básica'),
          const Spacer(),
          // Botão Escolher esse
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Navegar para próxima tela
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.creamCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Escolher esse',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
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
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
