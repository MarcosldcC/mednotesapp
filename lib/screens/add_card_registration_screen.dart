import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import 'review_data_screen.dart';

class AddCardRegistrationScreen extends StatefulWidget {
  const AddCardRegistrationScreen({super.key});

  @override
  State<AddCardRegistrationScreen> createState() => _AddCardRegistrationScreenState();
}

class _AddCardRegistrationScreenState extends State<AddCardRegistrationScreen> {
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

  double _calculateCardHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.70;
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
      backgroundColor: AppColors.darkGreenHeader,
      body: Stack(
        children: [
          // Header verde escuro com onda no topo (~30% da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: const BoxDecoration(
                  color: AppColors.darkGreenHeader,
                ),
              ),
            ),
          ),
          
          // Card bege na parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(r.r(45, min: 35, max: 50)),
                topRight: Radius.circular(r.r(45, min: 35, max: 50)),
              ),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.70,
                  maxHeight: MediaQuery.of(context).size.height * 0.95,
                ),
                decoration: BoxDecoration(
                  color: AppColors.creamCard,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(r.r(45, min: 35, max: 50)),
                    topRight: Radius.circular(r.r(45, min: 35, max: 50)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: r.s(8),
                      offset: Offset(0, -r.s(2)),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: r.spacingLG),
                      // Linha separadora
                      Center(
                        child: Container(
                          width: r.h(40, min: 32, max: 48),
                          height: r.s(4, min: 3, max: 5),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreenHeader,
                            borderRadius: BorderRadius.circular(r.r(2)),
                          ),
                        ),
                      ),
                      SizedBox(height: r.spacingXXL),
                      // Header com botão voltar e título
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.darkGreenHeader,
                              size: r.iconMD,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              'Adicionar cartão',
                              style: r.heading2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: r.h(48, min: 40, max: 56)), // Balance do botão voltar
                        ],
                      ),
                      SizedBox(height: r.spacingXXXXL),
                      
                      // Visualização do cartão
                      _buildCardVisual(),
                      SizedBox(height: r.spacingXXXXL),
                      
                      // Campo Nome no cartão (padrão: até 26 caracteres)
                      _buildLabeledField(
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
                      SizedBox(height: r.spacingXXL),
                      
                      // Campo Número do cartão (13 a 19 dígitos)
                      _buildLabeledField(
                        label: 'Número do cartão',
                        controller: _cardNumberController,
                        hintText: '0000 0000 0000 0000',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.credit_card,
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
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Este campo é obrigatório';
                          final digits = v.replaceAll(' ', '');
                          if (digits.length < 13 || digits.length > 19) return 'Entre 13 e 19 dígitos';
                          return null;
                        },
                      ),
                      SizedBox(height: r.spacingXXL),
                      
                      // Campos Data e CVV lado a lado
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledField(
                              label: 'Data de Expiração',
                              controller: _expiryDateController,
                              hintText: 'MM/AA',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.calendar_today,
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
                          SizedBox(width: r.spacingLG),
                          Expanded(
                            child: _buildLabeledField(
                              label: 'CVV',
                              controller: _cvvController,
                              hintText: '3 ou 4 dígitos',
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
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
                      SizedBox(height: r.spacingXXXXL),
                      
                      // Botão Salvar Cartão
                      SizedBox(
                        height: r.h(56, min: 48, max: 64),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewDataScreen(
                                    cardNumber: _cardNumberController.text,
                                    cardName: _cardNameController.text,
                                    expiryDate: _expiryDateController.text,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreenHeader,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(r.radiusLG),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Salvar Cartão',
                            style: r.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: r.spacingXXXXL),
                    ],
                  ),
                ),
              ),
            ),
            ),
          ),
        ],
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

  Widget _buildCardVisual() {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Container(
          height: r.h(200, min: 170, max: 230),
          padding: r.pad(all: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkGreenHeader,
                Color(0xFF1A554C),
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
                    width: r.h(50, min: 40, max: 60),
                    height: r.h(40, min: 32, max: 48),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(r.r(4)),
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
                  letterSpacing: r.s(2),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              SizedBox(height: r.spacingXL),
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
                        style: r.bodyLarge.copyWith(
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
                        style: r.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: r.isz(32, min: 28, max: 40),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabeledField({
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
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.mediumGreen,
                    thickness: r.s(1),
                  ),
                ),
                Padding(
                  padding: r.pad(horizontal: 8),
                  child: Text(
                    label,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.mediumGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.mediumGreen,
                    thickness: r.s(1),
                  ),
                ),
              ],
            ),
            SizedBox(height: r.spacingSM),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: r.bodyMedium.copyWith(
                  color: AppColors.grayText,
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
                contentPadding: r.pad(horizontal: 16, vertical: 16),
              ),
              style: r.bodyMedium.copyWith(
                color: AppColors.darkGreenHeader,
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
      },
    );
  }
}
