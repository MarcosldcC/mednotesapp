import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Título
                    Text(
                      'Notificações',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Lista de notificações (placeholder)
                    _buildNotificationItem(
                      title: 'Bem-vindo ao MedNotes!',
                      message: 'Comece a explorar os recursos disponíveis.',
                      time: 'Agora',
                      isRead: false,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationItem(
                      title: 'Novo protocolo disponível',
                      message: 'Um novo protocolo clínico foi adicionado à plataforma.',
                      time: 'Há 2 horas',
                      isRead: true,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationItem(
                      title: 'Atualização do sistema',
                      message: 'Nova versão do aplicativo disponível para download.',
                      time: 'Ontem',
                      isRead: true,
                    ),
                    const SizedBox(height: 24),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          // Botão voltar
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
          // Logo mednotes
          Expanded(
            child: Text(
              'mednotes',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Espaço para alinhar
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required bool isRead,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkGreenHeader,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador de não lida
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, right: 12),
              decoration: BoxDecoration(
                color: AppColors.darkGreenHeader,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 20),
          // Conteúdo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.darkGreenHeader,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: AppTextStyles.bodySmall?.copyWith(
                    color: AppColors.grayText,
                  ) ?? AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grayText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavAvatar(),
              _buildNavItem(Icons.book_outlined, 1),
              _buildNavItem(Icons.home, 2),
              _buildNavItem(Icons.card_giftcard_outlined, 3),
              _buildNavItem(Icons.sports_esports_outlined, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavAvatar() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: const Icon(
          Icons.favorite_outline,
          color: Colors.white70,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 2) {
          // Navegar para dashboard quando clicar no home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
          );
        }
      },
      child: Icon(
        icon,
        color: AppColors.darkGreenHeader,
        size: 28,
      ),
    );
  }
}
