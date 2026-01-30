import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';

/// Modelo para um passo do fluxograma
class FlowchartStep {
  final int number;
  final String title;
  final List<String> items;
  final Color? backgroundColor;
  final Color? textColor;

  const FlowchartStep({
    required this.number,
    required this.title,
    this.items = const [],
    this.backgroundColor,
    this.textColor,
  });
}

/// Modelo para uma ramificação do fluxograma
class FlowchartBranch {
  final String title;
  final List<String> items;

  const FlowchartBranch({
    required this.title,
    this.items = const [],
  });
}

/// Widget para exibir fluxogramas de decisão clínica
class DecisionFlowchart extends StatelessWidget {
  final List<FlowchartStep> steps;
  final List<FlowchartBranch>? branches;

  const DecisionFlowchart({
    super.key,
    required this.steps,
    this.branches,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fluxograma de Decisão',
            style: r.heading2.copyWith(
              color: AppColors.darkGreenHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: r.spacingXL),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Column(
              children: [
                _buildStepCard(r, step),
                if (index < steps.length - 1 || branches != null)
                  _buildArrow(r),
                if (index == steps.length - 1 && branches != null)
                  _buildBranches(r, branches!),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStepCard(Responsive r, FlowchartStep step) {
    final hasGreenBackground = step.backgroundColor == AppColors.darkGreenHeader;
    final bgColor = step.backgroundColor ?? Colors.white;
    final textColor = step.textColor ??
        (hasGreenBackground ? Colors.white : AppColors.darkGreenHeader);

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: r.pad(all: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(r.radiusMD),
          border: hasGreenBackground
              ? null
              : Border.all(
                  color: AppColors.darkGreenHeader.withValues(alpha: 0.4),
                  width: r.s(1.5),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${step.number}. ${step.title}',
              style: r.heading3.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (step.items.isNotEmpty) ...[
              SizedBox(height: r.spacingMD),
              ...step.items.map((item) => Padding(
                    padding: r.pad(bottom: r.spacingXS),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: r.bodyMedium.copyWith(color: textColor),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: r.bodyMedium.copyWith(color: textColor),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildArrow(Responsive r) {
    return Padding(
      padding: r.pad(vertical: r.spacingSM),
      child: Icon(
        Icons.arrow_downward,
        color: AppColors.darkGreenHeader,
        size: r.iconLG,
      ),
    );
  }

  Widget _buildBranches(Responsive r, List<FlowchartBranch> branches) {
    return Column(
      children: [
        SizedBox(height: r.spacingMD),
        Row(
          children: branches.asMap().entries.map((entry) {
            final index = entry.key;
            final branch = entry.value;
            return Expanded(
              child: Padding(
                padding: r.margin(
                  left: index == 0 ? 0 : r.spacingSM,
                  right: index == branches.length - 1 ? 0 : r.spacingSM,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: r.pad(all: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(r.radiusMD),
                      border: Border.all(
                        color: AppColors.darkGreenHeader.withValues(alpha: 0.4),
                        width: r.s(1.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branch.title,
                          style: r.heading3.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (branch.items.isNotEmpty) ...[
                          SizedBox(height: r.spacingMD),
                          ...branch.items.map((item) => Padding(
                                padding: r.pad(bottom: r.spacingXS),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: r.bodyMedium.copyWith(
                                        color: AppColors.darkGreenHeader,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: r.bodyMedium.copyWith(
                                          color: AppColors.darkGreenHeader,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: r.spacingMD),
        _buildArrow(r),
      ],
    );
  }
}
