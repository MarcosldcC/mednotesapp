import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/settings_service.dart';
import '../design/responsive.dart';
import 'add_card_logged_screen.dart';
import 'profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends State<SubscriptionManagementScreen> {
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
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppHeader(),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.spacingMD),
                    
                    // Botão voltar e título
                    Row(
                      children: [
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
                        SizedBox(width: r.spacingSM),
                        Expanded(
                          child: Text(
                            'Gerenciar Assinatura',
                            style: r.heading2.copyWith(
                              color: AppColors.darkGreenHeader,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingSM),
                    
                    // Descrição
                    Padding(
                      padding: EdgeInsets.only(left: r.isz(40, min: 30, max: 50)),
                      child: Text(
                        'Gerencie sua assinatura, método de pagamento e cancele quando quiser.',
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Card do plano atual
                    _buildCurrentPlanCard(r),
                    SizedBox(height: r.spacingXL),
                    
                    // Seção Método de Pagamento
                    Text(
                      'Método de Pagamento',
                      style: r.heading3.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingMD),
                    
                    // Cartão atual
                    _buildPaymentMethodCard(
                      r: r,
                      icon: Icons.credit_card,
                      title: 'Cartão de Crédito',
                      subtitle: 'Terminado em 1512',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCardLoggedScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingMD),
                    
                    // Botão adicionar novo cartão
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCardLoggedScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(r.radiusMD),
                      child: Container(
                        padding: r.pad(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(r.radiusMD),
                          border: Border.all(
                            color: AppColors.mediumGreen,
                            width: r.s(1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: AppColors.darkGreenHeader,
                              size: r.iconMD,
                            ),
                            SizedBox(width: r.spacingMD),
                            Expanded(
                              child: Text(
                                'Adicionar novo cartão',
                                style: r.bodyMedium.copyWith(
                                  color: AppColors.darkGreenHeader,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.darkGreenHeader,
                              size: r.iconMD,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Botão Cancelar Assinatura
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _showCancelSubscriptionDialog(context, r);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(
                            color: Colors.red,
                            width: r.s(2, min: 1.5, max: 2.5),
                          ),
                          padding: r.pad(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                        ),
                        child: Text(
                          'Cancelar Assinatura',
                          style: r.button.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                  ],
                ),
              ),
            ),
            
            // Bottom navigation bar
            const AppBottomNavigationBar(),
          ],
        ),
      ),
    );
  }


  Widget _buildCurrentPlanCard(Responsive r) {
    return Container(
      padding: r.pad(all: 20),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: BorderRadius.circular(r.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plano Atual',
                style: r.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
              Container(
                padding: r.pad(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(r.radiusMD),
                ),
                child: Text(
                  'Ativo',
                  style: r.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: r.spacingMD),
          Text(
            'Premium Mensal',
            style: r.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: r.spacingSM),
          Text(
            'R\$ 39,90 / mês',
            style: r.bodyLarge.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: r.spacingMD),
          Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: r.s(1),
          ),
          SizedBox(height: r.spacingMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Próxima cobrança',
                    style: r.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: r.spacingXS),
                  Text(
                    '25/02/2026',
                    style: r.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Vencimento',
                    style: r.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: r.spacingXS),
                  Text(
                    '25/02/2026',
                    style: r.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required Responsive r,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.radiusMD),
      child: Container(
        padding: r.pad(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.radiusMD),
          border: Border.all(
            color: AppColors.mediumGreen.withOpacity(0.3),
            width: r.s(1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.darkGreenHeader,
              size: r.iconMD,
            ),
            SizedBox(width: r.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: r.spacingXS),
                  Text(
                    subtitle,
                    style: r.bodySmall.copyWith(
                      color: AppColors.grayText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.darkGreenHeader,
              size: r.iconMD,
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelSubscriptionDialog(BuildContext context, Responsive r) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.radiusMD),
          ),
          title: Text(
            'Cancelar Assinatura',
            style: r.heading3.copyWith(
              color: AppColors.darkGreenHeader,
            ),
          ),
          content: Text(
            'Tem certeza que deseja cancelar sua assinatura? Você perderá acesso aos benefícios do plano Premium ao final do período pago.',
            style: r.bodyMedium.copyWith(
              color: AppColors.darkGreenHeader,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Não',
                style: r.bodyMedium.copyWith(
                  color: AppColors.grayText,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Assinatura cancelada com sucesso',
                      style: r.bodyMedium,
                    ),
                    backgroundColor: AppColors.darkGreenHeader,
                  ),
                );
              },
              child: Text(
                'Sim, cancelar',
                style: r.bodyMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
