import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';
import 'edit_profile_screen.dart';
import 'customize_profile_screen.dart';
import 'subscription_management_screen.dart';
import 'verify_code_screen.dart';
import 'profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class ViewAccountScreen extends StatelessWidget {
  const ViewAccountScreen({super.key});

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
                    SizedBox(height: r.spacingLG),
                    
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
                            'Visualizar Conta',
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
                      padding: r.pad(left: 40),
                      child: Text(
                        'Aqui você pode editar conta, personalizar perfil de estudo e mudar dados de acesso ou pagamento da sua conta!',
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Foto de perfil e nome
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: r.h(120, min: 100, max: 140),
                            height: r.h(120, min: 100, max: 140),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.darkGreenHeader,
                                width: r.s(4, min: 3, max: 5),
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/medica.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.mediumGreen,
                                    child: Icon(
                                      Icons.person,
                                      size: r.isz(60, min: 50, max: 80),
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: r.spacingLG),
                          Text(
                            'Miguel Arcanjo',
                            style: r.heading3.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: r.h(40, min: 32, max: 48)),
                    
                    // Opções da conta
                    _buildAccountOption(
                      context,
                      icon: Icons.edit_outlined,
                      title: 'Editar Conta',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingLG),
                    _buildAccountOption(
                      context,
                      icon: Icons.person_outline,
                      title: 'Personalizar Perfil',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomizeProfileScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingLG),
                    _buildAccountOption(
                      context,
                      icon: Icons.credit_card_outlined,
                      title: 'Gerenciar Assinatura',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubscriptionManagementScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingLG),
                    _buildAccountOption(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Trocar Senha',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerifyCodeScreen(
                              email: 'miguel.arcanjo@gmail.com',
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingXXXXL),
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


  Widget _buildAccountOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final r = Responsive.of(context);
    
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
                title,
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
    );
  }

}
