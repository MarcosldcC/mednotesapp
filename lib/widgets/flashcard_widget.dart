import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';

/// Widget de flashcard (pergunta e resposta)
class FlashcardWidget extends StatelessWidget {
  final String question;
  final String answer;
  final bool showAnswer;

  const FlashcardWidget({
    super.key,
    required this.question,
    required this.answer,
    this.showAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card de pergunta (verde escuro)
        Container(
          width: double.infinity,
          padding: r.pad(all: 20),
          decoration: BoxDecoration(
            color: AppColors.darkGreenHeader,
            borderRadius: BorderRadius.circular(r.radiusMD),
          ),
          child: Text(
            question,
            style: r.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: r.spacingMD),
        // Card de resposta (glass)
        SizedBox(
          width: double.infinity,
          child: GlassCard(
            isDarkBackground: false,
            padding: r.pad(all: 20),
            borderRadius: r.radiusMD,
            child: showAnswer
                ? Text(
                    answer,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.grayText,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Center(
                    child: Text(
                      'Toque para ver a resposta',
                      style: r.bodySmall.copyWith(
                        color: AppColors.grayText,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
