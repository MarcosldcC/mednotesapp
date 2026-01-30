import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/glass_card.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/dashboard_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light, // Ícones brancos para fundo verde
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.creamCard,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.spacingXXL),
                    
                    // Título
                    Text(
                      'Notificações',
                      style: r.heading2.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Lista de notificações (placeholder)
                    _buildNotificationItem(
                      title: 'Bem-vindo ao MedNotes!',
                      message: 'Comece a explorar os recursos disponíveis.',
                      time: 'Agora',
                      isRead: false,
                    ),
                    SizedBox(height: r.spacingMD),
                    _buildNotificationItem(
                      title: 'Novo protocolo disponível',
                      message: 'Um novo protocolo clínico foi adicionado à plataforma.',
                      time: 'Há 2 horas',
                      isRead: true,
                    ),
                    SizedBox(height: r.spacingMD),
                    _buildNotificationItem(
                      title: 'Atualização do sistema',
                      message: 'Nova versão do aplicativo disponível para download.',
                      time: 'Ontem',
                      isRead: true,
                    ),
                    SizedBox(height: r.spacingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.darkGreenHeader,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(r.r(30, min: 24, max: 35)),
              bottomRight: Radius.circular(r.r(30, min: 24, max: 35)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: r.s(4),
                offset: Offset(0, r.s(2)),
              ),
            ],
          ),
          padding: r.pad(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // Botão voltar
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: r.iconMD,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: r.spacingSM),
              // Logo mednotes
              Expanded(
                child: Text(
                  'mednotes',
                  style: r.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Espaço para alinhar
              SizedBox(width: r.h(48, min: 40, max: 56)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required bool isRead,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return GlassCard(
          padding: r.pad(all: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador de não lida
              if (!isRead)
                Container(
                  width: r.s(8, min: 6, max: 10),
                  height: r.s(8, min: 6, max: 10),
                  margin: r.margin(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreenHeader,
                    shape: BoxShape.circle,
                  ),
                )
              else
                SizedBox(width: r.s(20, min: 16, max: 24)),
              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: r.bodyLarge.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingXS),
                    Text(
                      message,
                      style: r.bodyMedium.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    Text(
                      time,
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
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(r.r(30, min: 24, max: 35)),
              topRight: Radius.circular(r.r(30, min: 24, max: 35)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: r.s(4),
                offset: Offset(0, -r.s(2)),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: r.bottomNavHeight,
              padding: r.pad(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem('assets/images/Vector.svg', 0), // Livro - Algoritmo
                  _buildNavItem('assets/images/Vector-1.svg', 1), // Raio - Modo Plantão
                  _buildNavItem('assets/images/Icon.svg', 2), // Casa - Home
                  _buildNavItem('assets/images/Vector-2.svg', 3), // Sacola - Marketplace
                  _buildNavItem('assets/images/Vector-3.svg', 4), // Coração - Saúde em tempo real
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(String imagePath, int index) {
    final isHome = index == 2;
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return GestureDetector(
          onTap: () {
            if (isHome) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (route) => false,
              );
            }
          },
          child: Container(
            padding: r.pad(all: 8),
            child: SizedBox(
              width: r.iconMD,
              height: r.iconMD,
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  AppColors.darkGreenHeader,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
