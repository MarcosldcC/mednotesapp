import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Título
              Text(
                'Escolha seu plano',
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Cards de planos
              Row(
                children: [
                  // Card 1 - Free/Simplificado
                  Expanded(
                    child: _buildPlanCard(
                      price: 'R\$ 39,90',
                      period: '/ mês',
                      actionText: 'Ver detalhes',
                      isSimplified: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Card 2 - Mensal
                  Expanded(
                    child: _buildPlanCard(
                      price: 'R\$ 39,90',
                      period: '/ mês',
                      instructionText: 'Deslize para direita',
                      features: _getPremiumFeatures(),
                      buttonText: 'Escolher esse',
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Card 3 - Anual
                  Expanded(
                    child: _buildPlanCard(
                      price: 'R\$ 390,90',
                      period: '/ ano',
                      bonusText: '2 Parcelas gratuitas.',
                      features: _getPremiumFeatures(),
                      buttonText: 'Escolher esse',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String price,
    required String period,
    String? actionText,
    String? instructionText,
    String? bonusText,
    List<String>? features,
    String? buttonText,
    bool isSimplified = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSimplified
            ? AppColors.darkGreenHeader.withOpacity(0.7)
            : AppColors.darkGreenHeader,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícone de coroa
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium,
              color: AppColors.darkGreenHeader,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          // Preço
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: price),
                TextSpan(
                  text: ' $period',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Texto de ação ou instrução
          if (actionText != null)
            Text(
              actionText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          if (instructionText != null)
            Text(
              instructionText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          if (bonusText != null)
            Text(
              bonusText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          if (features != null) ...[
            const SizedBox(height: 24),
            Text(
              'Tudo do plano Free, além de:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
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
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            // Botão
            if (buttonText != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.creamBackground,
                    foregroundColor: AppColors.darkGreenHeader,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  List<String> _getPremiumFeatures() {
    return [
      'Personalização inteligente de perfil',
      'Gamificação avançada',
      'Chat com IA clínica',
      'Análises personalizadas de condutas e estudos',
      'Casos clínicos ilimitados',
      'Modo Plantão ilimitado',
      'Modo offline',
      'Recomendações e trilhas adaptadas por IA',
      'Acesso completo ao Marketplace',
    ];
  }
}
