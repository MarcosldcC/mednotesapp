import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../screens/profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../models/product.dart';
import '../data/mock_products.dart';
import '../design/responsive.dart';
import '../widgets/glass_card.dart';
import 'category_products_screen.dart';
import 'product_detail_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';
  String _selectedPriceFilter = 'Todos';

  final List<Product> _allProducts = mockProducts;

  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final searchQuery = _searchController.text.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          product.title.toLowerCase().contains(searchQuery) ||
          product.description.toLowerCase().contains(searchQuery);

      final matchesCategory = _selectedCategory == 'Todas' ||
          product.category == _selectedCategory;

      final matchesPrice = _matchesPriceFilter(product.price);

      return matchesSearch && matchesCategory && matchesPrice;
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
                child: Padding(
                  padding: r.pad(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: r.spacingXXL),
                      
                      // Título e subtítulo
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Marketplace',
                                  style: r.heading1.copyWith(
                                    color: AppColors.darkGreenHeader,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: r.spacingXS),
                                Text(
                                  'Conteúdo especializado para sua carreira médica',
                                  style: r.bodyMedium.copyWith(
                                    color: AppColors.darkGreenHeader,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXXL),
                      
                      // Barra de busca e filtro
                      Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              padding: r.pad(horizontal: 16, vertical: 12),
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
                                        hintText: 'Buscar Conteúdo...',
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
                      SizedBox(height: r.spacingXXXXL),
                      
                      // Seção: Categorias
                      Text(
                        'Categorias',
                        style: r.heading3.copyWith(
                          color: AppColors.darkGreenHeader,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: r.spacingLG),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CategoryProductsScreen(
                                      category: 'Livros',
                                    ),
                                  ),
                                );
                              },
                              child: _buildCategoryCard(
                                icon: Icons.menu_book,
                                title: 'Livros',
                                itemCount:
                                    "${_allProducts.where((p) => p.category == 'Livros').length} itens",
                              ),
                            ),
                          ),
                          SizedBox(width: r.spacingMD),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CategoryProductsScreen(
                                      category: 'Cursos',
                                    ),
                                  ),
                                );
                              },
                              child: _buildCategoryCard(
                                icon: Icons.local_hospital,
                                title: 'Cursos',
                                itemCount:
                                    "${_allProducts.where((p) => p.category == 'Cursos').length} itens",
                              ),
                            ),
                          ),
                          SizedBox(width: r.spacingMD),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CategoryProductsScreen(
                                      category: 'Itens',
                                    ),
                                  ),
                                );
                              },
                              child: _buildCategoryCard(
                                icon: Icons.shopping_cart,
                                title: 'Itens',
                                itemCount:
                                    "${_allProducts.where((p) => p.category == 'Itens').length} itens",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXXXXL),
                      
                      // Seção: Em destaque
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Em destaque',
                            style: r.heading3.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoryProductsScreen(
                                    category: 'Todas',
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Ver todos',
                              style: r.bodyMedium.copyWith(
                                color: AppColors.darkGreenHeader,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingLG),
                      
                      // Cards de produtos em destaque
                      ...(_filteredProducts.isEmpty
                          ? [
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
                              ),
                            ]
                          : _filteredProducts.take(3).map((product) => Padding(
                                padding: r.pad(bottom: 12),
                                child: _buildFeaturedCard(product: product),
                              )).toList()),
                      SizedBox(height: r.spacingXXL),
                    ],
                  ),
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

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String itemCount,
  }) {
    final r = Responsive.of(context);
    
    return GlassCard(
      padding: r.pad(all: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.darkGreenHeader,
            size: r.isz(32, min: 28, max: 40),
          ),
          SizedBox(height: r.spacingSM),
          Text(
            title,
            style: r.bodyMedium.copyWith(
              color: AppColors.darkGreenHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: r.spacingXS),
          Text(
            itemCount,
            style: r.bodySmall.copyWith(
              color: AppColors.grayText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard({required Product product}) {
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
      child: GlassCard(
        padding: r.pad(all: 16),
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
                      'Categoria',
                      style: r.bodyMedium.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    ...['Todas', 'Livros', 'Cursos', 'Itens'].map((category) => RadioListTile<String>(
                      title: Text(
                        category,
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                      value: category,
                      groupValue: _selectedCategory,
                      activeColor: AppColors.darkGreenHeader,
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedCategory = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    )),
                    SizedBox(height: r.spacingLG),
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
                      _selectedCategory = 'Todas';
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
