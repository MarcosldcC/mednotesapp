import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class PlansHorizontalScreen extends StatelessWidget {
  const PlansHorizontalScreen({super.key});

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
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Título
            Text(
              'Escolha seu plano',
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // Cards horizontais scrolláveis
            Expanded(
              child: PageView(
                children: [
                  _buildPlanCard(
                    price: 'R\$ 39,90 / mês',
                    hint: 'Deslize para direita',
                    features: [
                      'Personalização inteligente de perfil',
                      'Gamificação avançada',
                      'Chat com IA clínica',
                      'Análises personalizadas de condutas e estudos',
                      'Casos clínicos ilimitados',
                      'Modo Plantão ilimitado',
                      'Modo offline',
                      'Recomendações e trilhas adaptadas por IA',
                      'Acesso completo ao Marketplace',
                    ],
                  ),
                  _buildPlanCard(
                    price: 'R\$ 390,90 / ano',
                    benefit: '2 Parcelas gratuitas.',
                    features: [
                      'Personalização inteligente de perfil',
                      'Gamificação avançada',
                      'Chat com IA clínica',
                      'Análises personalizadas de condutas e estudos',
                      'Casos clínicos ilimitados',
                      'Modo Plantão ilimitado',
                      'Modo offline',
                      'Recomendações e trilhas adaptadas por IA',
                      'Acesso completo ao Marketplace',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String price,
    String? hint,
    String? benefit,
    required List<String> features,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.darkGreenHeader,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone de coroa
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.creamCard,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: AppColors.darkGreenHeader,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            // Preço
            Text(
              price,
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.creamCard,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (hint != null) ...[
              const SizedBox(height: 8),
              Text(
                hint,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.creamCard,
                ),
              ),
            ],
            if (benefit != null) ...[
              const SizedBox(height: 8),
              Text(
                benefit,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.creamCard,
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Título da lista
            Text(
              'Tudo do plano Free, além de:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.creamCard,
              ),
            ),
            const SizedBox(height: 16),
            // Lista de features
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: features.length,
                itemBuilder: (context, index) {
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
                              color: AppColors.creamCard,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: AppColors.creamCard,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            features[index],
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.creamCard,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Botão Escolher esse
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Navegar para método de pagamento
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
      ),
    );
  }
}
