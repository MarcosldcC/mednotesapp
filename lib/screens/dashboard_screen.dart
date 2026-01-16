import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2; // Home está no meio (índice 2)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      key: _scaffoldKey,
      backgroundColor: AppColors.creamCard,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header com avatar, logo e notificação
            _buildHeader(),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Seção: Seu Nível de Performance
                    _buildPerformanceSection(),
                    const SizedBox(height: 32),
                    
                    // Seção: Olá Paola!
                    _buildGreetingSection(),
                    const SizedBox(height: 24),
                    
                    // Barra de busca
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    
                    // Seção: Ações Rápidas
                    _buildQuickActionsSection(),
                    const SizedBox(height: 32),
                    
                    // Seção: Modo Eco Ativo
                    _buildEcoModeSection(),
                    const SizedBox(height: 32),
                    
                    // Seção: Protocolos Recentes
                    _buildRecentProtocolsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          // Avatar clicável
          Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/medica.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
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
          // Ícone de notificação
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seu Nível de Performance',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.darkGreenHeader,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Acompanhe seu progresso no MedNotes',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grayText,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          decoration: BoxDecoration(
            color: AppColors.darkGreenHeader,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildMetricItem(Icons.star_outline, 'EXPERIÊNCIA', '590'),
                    ),
                    Container(
                      width: 1,
                      height: 70,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: _buildMetricItem(Icons.public, 'RANK MUNDIAL', '#1,438'),
                    ),
                    Container(
                      width: 1,
                      height: 70,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: _buildMetricItem(Icons.location_on, 'RANK LOCAL', '#56'),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Ver Mais',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall?.copyWith(
            color: Colors.white70,
          ) ?? AppTextStyles.bodyMedium.copyWith(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá Paola!',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.darkGreenHeader,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'O que você precisa hoje?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grayText,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkGreenHeader,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.grayText),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar sintoma, doença ou protocolo...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grayText,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
              ),
              onChanged: (value) {
                // Aqui você pode implementar a lógica de busca
                // Por exemplo, filtrar resultados baseado no valor digitado
              },
              onSubmitted: (value) {
                // Aqui você pode implementar a ação quando o usuário pressionar Enter
                // Por exemplo, navegar para uma tela de resultados de busca
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.darkGreenHeader,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.description,
                title: 'Algoritmos',
                subtitle: 'Fluxogramas clínicos',
                isHighlighted: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.flash_on,
                title: 'Modo Plantão',
                subtitle: 'Decisões Rápidas',
                isHighlighted: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildQuickActionCard(
                  icon: Icons.settings,
                  title: 'Casos Clínicos',
                  subtitle: 'Pratique Agora',
                  isHighlighted: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _buildQuickActionCard(
                  icon: Icons.favorite,
                  title: 'Saúde em Tempo Real',
                  subtitle: 'Dados epidemiológicos',
                  isHighlighted: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isHighlighted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.darkGreenHeader : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkGreenHeader,
          width: isHighlighted ? 0 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            icon,
            color: isHighlighted ? Colors.white : AppColors.darkGreenHeader,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isHighlighted ? Colors.white : AppColors.darkGreenHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall?.copyWith(
              color: isHighlighted ? Colors.white70 : AppColors.grayText,
            ) ?? AppTextStyles.bodyMedium.copyWith(
              color: isHighlighted ? Colors.white70 : AppColors.grayText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoModeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.eco, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modo Eco Ativo',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Este aplicativo é sustentável!',
                  style: AppTextStyles.bodySmall?.copyWith(
                    color: Colors.white70,
                  ) ?? AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Ver mais >',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProtocolsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Protocolos Recentes',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'Ver',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.darkGreenHeader,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.swipe, color: AppColors.darkGreenHeader, size: 20),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Lista de protocolos recentes (placeholder)
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mediumGreen),
          ),
          child: Center(
            child: Text(
              'Nenhum protocolo recente',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        // Removido acesso ao chat pela navbar
      },
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white70,
        size: 28,
      ),
    );
  }

  Widget _buildChatFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      },
      backgroundColor: AppColors.darkGreenHeader,
      child: const Icon(
        Icons.chat_bubble_outline,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
