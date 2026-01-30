import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/settings_service.dart';
import '../design/responsive.dart';
import 'subscription_management_screen.dart';
import 'profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class AddCardLoggedScreen extends StatefulWidget {
  const AddCardLoggedScreen({super.key});

  @override
  State<AddCardLoggedScreen> createState() => _AddCardLoggedScreenState();
}

class _AddCardLoggedScreenState extends State<AddCardLoggedScreen> {
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              'Adicionar Cartão',
                              style: r.heading2.copyWith(
                                color: AppColors.darkGreenHeader,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXL),
                      
                      // Visualização do cartão
                      _buildCardVisual(r),
                      SizedBox(height: r.spacingXL),
                      
                      // Campo Nome no cartão (padrão: até 26 caracteres como no cartão)
                      _buildLabeledField(
                        r: r,
                        label: 'Nome no cartão',
                        controller: _cardNameController,
                        hintText: 'Nome como no cartão',
                        maxLength: 26,
                        prefixIcon: Icons.person_outline,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Este campo é obrigatório';
                          if (v.length > 26) return 'Máximo 26 caracteres';
                          return null;
                        },
                      ),
                      SizedBox(height: r.spacingLG),
                      
                      // Campo Número do cartão (padrão: 13 a 19 dígitos, ex.: Visa/Master 16, Amex 15)
                      _buildLabeledField(
                        r: r,
                        label: 'Número do cartão',
                        controller: _cardNumberController,
                        hintText: '0000 0000 0000 0000',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(19),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final text = newValue.text.replaceAll(' ', '');
                            if (text.length > 19) return oldValue;
                            String formatted = '';
                            for (int i = 0; i < text.length; i++) {
                              if (i > 0 && i % 4 == 0) formatted += ' ';
                              formatted += text[i];
                            }
                            return TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }),
                        ],
                        prefixIcon: Icons.credit_card,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Este campo é obrigatório';
                          final digits = v.replaceAll(' ', '');
                          if (digits.length < 13 || digits.length > 19) return 'Entre 13 e 19 dígitos';
                          return null;
                        },
                      ),
                      SizedBox(height: r.spacingLG),
                      
                      // Campos Data e CVV lado a lado
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledField(
                              r: r,
                              label: 'Data de Expiração',
                              controller: _expiryDateController,
                              hintText: 'MM/AA',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  final text = newValue.text.replaceAll('/', '');
                                  if (text.length > 4) return oldValue;
                                  if (text.length >= 2) {
                                    return TextEditingValue(
                                      text: '${text.substring(0, 2)}/${text.length > 2 ? text.substring(2) : ''}',
                                      selection: TextSelection.collapsed(offset: text.length >= 2 ? text.length + 1 : text.length),
                                    );
                                  }
                                  return newValue;
                                }),
                              ],
                              prefixIcon: Icons.calendar_today,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Obrigatório';
                                final digits = v.replaceAll('/', '');
                                if (digits.length != 4) return 'Use MM/AA';
                                final month = int.tryParse(digits.substring(0, 2));
                                if (month == null || month < 1 || month > 12) return 'Mês inválido';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: r.spacingMD),
                          Expanded(
                            child: _buildLabeledField(
                              r: r,
                              label: 'CVV',
                              prefixIcon: Icons.lock_outline,
                              controller: _cvvController,
                              hintText: '3 ou 4 dígitos',
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Obrigatório';
                                if (v.length != 3 && v.length != 4) return '3 ou 4 dígitos';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXL),
                      
                      // Botão Salvar Cartão
                      SizedBox(
                        width: double.infinity,
                        height: r.h(56, min: 50, max: 64),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Cartão adicionado com sucesso!',
                                    style: r.bodyMedium,
                                  ),
                                  backgroundColor: AppColors.darkGreenHeader,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SubscriptionManagementScreen(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreenHeader,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(r.radiusMD),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Salvar Cartão',
                            style: r.button,
                          ),
                        ),
                      ),
                      SizedBox(height: r.spacingXL),
                    ],
                  ),
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


  String _formatCardNumber(String number) {
    if (number.isEmpty) return '0000 0000 0000 0000';
    String cleaned = number.replaceAll(' ', '');
    if (cleaned.length > 19) cleaned = cleaned.substring(0, 19);
    String formatted = '';
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) formatted += ' ';
      formatted += cleaned[i];
    }
    return formatted;
  }

  String _formatExpiryDate(String date) {
    if (date.isEmpty) return '00/00';
    String cleaned = date.replaceAll('/', '');
    if (cleaned.length >= 2) {
      return '${cleaned.substring(0, 2)}/${cleaned.length > 2 ? cleaned.substring(2) : '00'}';
    }
    return date.padRight(4, '0');
  }

  Widget _buildCardVisual(Responsive r) {
    return Container(
      height: r.h(200, min: 180, max: 220),
      padding: r.pad(all: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkGreenHeader,
            const Color(0xFF1A554C),
          ],
        ),
        borderRadius: BorderRadius.circular(r.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: r.isz(48, min: 40, max: 56),
                height: r.h(36, min: 30, max: 42),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4C5A9),
                  borderRadius: BorderRadius.circular(r.radiusSM),
                ),
              ),
              Container(
                width: r.isz(50, min: 40, max: 60),
                height: r.h(40, min: 30, max: 50),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(r.radiusXS),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _formatCardNumber(_cardNumberController.text),
            style: r.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: r.spacingLG),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome',
                    style: r.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _cardNameController.text.isEmpty
                        ? 'Nome Sob.'
                        : _cardNameController.text,
                    style: r.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data',
                    style: r.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _formatExpiryDate(_expiryDateController.text),
                    style: r.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.credit_card,
                color: Colors.white,
                size: r.iconLG,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({
    required Responsive r,
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: r.label.copyWith(
            color: AppColors.darkGreenHeader,
          ),
        ),
        SizedBox(height: r.spacingSM),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          style: r.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: r.bodyMedium.copyWith(
              color: AppColors.grayText.withOpacity(0.5),
            ),
            counterText: '',
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.darkGreenHeader, size: r.iconSM)
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.radiusLG),
              borderSide: BorderSide(
                color: AppColors.mediumGreen,
                width: r.s(1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.radiusLG),
              borderSide: BorderSide(
                color: AppColors.mediumGreen,
                width: r.s(1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.radiusLG),
              borderSide: BorderSide(
                color: AppColors.darkGreenHeader,
                width: 2,
              ),
            ),
            contentPadding: r.pad(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) return 'Este campo é obrigatório';
            return null;
          },
          onChanged: (value) {
            setState(() {}); // Atualiza visualização do cartão
          },
        ),
      ],
    );
  }

}
