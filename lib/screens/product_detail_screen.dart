import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../screens/profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

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
                    SizedBox(height: r.spacingXXL),
                    
                    // Título com botão voltar
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
                            product.title,
                            style: r.heading1.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Imagem do produto
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: r.h(200, min: 160, max: 240),
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(r.radiusMD),
                        ),
                        child: Icon(
                          Icons.image,
                          color: AppColors.grayText,
                          size: r.isz(64, min: 50, max: 80),
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Informações do produto
                    Text(
                      product.description,
                      style: r.bodyMedium.copyWith(
                        color: AppColors.darkGreenHeader,
                      ),
                    ),
                    SizedBox(height: r.spacingLG),
                    
                    // Avaliação e aquisições
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: r.iconSM,
                          color: Colors.amber,
                        ),
                        SizedBox(width: r.spacingXS),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: r.bodyMedium.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: r.spacingLG),
                        Flexible(
                          child: Text(
                            '${product.acquiredCount} já adquiriram',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.grayText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Preço
                    Container(
                      padding: r.pad(all: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.radiusMD),
                        border: Border.all(
                          color: AppColors.mediumGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preço',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.darkGreenHeader,
                            ),
                          ),
                          Text(
                            'R\$${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: r.heading3.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Botão de compra
                    SizedBox(
                      width: double.infinity,
                      height: r.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implementar compra
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreenHeader,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                        ),
                        child: Text(
                          'Adquirir',
                          style: r.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
