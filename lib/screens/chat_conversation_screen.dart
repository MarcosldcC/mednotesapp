import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../screens/profile_menu_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../services/settings_service.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({super.key});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

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
            
            // Conteúdo do chat
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: r.pad(all: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
            ),
            
            // Campo de input
            _buildInputField(),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(isWhite: true),
    );
  }


  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          color: _primaryColor(context),
          child: Center(
            child: Text(
              'Qual sua dúvida?',
              style: r.heading2.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Align(
          alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
              minWidth: 0,
            ),
            child: IntrinsicWidth(
              child: Container(
                margin: r.margin(bottom: 16),
                padding: r.pad(all: 16),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? AppColors.whiteLight
                      : Colors.white,
                  borderRadius: BorderRadius.circular(r.radiusLG),
                  border: message.isUser
                      ? Border.all(color: AppColors.mediumGreen.withOpacity(0.2))
                      : Border.all(color: AppColors.mediumGreen.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        Provider.of<SettingsService>(context).ecoModeEnabled ? 0.03 : 0.06,
                      ),
                      blurRadius: r.s(
                        Provider.of<SettingsService>(context).ecoModeEnabled ? 6 : 8,
                        min: 5,
                        max: 10,
                      ),
                      offset: Offset(
                        0,
                        r.s(
                          Provider.of<SettingsService>(context).ecoModeEnabled ? 2 : 3,
                          min: 2,
                          max: 5,
                        ),
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.text.trim(),
                      style: r.bodyMedium.copyWith(
                        color: message.isUser ? _primaryColor(context) : _primaryColor(context),
                      ),
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: r.spacingXS),
                    Align(
                      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        message.formattedTime,
                        style: r.caption.copyWith(
                          color: message.isUser 
                              ? _primaryColor(context).withOpacity(0.5)
                              : _primaryColor(context).withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          padding: r.pad(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _primaryColor(context),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: r.s(10),
                offset: Offset(0, -r.s(2)),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: r.pad(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.whiteLight,
                    borderRadius: BorderRadius.circular(r.r(24, min: 20, max: 28)),
                  ),
                  child: TextField(
                    controller: _messageController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Enviar a mensagem...',
                      hintStyle: r.bodyMedium.copyWith(
                        color: AppColors.grayText,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: r.pad(vertical: 8),
                    ),
                    style: r.bodyMedium.copyWith(
                      color: _primaryColor(context),
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.spacingMD),
              Container(
                width: r.h(48, min: 44, max: 56),
                height: r.h(48, min: 44, max: 56),
                decoration: BoxDecoration(
                  color: AppColors.whiteLight,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: _primaryColor(context),
                    size: r.iconMD,
                  ),
                  onPressed: () {
                    final trimmedText = _messageController.text.trim();
                    if (trimmedText.isNotEmpty) {
                      setState(() {
                        _messages.add(ChatMessage(
                          text: trimmedText,
                          isUser: true,
                        ));
                        _messageController.clear();
                      });
                      // Scroll para a última mensagem após adicionar
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _primaryColor(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    return settings.highContrast ? Colors.black : AppColors.darkGreenHeader;
  }

}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
