import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';
import 'view_account_screen.dart';
import 'login_screen.dart';
import 'progress_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_center_screen.dart';
import 'terms_of_use_screen.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    final primaryColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
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
              padding: r.pad(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
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
                  Text(
                    'Voltar',
                    style: r.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Conteúdo do menu
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.spacingXXL),
                    
                    // Seção: Sua conta
                    _buildSectionTitle('Sua conta'),
                    SizedBox(height: r.spacingLG),
                    _buildMenuOption(
                      icon: Icons.person_outline,
                      title: 'Visualizar Conta',
                      onTap: () {
                        Navigator.pop(context); // Fechar o drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewAccountScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingMD),
                    _buildMenuOption(
                      icon: Icons.bar_chart_outlined,
                      title: 'Ver Progresso',
                      onTap: () {
                        Navigator.pop(context); // Fechar o drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProgressScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Notificações
                    _buildSectionTitle('Notificações'),
                    SizedBox(height: r.spacingLG),
                    Consumer<SettingsService>(
                      builder: (context, settings, child) {
                        return _buildMenuOptionWithSwitch(
                          icon: Icons.notifications_outlined,
                          title: 'Alertas Epidemiológicos',
                          value: settings.epidemiologicalAlerts,
                          onChanged: (value) {
                            settings.setEpidemiologicalAlerts(value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: r.spacingMD),
                    Consumer<SettingsService>(
                      builder: (context, settings, child) {
                        return _buildMenuOptionWithSwitch(
                          icon: Icons.notifications_active_outlined,
                          title: 'Notificações Push',
                          value: settings.pushNotifications,
                          onChanged: (value) {
                            settings.setPushNotifications(value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Acessibilidade
                    _buildSectionTitle('Acessibilidade'),
                    SizedBox(height: r.spacingLG),
                    _buildMenuOption(
                      icon: Icons.text_fields,
                      title: 'Tamanho do Texto',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            final r = Responsive.of(dialogContext);
                            return Consumer<SettingsService>(
                              builder: (context, settings, child) {
                                double tempScale = settings.textScale;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        'Tamanho do Texto',
                                        style: r.heading3.copyWith(
                                          color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Ajuste o tamanho do texto',
                                            style: r.bodyMedium.copyWith(
                                              color: AppColors.grayText,
                                            ),
                                          ),
                                          SizedBox(height: r.spacingLG),
                                          Slider(
                                            value: tempScale,
                                            min: settings.minTextScale,
                                            max: settings.maxTextScale,
                                            divisions: 6,
                                            label: tempScale.toStringAsFixed(1),
                                            activeColor: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                                            onChanged: (value) {
                                              setState(() {
                                                tempScale = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                          },
                                          child: Text(
                                            'Cancelar',
                                            style: r.bodyMedium.copyWith(
                                              color: AppColors.grayText,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            settings.setTextScale(tempScale);
                                            Navigator.pop(dialogContext);
                                          },
                                          child: Text(
                                            'Aplicar',
                                            style: r.bodyMedium.copyWith(
                                              color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: r.spacingMD),
                    Consumer<SettingsService>(
                      builder: (context, settings, child) {
                        return _buildMenuOptionWithSwitch(
                          icon: Icons.wb_sunny_outlined,
                          title: 'Alto Contraste',
                          value: settings.highContrast,
                          onChanged: (value) {
                            settings.setHighContrast(value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: r.spacingMD),
                    Consumer<SettingsService>(
                      builder: (context, settings, child) {
                        return _buildMenuOptionWithSwitch(
                          icon: Icons.eco_outlined,
                          title: 'Modo Eco',
                          value: settings.ecoModeEnabled,
                          onChanged: (value) {
                            settings.setEcoModeEnabled(value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Seção: Suporte e Informações
                    _buildSectionTitle('Suporte e Informações'),
                    SizedBox(height: r.spacingLG),
                    _buildMenuOption(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Política e Privacidade',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingMD),
                    _buildMenuOption(
                      icon: Icons.help_outline,
                      title: 'Central de Ajuda',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpCenterScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingMD),
                    _buildMenuOption(
                      icon: Icons.description_outlined,
                      title: 'Termos de Uso',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsOfUseScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Sair da Conta
                    _buildMenuOption(
                      icon: Icons.logout,
                      title: 'Sair da Conta',
                      isDestructive: true,
                      onTap: () {
                        // Capturar o contexto principal antes de abrir o diálogo
                        final mainContext = context;
                        
                        // Mostrar diálogo de confirmação
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            final r = Responsive.of(context);
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(r.radiusLG),
                              ),
                              title: Text(
                                'Sair da Conta',
                                style: r.heading3.copyWith(
                                  color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                                ),
                              ),
                              content: Text(
                                'Tem certeza que deseja sair da sua conta?',
                                style: r.bodyMedium.copyWith(
                                  color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: Text(
                                    'Cancelar',
                                    style: r.bodyMedium.copyWith(
                                      color: AppColors.grayText,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Fechar o diálogo
                                    Navigator.pop(dialogContext);
                                    // Fechar o drawer
                                    Navigator.pop(mainContext);
                                    
                                    // Aguardar um pouco para garantir que os dialogs foram fechados
                                    await Future.delayed(const Duration(milliseconds: 150));
                                    
                                    // Fazer logout: limpar stack e ir para login
                                    if (mainContext.mounted) {
                                      Navigator.of(mainContext, rootNavigator: true).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const LoginScreen(),
                                        ),
                                        (route) => false, // Remove todas as rotas anteriores
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Sair',
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
                      },
                    ),
                    SizedBox(height: r.spacingXXXXL),
                    
                    // Copyright
                    Center(
                      child: Padding(
                        padding: r.pad(horizontal: 8),
                        child: Text(
                          '© 2026 MedNotes. Todos os direitos reservados',
                          style: r.bodySmall.copyWith(
                            color: AppColors.grayText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXXL),
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
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        final settings = Provider.of<SettingsService>(context);
        return Text(
          title,
          style: r.heading3.copyWith(
            color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        final settings = Provider.of<SettingsService>(context);
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(r.radiusMD),
          child: Container(
            padding: r.pad(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.radiusMD),
              border: Border.all(
                color: AppColors.mediumGreen.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    settings.ecoModeEnabled ? 0.03 : 0.06,
                  ),
                  blurRadius: r.s(
                    settings.ecoModeEnabled ? 6 : 8,
                    min: 5,
                    max: 10,
                  ),
                  offset: Offset(
                    0,
                    r.s(
                      settings.ecoModeEnabled ? 2 : 3,
                      min: 2,
                      max: 5,
                    ),
                  ),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDestructive
                      ? Colors.red
                      : (settings.highContrast ? Colors.black : AppColors.darkGreenHeader),
                  size: r.iconSM,
                ),
                SizedBox(width: r.spacingMD),
                Expanded(
                  child: Text(
                    title,
                    style: r.bodyMedium.copyWith(
                      color: isDestructive
                          ? Colors.red
                          : (settings.highContrast ? Colors.black : AppColors.darkGreenHeader),
                      fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isDestructive)
                  Icon(
                    Icons.chevron_right,
                    color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                    size: r.iconSM,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuOptionWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        final settings = Provider.of<SettingsService>(context);
        return Container(
          padding: r.pad(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: Border.all(
              color: AppColors.mediumGreen.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  settings.ecoModeEnabled ? 0.03 : 0.06,
                ),
                blurRadius: r.s(
                  settings.ecoModeEnabled ? 6 : 8,
                  min: 5,
                  max: 10,
                ),
                offset: Offset(
                  0,
                  r.s(
                    settings.ecoModeEnabled ? 2 : 3,
                    min: 2,
                    max: 5,
                  ),
                ),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                size: r.iconSM,
              ),
              SizedBox(width: r.spacingMD),
              Expanded(
                child: Text(
                  title,
                  style: r.bodyMedium.copyWith(
                    color: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: settings.highContrast ? Colors.black : AppColors.darkGreenHeader,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
