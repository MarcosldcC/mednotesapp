import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/chat_conversation_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../services/settings_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _dragStartX = 0.0;
  bool _isDragging = false;


  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final settings = Provider.of<SettingsService>(context);
    final primaryColor = settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light, // Ícones brancos para fundo verde
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppHeader(isWhite: true, showNotifications: true),
            
            // Conteúdo com troca por gesto (sem rolagem visual)
            Expanded(
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  _isDragging = true;
                  _dragStartX = details.globalPosition.dx;
                },
                onHorizontalDragUpdate: (details) {
                  // Detecta movimento mínimo para trocar página
                  final delta = details.globalPosition.dx - _dragStartX;
                  if (delta.abs() > 50 && _isDragging) {
                    _isDragging = false;
                    final direction = delta > 0 ? -1 : 1;
                    final targetPage = (_currentPage + direction).clamp(0, 2);
                    if (targetPage != _currentPage) {
                      setState(() {
                        _currentPage = targetPage;
                      });
                    }
                  }
                },
                onHorizontalDragEnd: (details) {
                  _isDragging = false;
                },
                child: AnimatedSwitcher(
                  duration: settings.ecoModeEnabled
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _getCurrentPage(),
                ),
              ),
            ),
            
            // Indicador de progresso
            _buildProgressIndicator(),
            SizedBox(height: r.spacingLG),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(isWhite: true),
    );
  }


  Widget _getCurrentPage() {
    switch (_currentPage) {
      case 0:
        return _buildWelcomePage();
      case 1:
        return _buildWhoAmIPage();
      case 2:
        return _buildWhatCanIAskPage();
      default:
        return _buildWelcomePage();
    }
  }

  Widget _buildWelcomePage() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          key: const ValueKey('welcome'),
          color: _primaryColor(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logomednotes.png',
                width: r.isz(80, min: 70, max: 100),
                height: r.isz(80, min: 70, max: 100),
                fit: BoxFit.contain,
              ),
              SizedBox(height: r.spacingXXXXL),
              Text(
                'Seja Bem-vindo\nao Dr.Axon',
                style: r.heading1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: r.spacingXXL),
              Padding(
                padding: r.pad(horizontal: 24),
                child: Text(
                  'Comece a conversar comigo agora mesmo! Você pode me perguntar qualquer coisa.',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: r.h(48, min: 40, max: 60)),
              Container(
                width: double.infinity,
                margin: r.margin(horizontal: 24),
                padding: r.pad(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: r.s(2)),
                  borderRadius: BorderRadius.circular(r.radiusMD),
                ),
                child: Text(
                  'Deslize para direita',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWhoAmIPage() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          key: const ValueKey('whoami'),
          color: _primaryColor(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logomednotes.png',
                width: r.isz(80, min: 70, max: 100),
                height: r.isz(80, min: 70, max: 100),
                fit: BoxFit.contain,
              ),
              SizedBox(height: r.spacingXXXXL),
              Text(
                'Quem Sou Eu?',
                style: r.heading1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: r.spacingXXL),
              Padding(
                padding: r.pad(horizontal: 24),
                child: Text(
                  'Eu sou um Assistente de Inteligência\nArtificial (O Dr.Axon) treinado com\nMedicina Baseada em Evidências.',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: r.h(48, min: 40, max: 60)),
              Container(
                width: double.infinity,
                margin: r.margin(horizontal: 24),
                padding: r.pad(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: r.s(2)),
                  borderRadius: BorderRadius.circular(r.radiusMD),
                ),
                child: Text(
                  'Deslize para direita',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWhatCanIAskPage() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          key: const ValueKey('whatcanask'),
          color: _primaryColor(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logomednotes.png',
                width: r.isz(80, min: 70, max: 100),
                height: r.isz(80, min: 70, max: 100),
                fit: BoxFit.contain,
              ),
              SizedBox(height: r.spacingXXXXL),
              Text(
                'O que posso perguntar a você?',
                style: r.heading1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: r.spacingXXL),
              Padding(
                padding: r.pad(horizontal: 24),
                child: Text(
                  'Você pode tirar diversos tipos de dúvidas sobre casos clínicos, fluxogramas clínicos e até mesmo sobre funções do App Mednotes!',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: r.h(48, min: 40, max: 60)),
              GestureDetector(
                onTap: () {
                  final settings = Provider.of<SettingsService>(context, listen: false);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const ChatConversationScreen(),
                      transitionDuration: settings.ecoModeEnabled
                          ? Duration.zero
                          : const Duration(milliseconds: 300),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: r.margin(horizontal: 24),
                  padding: r.pad(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.creamCard,
                    borderRadius: BorderRadius.circular(r.radiusMD),
                  ),
                  child: Text(
                    'Vamos Começar',
                    style: r.bodyMedium.copyWith(
                        color: _primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: r.margin(horizontal: 4),
              width: r.s(_currentPage == index ? 24 : 8, min: 6, max: 28),
              height: r.s(8, min: 6, max: 10),
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? _primaryColor(context)
                    : _primaryColor(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(r.r(4)),
              ),
            );
          }),
        );
      },
    );
  }

  Color _primaryColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    return settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
  }

}
