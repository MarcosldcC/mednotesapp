import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';

/// Opção de múltipla escolha com efeito glass
class MultipleChoiceOption extends StatelessWidget {
  final String letter;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  /// Quando true, opção errada: destaque vermelho e dica do Dr. Axon
  final bool isWrong;
  final VoidCallback? onTap;

  const MultipleChoiceOption({
    super.key,
    required this.letter,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return SizedBox(
      width: double.infinity,
      child: GlassCard(
        isDarkBackground: false,
        padding: r.pad(all: 16),
        borderRadius: r.radiusMD,
        child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.radiusMD),
        child: Container(
          decoration: BoxDecoration(
            color: isWrong
                ? AppColors.red.withValues(alpha: 0.15)
                : isSelected
                    ? AppColors.darkGreenHeader
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(r.radiusMD),
            border: isWrong
                ? Border.all(color: AppColors.red, width: 2)
                : null,
          ),
          padding: (isSelected || isWrong) ? r.pad(all: 16) : EdgeInsets.zero,
          child: Row(
            children: [
              // Círculo com letra
              Container(
                width: r.h(40, min: 32, max: 48),
                height: r.h(40, min: 32, max: 48),
                decoration: BoxDecoration(
                  color: isWrong
                      ? AppColors.red
                      : isSelected
                          ? Colors.white
                          : AppColors.darkGreenHeader,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: r.bodyLarge.copyWith(
                      color: isWrong
                          ? Colors.white
                          : isSelected
                              ? AppColors.darkGreenHeader
                              : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.spacingMD),
              // Texto da opção
              Expanded(
                child: Text(
                  text,
                  style: r.bodyMedium.copyWith(
                    color: isWrong
                        ? AppColors.darkGreenHeader
                        : isSelected
                            ? Colors.white
                            : AppColors.darkGreenHeader,
                    fontWeight: (isSelected || isWrong) ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
