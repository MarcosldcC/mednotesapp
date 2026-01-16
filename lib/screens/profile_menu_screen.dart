import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth * 0.6;

    return Drawer(
      width: drawerWidth,
      backgroundColor: AppColors.creamCard,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: AppColors.creamCard,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.darkGreenHeader),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Voltar',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                  ),
                ],
              ),
            ),
            
            // Conteúdo do menu
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Seção: Sua conta
                    _buildSectionTitle('Sua conta'),
                    const SizedBox(height: 16),
                    _buildMenuOption(
                      icon: Icons.person_outline,
                      title: 'Editar Perfil',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildMenuOption(
                      icon: Icons.trending_up,
                      title: 'Ver Progresso',
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),
                    
                    // Seção: Notificações
                    _buildSectionTitle('Notificações'),
                    const SizedBox(height: 16),
                    _buildMenuOptionWithSwitch(
                      icon: Icons.notifications_outlined,
                      title: 'Alertas Epidemiológicos',
                      value: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 12),
                    _buildMenuOptionWithSwitch(
                      icon: Icons.notifications_active_outlined,
                      title: 'Notificações Push',
                      value: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 32),
                    
                    // Seção: Acessibilidade
                    _buildSectionTitle('Acessibilidade'),
                    const SizedBox(height: 16),
                    _buildMenuOption(
                      icon: Icons.text_fields,
                      title: 'Tamanho do Texto',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildMenuOptionWithSwitch(
                      icon: Icons.contrast,
                      title: 'Alto Contraste',
                      value: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 32),
                    
                    // Seção: Suporte e Informações
                    _buildSectionTitle('Suporte e Informações'),
                    const SizedBox(height: 16),
                    _buildMenuOption(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Política e Privacidade',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildMenuOption(
                      icon: Icons.help_outline,
                      title: 'Central de Ajuda',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildMenuOption(
                      icon: Icons.description_outlined,
                      title: 'Termos de Uso',
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),
                    
                    // Divisor
                    Container(
                      height: 1,
                      color: AppColors.mediumGreen.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    
                    // Sair da Conta
                    _buildMenuOption(
                      icon: Icons.logout,
                      title: 'Sair da Conta',
                      isDestructive: true,
                      onTap: () {
                        // Implementar lógica de logout
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Copyright
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '© 2026 MedNotes. Todos os direitos reservados',
                          style: AppTextStyles.bodySmall?.copyWith(
                            color: AppColors.grayText,
                          ) ?? AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grayText,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(
        color: AppColors.darkGreenHeader,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.mediumGreen.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? Colors.red
                  : AppColors.darkGreenHeader,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDestructive
                      ? Colors.red
                      : AppColors.darkGreenHeader,
                  fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isDestructive)
              Icon(
                Icons.chevron_right,
                color: AppColors.darkGreenHeader,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptionWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.mediumGreen.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.darkGreenHeader,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.darkGreenHeader,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
