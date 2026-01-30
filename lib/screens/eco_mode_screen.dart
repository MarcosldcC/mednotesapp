import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';
import '../widgets/app_header.dart';
import '../screens/profile_menu_screen.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class EcoModeScreen extends StatefulWidget {
  const EcoModeScreen({super.key});

  @override
  State<EcoModeScreen> createState() => _EcoModeScreenState();
}

class _EcoModeScreenState extends State<EcoModeScreen> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    final primaryColor =
        settings.highContrast ? Colors.black : AppColors.darkGreenHeader;

    return Scaffold(
      backgroundColor: AppColors.creamCard,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: primaryColor,
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
                            'Modo Eco do MedNotes',
                            style: r.heading2.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingSM),
                    Text(
                      'Tecnologia aliada à saúde e ao planeta.',
                      style: r.bodyMedium.copyWith(
                        color: settings.highContrast
                            ? Colors.black
                            : AppColors.grayText,
                      ),
                    ),
                    SizedBox(height: r.spacingLG),
                    _buildImpactCard(r, primaryColor),
                    SizedBox(height: r.spacingLG),
                    _buildIdentityCard(r, primaryColor),
                    SizedBox(height: r.spacingLG),
                    _buildEcoAction(r, settings, primaryColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTap: (index) {
          if (index != 2 && index != 3 && index != 4) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildImpactCard(Responsive r, Color primaryColor) {
    return Container(
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusLG),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: r.s(1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: r.s(8, min: 6, max: 10),
            offset: Offset(0, r.s(3, min: 2, max: 5)),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.h(48, min: 40, max: 56),
            height: r.h(48, min: 40, max: 56),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.radiusSM),
            ),
            child: Icon(
              Icons.eco,
              color: primaryColor,
              size: r.iconMD,
            ),
          ),
          SizedBox(width: r.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Impacto ambiental',
                  style: r.bodyLarge.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: r.spacingXS),
                Text(
                  'Em parceria com uma ONG ambiental, a cada download do app '
                  'uma árvore é plantada.',
                  style: r.bodySmall.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(Responsive r, Color primaryColor) {
    return Container(
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusLG),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: r.s(1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: r.s(8, min: 6, max: 10),
            offset: Offset(0, r.s(3, min: 2, max: 5)),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.h(48, min: 40, max: 56),
            height: r.h(48, min: 40, max: 56),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.radiusSM),
            ),
            child: Icon(
              Icons.nature,
              color: primaryColor,
              size: r.iconMD,
            ),
          ),
          SizedBox(width: r.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nossa identidade',
                  style: r.bodyLarge.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: r.spacingXS),
                Text(
                  'A identidade do MedNotes é inspirada em uma árvore: '
                  'crescimento, cuidado e vida.',
                  style: r.bodySmall.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoAction(
    Responsive r,
    SettingsService settings,
    Color primaryColor,
  ) {
    return Container(
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(r.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: r.s(10, min: 8, max: 14),
            offset: Offset(0, r.s(4, min: 3, max: 6)),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settings.ecoModeEnabled
                      ? 'Modo Eco ativo'
                      : 'Ativar Modo Eco',
                  style: r.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: r.spacingXS),
                Text(
                  settings.ecoModeEnabled
                      ? 'Você está economizando energia e dados.'
                      : 'Reduza consumo de energia e dados.',
                  style: r.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: settings.ecoModeEnabled,
            onChanged: settings.setEcoModeEnabled,
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
