import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/settings_service.dart';
import '../design/responsive.dart';
import 'profile_menu_screen.dart';
import 'view_account_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Valores iniciais (centralizados em AppConstants)
  final String _initialName = AppConstants.kDisplayName;
  final String _initialPhone = AppConstants.kDisplayPhone;
  final String _initialEmail = AppConstants.kDisplayEmail;
  final String? _initialUF = null;

  late final TextEditingController _nameController = TextEditingController(text: AppConstants.kDisplayName);
  late final TextEditingController _phoneController = TextEditingController(text: AppConstants.kDisplayPhone);
  late final TextEditingController _emailController = TextEditingController(text: AppConstants.kDisplayEmail);
  String? _selectedUF;

  final List<String> _ufs = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {});
  }

  bool get _hasChanges {
    return _nameController.text != _initialName ||
        _phoneController.text != _initialPhone ||
        _emailController.text != _initialEmail ||
        _selectedUF != _initialUF;
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _phoneController.removeListener(_checkForChanges);
    _emailController.removeListener(_checkForChanges);
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(width: r.spacingSM),
                        Expanded(
                          child: Text(
                            'Editar Dados do Perfil',
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
                        'Troque sua foto, mude suas informações de contato ou acesso.',
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Foto de perfil
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: r.isz(120, min: 80, max: 140),
                            height: r.isz(120, min: 80, max: 140),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.darkGreenHeader,
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/medica.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.mediumGreen,
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: r.isz(36, min: 28, max: 44),
                              height: r.isz(36, min: 28, max: 44),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.darkGreenHeader,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: AppColors.darkGreenHeader,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Campo Nome
                    _buildTextField(
                      label: 'Nome',
                      controller: _nameController,
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Campo Telefone
                    _buildTextField(
                      label: 'Telefone',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Campo E-mail
                    _buildTextField(
                      label: 'E-mail',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Campo UF
                    _buildDropdownField(),
                    SizedBox(height: r.spacingXL),
                    
                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _hasChanges ? () {
                          // Implementar lógica de salvamento
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dados salvos com sucesso!'),
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


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
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
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.creamCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  borderSide: BorderSide(
                    color: AppColors.darkGreenHeader,
                    width: r.s(1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  borderSide: BorderSide(
                    color: AppColors.darkGreenHeader,
                    width: r.s(1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  borderSide: BorderSide(
                    color: AppColors.darkGreenHeader,
                    width: r.s(2, min: 1.5, max: 2.5),
                  ),
                ),
                contentPadding: r.pad(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownField() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UF',
              style: r.label.copyWith(
                color: AppColors.darkGreenHeader,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingSM),
            DropdownButtonFormField<String>(
              value: _selectedUF,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.creamCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  borderSide: BorderSide(
                    color: AppColors.darkGreenHeader,
                    width: r.s(1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  borderSide: BorderSide(
                    color: AppColors.darkGreenHeader,
                    width: r.s(1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  borderSide: BorderSide(
                    color: AppColors.darkGreenHeader,
                    width: r.s(2, min: 1.5, max: 2.5),
                  ),
                ),
                contentPadding: r.pad(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              hint: Text(
                'Selecionar',
                style: r.bodyMedium.copyWith(
                  color: AppColors.grayText,
                ),
              ),
              items: _ufs.map((uf) {
                return DropdownMenuItem<String>(
                  value: uf,
                  child: Text(
                    uf,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUF = value;
                });
                _checkForChanges();
              },
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.darkGreenHeader,
                size: r.iconMD,
              ),
            ),
          ],
        );
      },
    );
  }

}
