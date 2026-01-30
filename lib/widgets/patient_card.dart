import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';

/// Card de informações do paciente para simulação com efeito glass
class PatientCard extends StatelessWidget {
  final String patientName;
  final int patientAge;
  final String symptom;
  final String previousHistory;
  final String usualMedication;
  final String? patientImagePath;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;
  final VoidCallback? onStartSimulation;

  const PatientCard({
    super.key,
    required this.patientName,
    required this.patientAge,
    required this.symptom,
    required this.previousHistory,
    required this.usualMedication,
    this.patientImagePath,
    this.isCollapsed = false,
    this.onToggleCollapse,
    this.onStartSimulation,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header verde escuro
          Container(
            padding: r.pad(all: 16),
            decoration: BoxDecoration(
              color: AppColors.darkGreenHeader,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(r.radiusMD),
                topRight: Radius.circular(r.radiusMD),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: r.iconMD,
                ),
                SizedBox(width: r.spacingSM),
                Text(
                  'Informações do Paciente',
                  style: r.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo: avatar + nome em linha; depois cards de informação
          Padding(
            padding: r.pad(all: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha: avatar + nome e idade
                Row(
                  children: [
                    Container(
                      width: r.h(64, min: 56, max: 80),
                      height: r.h(64, min: 56, max: 80),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.grayLight,
                      ),
                      child: ClipOval(
                        child: patientImagePath != null
                            ? Image.asset(
                                patientImagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar(r);
                                },
                              )
                            : _buildDefaultAvatar(r),
                      ),
                    ),
                    SizedBox(width: r.spacingMD),
                    Expanded(
                      child: Text(
                        '$patientName, $patientAge anos',
                        style: r.heading3.copyWith(
                          color: AppColors.darkGreenHeader,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isCollapsed && onToggleCollapse != null)
                  Padding(
                    padding: r.pad(top: r.spacingMD),
                    child: TextButton(
                      onPressed: onToggleCollapse,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Exibir',
                        style: r.bodySmall.copyWith(
                          color: AppColors.darkGreenHeader,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (!isCollapsed) ...[
                  SizedBox(height: r.spacingLG),
                  // Card Sintoma
                  _buildInfoCard(r, 'Sintoma', symptom),
                  SizedBox(height: r.spacingMD),
                  // Card Histórico prévio
                  _buildInfoCard(r, 'Histórico prévio', previousHistory),
                  SizedBox(height: r.spacingMD),
                  // Card Medicação
                  _buildInfoCard(r, 'Medicação usual', usualMedication),
                  if (onToggleCollapse != null)
                    Padding(
                      padding: r.pad(top: r.spacingSM),
                      child: TextButton(
                        onPressed: onToggleCollapse,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Ocultar',
                          style: r.bodySmall.copyWith(
                            color: AppColors.darkGreenHeader,
                          ),
                        ),
                      ),
                    ),
                ],
                if (onStartSimulation != null) ...[
                  SizedBox(height: r.spacingLG),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onStartSimulation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreenHeader,
                        foregroundColor: Colors.white,
                        padding: r.pad(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(r.radiusMD),
                        ),
                      ),
                      child: Text(
                        'Iniciar Simulação',
                        style: r.button.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Responsive r, String label, String content) {
    return Container(
      width: double.infinity,
      padding: r.pad(all: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusMD),
        border: Border.all(
          color: AppColors.darkGreenHeader.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: r.bodySmall.copyWith(
              color: AppColors.darkGreenHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: r.spacingXS),
          Text(
            content,
            style: r.bodyMedium.copyWith(
              color: AppColors.grayText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(Responsive r) {
    return Container(
      color: AppColors.grayLight,
      child: Icon(
        Icons.person,
        size: r.iconXL,
        color: AppColors.grayText,
      ),
    );
  }
}
