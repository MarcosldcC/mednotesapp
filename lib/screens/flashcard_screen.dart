import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../widgets/flashcard_widget.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import 'profile_menu_screen.dart';

/// Tela de flashcard (pergunta e resposta)
class FlashcardScreen extends StatefulWidget {
  final String question;
  final String answer;

  const FlashcardScreen({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: r.pad(horizontal: 24, top: 24),
                  child: Column(
                    children: [
                      // Botão voltar
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.darkGreenHeader,
                              size: r.isz(24),
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: r.isz(40),
                              minHeight: r.isz(40),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXXL),
                      // Flashcard
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAnswer = !_showAnswer;
                          });
                        },
                        child: FlashcardWidget(
                          question: widget.question,
                          answer: widget.answer,
                          showAnswer: _showAnswer,
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
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
