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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkForChanges);
    _confirmPasswordController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {});
  }

  bool get _hasValidChanges {
    return _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _passwordController.text.length >= 6;
  }

  @override
  void dispose() {
    _passwordController.removeListener(_checkForChanges);
    _confirmPasswordController.removeListener(_checkForChanges);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                          constraints: BoxConstraints(
                            minWidth: r.iconMD,
                            minHeight: r.iconMD,
                          ),
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
                    
                    // Campo Senha
                    _buildPasswordField(
                      r: r,
                      label: 'Senha',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      hintText: 'Digite sua nova senha',
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Campo Repetir Senha
                    _buildPasswordField(
                      r: r,
                      label: 'Repita sua senha',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      hintText: 'Digite novamente sua nova senha',
                    ),
                    SizedBox(height: r.spacingXL),
                    
                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _hasValidChanges ? () {
                          // Implementar lógica de troca de senha
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Senha alterada com sucesso!',
                                style: r.bodyMedium,
                              ),
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
                          backgroundColor: _hasValidChanges 
                              ? AppColors.darkGreenHeader 
                              : AppColors.creamCard,
                          foregroundColor: _hasValidChanges 
                              ? Colors.white 
                              : AppColors.grayText,
                          padding: r.pad(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                            side: BorderSide(
                              color: _hasValidChanges 
                                  ? AppColors.darkGreenHeader 
                                  : AppColors.grayLight,
                              width: r.s(2, min: 1.5, max: 2.5),
                            ),
                          ),
                          disabledBackgroundColor: AppColors.creamCard,
                          disabledForegroundColor: AppColors.grayText,
                        ),
                        child: Text(
                          'Salvar',
                          style: r.button.copyWith(
                            color: _hasValidChanges 
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


  Widget _buildPasswordField({
    required Responsive r,
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String hintText,
  }) {
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
          obscureText: obscureText,
          style: r.bodyMedium.copyWith(
            color: AppColors.darkGreenHeader,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.creamCard,
            hintText: hintText,
            hintStyle: r.bodyMedium.copyWith(
              color: AppColors.grayText,
            ),
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
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.darkGreenHeader,
                size: r.iconMD,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }

}
