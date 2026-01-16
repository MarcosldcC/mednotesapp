import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/custom_clipper.dart';
import '../screens/payment_method_screen.dart';
import '../screens/dashboard_screen.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  String? _expandedPlan; // 'free', 'premium', 'institucional' ou null

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
                      'Escolha seu plano',
                      style: AppTextStyles.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Card FREE
                    _buildPlanCard(
                      planId: 'free',
                      imagePath: 'assets/images/free.png',
                      price: 'R\$ 0,00 / mês',
                      showDetails: true,
                      onDetailsTap: () {
                        setState(() {
                          _expandedPlan = _expandedPlan == 'free' ? null : 'free';
                        });
                      },
                      onChooseTap: () {
                        // Navegar direto para o dashboard (plano FREE não precisa de pagamento)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Card Premium Mensal
                    _buildPlanCard(
                      planId: 'premium',
                      imagePath: 'assets/images/premium.png',
                      price: 'R\$ 39,90 / mês',
                      showDetails: true,
                      onDetailsTap: () {
                        setState(() {
                          _expandedPlan = _expandedPlan == 'premium' ? null : 'premium';
                        });
                      },
                      onChooseTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentMethodScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Card Entre em contato
                    _buildPlanCard(
                      planId: 'institucional',
                      imagePath: 'assets/images/institucional.png',
                      price: 'Entre em contato conosco',
                      showDetails: false,
                      onDetailsTap: null,
                      onChooseTap: () {
                        // Abrir contato
                      },
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

  Widget _buildPlanCard({
    required String planId,
    required String imagePath,
    required String price,
    required bool showDetails,
    required VoidCallback? onDetailsTap,
    required VoidCallback onChooseTap,
  }) {
    final isExpanded = _expandedPlan == planId;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(isExpanded ? 20.0 : 16.0),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: 60,
              );
            },
          ),
          SizedBox(height: isExpanded ? 12 : 8),
          Text(
            price,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (showDetails && !isExpanded) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onDetailsTap,
              child: Text(
                'Ver detalhes',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          if (isExpanded) ...[
            const SizedBox(height: 24),
            _buildPlanDetails(planId),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onChooseTap,
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
        ],
      ),
    );
  }

  Widget _buildPlanDetails(String planId) {
    if (planId == 'free') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeature('Protocolos essenciais'),
          _buildFeature('Casos clínicos limitados'),
          _buildFeature('Modo Plantão reduzido'),
          _buildFeature('Marketplace'),
          _buildFeature('Módulo "Você Sabia?"'),
          _buildFeature('Saúde em Tempo Real básica'),
        ],
      );
    } else if (planId == 'premium') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tudo do plano Free, além de:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeature('Personalização inteligente de perfil'),
          _buildFeature('Gamificação avançada'),
          _buildFeature('Chat com IA clínica'),
          _buildFeature('Análises personalizadas de condutas e estudos'),
          _buildFeature('Casos clínicos ilimitados'),
          _buildFeature('Modo Plantão ilimitado'),
          _buildFeature('Modo offline'),
          _buildFeature('Recomendações e trilhas adaptadas por IA'),
          _buildFeature('Acesso completo ao Marketplace'),
        ],
      );
    }
    return const SizedBox.shrink();
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
