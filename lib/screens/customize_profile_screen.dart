import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/settings_service.dart';
import '../design/responsive.dart';
import 'profile_menu_screen.dart';
import 'view_account_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class CustomizeProfileScreen extends StatefulWidget {
  const CustomizeProfileScreen({super.key});

  @override
  State<CustomizeProfileScreen> createState() => _CustomizeProfileScreenState();
}

class _CustomizeProfileScreenState extends State<CustomizeProfileScreen> {
  // Valores iniciais
  final String _initialClinicalIdentity = 'Residente (R1 - R2)';
  final List<String> _initialInterestAreas = ['Clínica Médica'];
  final List<String> _initialStudyFormats = ['Fluxogramas/algoritmos'];

  String _clinicalIdentity = 'Residente (R1 - R2)';
  List<String> _interestAreas = ['Clínica Médica'];
  List<String> _studyFormats = ['Fluxogramas/algoritmos'];

  bool _listEquals(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  bool get _hasChanges {
    return _clinicalIdentity != _initialClinicalIdentity ||
        !_listEquals(_interestAreas, _initialInterestAreas) ||
        !_listEquals(_studyFormats, _initialStudyFormats);
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.darkGreenHeader,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.creamCard,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const AppHeader(),
            
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.spacingMD),
                    
                    // Botão voltar e título
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.darkGreenHeader,
                            size: r.iconMD,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: r.iconMD,
                            minHeight: r.iconMD,
                          ),
                        ),
                        SizedBox(width: r.spacingSM),
                        Expanded(
                          child: Text(
                            'Personalização do Perfil',
                            style: r.heading2.copyWith(
                              color: AppColors.darkGreenHeader,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingSM),
                    
                    // Descrição
                    Padding(
                      padding: EdgeInsets.only(left: r.isz(40, min: 30, max: 50)),
                      child: Text(
                        'Personalize seu perfil editando sua área de interesse, formatos de estudo e muito mais.',
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Campo Identidade Clínica
                    _buildEditableField(
                      label: 'Identidade Clínica',
                      value: _clinicalIdentity,
                      onTap: () => _showClinicalIdentityDialog(),
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Campo Área de Interesse (múltiplas seleções - tags)
                    _buildInterestAreasField(),
                    SizedBox(height: r.spacingLG),
                    
                    // Campo Formato de Estudo (ordem importa)
                    _buildStudyFormatsField(),
                    SizedBox(height: r.spacingXL),
                    
                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _hasChanges ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Perfil personalizado salvo com sucesso!'),
                              backgroundColor: AppColors.darkGreenHeader,
                            ),
                          );
                          // Voltar para Visualizar Conta
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const ViewAccountScreen(),
                            ),
                            (route) => route.isFirst,
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasChanges 
                              ? AppColors.darkGreenHeader 
                              : AppColors.creamCard,
                          foregroundColor: _hasChanges 
                              ? Colors.white 
                              : AppColors.grayText,
                          padding: r.pad(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                            side: BorderSide(
                              color: _hasChanges 
                                  ? AppColors.darkGreenHeader 
                                  : AppColors.grayLight,
                              width: 2,
                            ),
                          ),
                          disabledBackgroundColor: AppColors.creamCard,
                          disabledForegroundColor: AppColors.grayText,
                        ),
                        child: Text(
                          'Salvar',
                          style: r.button.copyWith(
                            color: _hasChanges 
                                ? Colors.white 
                                : AppColors.grayText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                  ],
                ),
              ),
            ),
            
            // Bottom navigation bar
            const AppBottomNavigationBar(),
          ],
        ),
      ),
    );
  }


  Widget _buildEditableField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: r.label.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingSM),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(r.radiusMD),
              child: Container(
                padding: r.pad(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.creamCard,
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  border: Border.all(
                    color: AppColors.darkGreenHeader,
                    width: r.s(1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: r.bodyMedium.copyWith(
                          color: AppColors.grayText,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      color: AppColors.darkGreenHeader,
                      size: r.iconSM,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClinicalIdentityDialog() {
    final options = [
      'Residente (R1 - R2)',
      'Residente (R3 - R4)',
      'Médico Generalista',
      'Médico Especialista',
      'Estudante de Medicina',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        final r = Responsive.of(dialogContext);
        return AlertDialog(
          title: Text(
            'Selecione Identidade Clínica',
            style: r.heading3.copyWith(
              color: AppColors.darkGreenHeader,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return ListTile(
                  title: Text(
                    option,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _clinicalIdentity = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterestAreasField() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Área de Interesse',
              style: r.label.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingSM),
            InkWell(
              onTap: () => _showInterestAreaDialog(),
              borderRadius: BorderRadius.circular(r.radiusMD),
              child: Container(
                padding: r.pad(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.creamCard,
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  border: Border.all(
                    color: AppColors.darkGreenHeader,
                    width: r.s(1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _interestAreas.isEmpty
                          ? Text(
                              'Selecione áreas de interesse',
                              style: r.bodyMedium.copyWith(
                                color: AppColors.grayText,
                              ),
                            )
                          : Wrap(
                              spacing: r.spacingSM,
                              runSpacing: r.spacingSM,
                              children: _interestAreas.map((area) {
                                return Container(
                                  padding: r.pad(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGreenHeader,
                                    borderRadius: BorderRadius.circular(r.radiusXXL),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        area,
                                        style: r.bodySmall.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: r.spacingXS),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _interestAreas.remove(area);
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: r.isz(16, min: 14, max: 18),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    Icon(
                      Icons.edit,
                      color: AppColors.darkGreenHeader,
                      size: r.iconSM,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInterestAreaDialog() {
    final options = [
      'Clínica Médica',
      'Medicina de Família e Comunidade (MFC)',
      'Pediatria',
      'Ginecologia e Obstetrícia',
      'Medicina Intensiva',
      'Geriatria',
      'Infectologia',
      'Cirurgia Geral',
      'Ortopedia e Traumatologia',
      'Anestesiologia',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        final r = Responsive.of(dialogContext);
        return AlertDialog(
          title: Text(
            'Selecione Áreas de Interesse',
            style: r.heading3.copyWith(
              color: AppColors.darkGreenHeader,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                final isSelected = _interestAreas.contains(option);
                return CheckboxListTile(
                  title: Text(
                    option,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                  ),
                  value: isSelected,
                  activeColor: AppColors.darkGreenHeader,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        if (!_interestAreas.contains(option)) {
                          _interestAreas.add(option);
                        }
                      } else {
                        _interestAreas.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Confirmar',
                style: r.bodyMedium.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStudyFormatsField() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formato de Estudo',
              style: r.label.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingSM),
            InkWell(
              onTap: () => _showStudyFormatDialog(),
              borderRadius: BorderRadius.circular(r.radiusMD),
              child: Container(
                padding: r.pad(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.creamCard,
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  border: Border.all(
                    color: AppColors.darkGreenHeader,
                    width: r.s(1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _studyFormats.isEmpty
                          ? Text(
                              'Selecione formatos de estudo',
                              style: r.bodyMedium.copyWith(
                                color: AppColors.grayText,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _studyFormats.asMap().entries.map((entry) {
                                final index = entry.key;
                                final format = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index < _studyFormats.length - 1 ? r.spacingSM : 0,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: r.isz(24, min: 20, max: 28),
                                        height: r.isz(24, min: 20, max: 28),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.darkGreenHeader,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: r.bodySmall.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: r.spacingSM),
                                      Expanded(
                                        child: Text(
                                          format,
                                          style: r.bodyMedium.copyWith(
                                            color: AppColors.darkGreenHeader,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _studyFormats.removeAt(index);
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: r.isz(18, min: 16, max: 20),
                                          color: AppColors.darkGreenHeader,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    Icon(
                      Icons.edit,
                      color: AppColors.darkGreenHeader,
                      size: r.iconSM,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showStudyFormatDialog() {
    final options = [
      'Fluxogramas/algoritmos',
      'Casos clínicos interativos',
      'Flashcards',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        final r = Responsive.of(dialogContext);
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(
              'Selecione Formatos de Estudo (em ordem)',
              style: r.heading3.copyWith(
                color: AppColors.darkGreenHeader,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((option) {
                  final isSelected = _studyFormats.contains(option);
                  final index = _studyFormats.indexOf(option);
                  return ListTile(
                    title: Text(
                      option,
                      style: r.bodyMedium.copyWith(
                        color: AppColors.darkGreenHeader,
                      ),
                    ),
                    subtitle: isSelected && index >= 0
                        ? Text(
                            'Ordem: ${index + 1}',
                            style: r.bodySmall.copyWith(
                              color: AppColors.mediumGreen,
                            ),
                          )
                        : null,
                    leading: Checkbox(
                      value: isSelected,
                      activeColor: AppColors.darkGreenHeader,
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            if (!_studyFormats.contains(option)) {
                              _studyFormats.add(option);
                            }
                          } else {
                            _studyFormats.remove(option);
                          }
                        });
                      },
                    ),
                    trailing: isSelected && index >= 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (index > 0)
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_upward,
                                    size: r.iconSM,
                                  ),
                                  color: AppColors.darkGreenHeader,
                                  onPressed: () {
                                    setDialogState(() {
                                      final currentIndex = _studyFormats.indexOf(option);
                                      if (currentIndex > 0) {
                                        _studyFormats.removeAt(currentIndex);
                                        _studyFormats.insert(currentIndex - 1, option);
                                      }
                                    });
                                  },
                                ),
                              if (index < _studyFormats.length - 1)
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_downward,
                                    size: r.iconSM,
                                  ),
                                  color: AppColors.darkGreenHeader,
                                  onPressed: () {
                                    setDialogState(() {
                                      final currentIndex = _studyFormats.indexOf(option);
                                      if (currentIndex < _studyFormats.length - 1) {
                                        _studyFormats.removeAt(currentIndex);
                                        _studyFormats.insert(currentIndex + 1, option);
                                      }
                                    });
                                  },
                                ),
                            ],
                          )
                        : null,
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirmar',
                  style: r.bodyMedium.copyWith(
                    color: AppColors.darkGreenHeader,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
