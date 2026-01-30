import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../services/settings_service.dart';
import '../providers/user_career_provider.dart';
import '../screens/profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import 'on_call_simulation_screen.dart';

/// Tela de apresentação do Modo Plantão (design Figma node 157-655).
/// Prática de tomada de decisão rápida em cenários de emergência.
class OnCallModeScreen extends StatefulWidget {
  const OnCallModeScreen({super.key});

  @override
  State<OnCallModeScreen> createState() => _OnCallModeScreenState();
}

class _OnCallModeScreenState extends State<OnCallModeScreen> {
  int _currentIndex = 1; // Raio (Vector-1) = Modo Plantão

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    final primaryColor =
        settings.highContrast ? Colors.black : AppColors.darkGreenHeader;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: primaryColor,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(isWhite: true),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: r.pad(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Ícone central (raio em quadrado branco)
                      Container(
                        width: r.h(120, min: 100, max: 140),
                        height: r.h(120, min: 100, max: 140),
                        constraints: BoxConstraints(
                          minWidth: r.h(120, min: 100, max: 140),
                          maxWidth: r.h(120, min: 100, max: 140),
                          minHeight: r.h(120, min: 100, max: 140),
                          maxHeight: r.h(120, min: 100, max: 140),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(r.radiusLG),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.bolt,
                            size: r.iconXL * 2,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: r.spacingLG),
                      Text(
                        'Modo Plantão',
                        style: r.heading1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: r.spacingSM),
                      Padding(
                        padding: r.pad(horizontal: 8),
                        child: Text(
                          'Pratique a tomada de decisão rápida em cenários de emergência realistas com tempo limitado.',
                          style: r.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.95),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: r.spacingXXL),
                      // Card de recursos com efeito vidro
                      _buildFeatureCard(r, primaryColor),
                      SizedBox(height: r.spacingXXL),
                      // Botão Iniciar Plantão
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final career = Provider.of<UserCareerProvider>(context, listen: false);
                            final timeLimit = career.getTimeLimitForLevel();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnCallSimulationScreen(
                                  remainingSeconds: timeLimit,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColor,
                            padding: r.pad(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Iniciar Plantão',
                            style: r.button.copyWith(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: r.spacingLG),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Voltar',
                          style: r.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        isWhite: true,
        currentIndex: _currentIndex,
        onItemTap: (index) {
          if (index != 2 && index != 3 && index != 4) {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }

  Widget _buildFeatureCard(Responsive r, Color primaryColor) {
    final items = [
      (
        icon: Icons.schedule,
        title: 'Tempo Limitado',
        subtitle: '3 minutos por caso',
      ),
      (
        icon: Icons.warning_amber_rounded,
        title: 'Decisões Críticas',
        subtitle: 'Simule situações de alta pressão',
      ),
      (
        icon: Icons.bolt,
        title: 'Feedback imediato',
        subtitle: 'Aprenda com cada decisão',
      ),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(r.radiusLG),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: r.pad(all: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(r.radiusLG),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: r.s(1),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(height: r.spacingLG),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: r.h(40, min: 36, max: 48),
                      height: r.h(40, min: 36, max: 48),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(r.radiusSM),
                      ),
                      child: Icon(
                        items[i].icon,
                        color: Colors.white,
                        size: r.iconMD,
                      ),
                    ),
                    SizedBox(width: r.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[i].title,
                            style: r.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: r.spacingXS),
                          Text(
                            items[i].subtitle,
                            style: r.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
