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
import '../data/mock_products.dart';
import 'product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPriceFilter = 'Todos';

  final List<Product> _allProducts = mockProducts;

  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesCategory = widget.category == 'Todas' ||
          product.category == widget.category;

      final searchQuery = _searchController.text.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          product.title.toLowerCase().contains(searchQuery) ||
          product.description.toLowerCase().contains(searchQuery);

      final matchesPrice = _matchesPriceFilter(product.price);

      return matchesCategory && matchesSearch && matchesPrice;
    }).toList();
  }

  bool _matchesPriceFilter(double price) {
    switch (_selectedPriceFilter) {
      case 'Até R\$ 50':
        return price <= 50;
      case 'R\$ 50 - R\$ 100':
        return price > 50 && price <= 100;
      case 'R\$ 100 - R\$ 200':
        return price > 100 && price <= 200;
      case 'Acima de R\$ 200':
        return price > 200;
      case 'Todos':
      default:
        return true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                        Text(
                          widget.category == 'Todas'
                              ? 'Todos os produtos'
                              : widget.category,
                          style: r.heading1.copyWith(
                            color: AppColors.darkGreenHeader,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Barra de busca e filtro
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: r.pad(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              border: Border.all(
                                color: AppColors.mediumGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppColors.grayText,
                                  size: r.iconSM,
                                ),
                                SizedBox(width: r.spacingMD),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (_) => setState(() {}),
                                    decoration: InputDecoration(
                                      hintText: 'Buscar...',
                                      hintStyle: r.bodyMedium.copyWith(
                                        color: AppColors.grayText,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: r.bodyMedium.copyWith(
                                      color: AppColors.darkGreenHeader,
                                    ),
                                  ),
                                ),
                                if (_searchController.text.isNotEmpty)
                                  IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: r.iconXS,
                                    ),
                                    color: AppColors.grayText,
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(
                                      minWidth: r.iconSM,
                                      minHeight: r.iconSM,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: r.spacingMD),
                        Container(
                          width: r.h(48, min: 44, max: 56),
                          height: r.h(48, min: 44, max: 56),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreenHeader,
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: r.iconMD,
                            ),
                            onPressed: () => _showFilterDialog(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingXXL),
                    
                    // Lista de produtos
                    if (_filteredProducts.isEmpty)
                      Center(
                        child: Padding(
                          padding: r.pad(all: 32),
                          child: Text(
                            'Nenhum produto encontrado',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.grayText,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._filteredProducts.map((product) => Padding(
                        padding: r.pad(bottom: 12),
                        child: _buildProductCard(product: product),
                      )),
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

  Widget _buildProductCard({required Product product}) {
    final r = Responsive.of(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        padding: r.pad(all: 16),
        decoration: BoxDecoration(
          color: AppColors.creamCard,
          borderRadius: BorderRadius.circular(r.radiusMD),
          border: Border.all(
            color: AppColors.mediumGreen.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem placeholder
            Container(
              width: r.h(80, min: 70, max: 100),
              height: r.h(80, min: 70, max: 100),
              decoration: BoxDecoration(
                color: AppColors.grayLight,
                borderRadius: BorderRadius.circular(r.radiusSM),
              ),
              child: Icon(
                Icons.image,
                color: AppColors.grayText,
                size: r.isz(32, min: 28, max: 40),
              ),
            ),
            SizedBox(width: r.spacingLG),
            // Conteúdo do card
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: r.spacingXS),
                  Text(
                    product.description,
                    style: r.bodySmall.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: r.spacingSM),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: r.isz(14, min: 12, max: 18),
                        color: Colors.amber,
                      ),
                      SizedBox(width: r.spacingXS),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: r.bodySmall.copyWith(
                          color: AppColors.grayText,
                        ),
                      ),
                      SizedBox(width: r.spacingSM),
                      Flexible(
                        child: Text(
                          '${product.acquiredCount} já adquiriram',
                          style: r.bodySmall.copyWith(
                            color: AppColors.grayText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Preço e seta
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.chevron_right,
                  color: AppColors.darkGreenHeader,
                  size: r.iconSM,
                ),
                SizedBox(height: r.spacingSM),
                Text(
                  'R\$${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: r.bodyMedium.copyWith(
                    color: AppColors.darkGreenHeader,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final r = Responsive.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.radiusLG),
              ),
              title: Text(
                'Filtros',
                style: r.heading3.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preço',
                      style: r.bodyMedium.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    ...['Todos', 'Até R\$ 50', 'R\$ 50 - R\$ 100', 'R\$ 100 - R\$ 200', 'Acima de R\$ 200'].map((price) => RadioListTile<String>(
                      title: Text(
                        price,
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                      value: price,
                      groupValue: _selectedPriceFilter,
                      activeColor: AppColors.darkGreenHeader,
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedPriceFilter = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    )),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _selectedPriceFilter = 'Todos';
                    });
                  },
                  child: Text(
                    'Limpar',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.grayText,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    setState(() {});
                  },
                  child: Text(
                    'Aplicar',
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
      },
    );
  }
}
