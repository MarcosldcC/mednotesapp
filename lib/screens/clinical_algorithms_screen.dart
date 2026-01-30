import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';
import '../widgets/algorithm_card.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import 'algorithm_detail_screen.dart';
import 'profile_menu_screen.dart';

/// Tela de listagem de algoritmos clínicos
class ClinicalAlgorithmsScreen extends StatefulWidget {
  const ClinicalAlgorithmsScreen({super.key});

  @override
  State<ClinicalAlgorithmsScreen> createState() => _ClinicalAlgorithmsScreenState();
}

class _ClinicalAlgorithmsScreenState extends State<ClinicalAlgorithmsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Dados mock - em produção viriam de um service/API
  final List<Map<String, dynamic>> _algorithms = [
    {
      'title': 'Abordagem da Dor Torácica',
      'subtitle': 'Fluxogramas clínicos',
      'timeAgo': 'Há dois dias',
    },
    {
      'title': 'Manejo de Hipertensão',
      'subtitle': 'Fluxogramas clínicos',
      'timeAgo': 'Há quatro dias',
    },
    {
      'title': 'Abordagem da Dor Torácica',
      'subtitle': 'Fluxogramas clínicos',
      'timeAgo': 'Há dois dias',
    },
    {
      'title': 'Manejo de Hipertensão',
      'subtitle': 'Fluxogramas clínicos',
      'timeAgo': 'Há quatro dias',
    },
  ];

  List<Map<String, dynamic>> _filteredAlgorithms = [];
  String _selectedCategoryFilter = 'Todos';

  static const List<String> _categoryChips = ['Todos', 'Dor torácica', 'Hipertensão'];

  @override
  void initState() {
    super.initState();
    _filteredAlgorithms = _algorithms;
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      List<Map<String, dynamic>> list = _algorithms;
      if (_selectedCategoryFilter != 'Todos') {
        list = list.where((alg) {
          final title = (alg['title'] as String).toLowerCase();
          return title.contains(_selectedCategoryFilter.toLowerCase());
        }).toList();
      }
      if (query.isNotEmpty) {
        list = list.where((alg) {
          return alg['title'].toString().toLowerCase().contains(query) ||
              alg['subtitle'].toString().toLowerCase().contains(query);
        }).toList();
      }
      _filteredAlgorithms = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const ProfileMenuScreen(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: r.pad(horizontal: 24, top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botão voltar e título
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.darkGreenHeader,
                              size: r.isz(24),
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: r.isz(40),
                              minHeight: r.isz(40),
                            ),
                          ),
                          SizedBox(width: r.spacingSM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Algoritmos Clínicos',
                                  style: r.heading1.copyWith(
                                    color: AppColors.darkGreenHeader,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: r.spacingXS),
                                Text(
                                  'Busque o algoritmo que você deseja',
                                  style: r.bodyMedium.copyWith(
                                    color: AppColors.grayText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingXXL),
                      
                      // Campo de busca com filtro (sempre lado a lado)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(r.radiusMD),
                                border: Border.all(
                                  color: AppColors.darkGreenHeader,
                                  width: r.s(1),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Buscar Algoritmos Clínicos ...',
                                  hintStyle: r.bodyMedium.copyWith(
                                    color: AppColors.grayText,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: AppColors.darkGreenHeader,
                                    size: r.iconMD,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: r.pad(all: 16),
                                ),
                                style: r.bodyMedium.copyWith(
                                  color: AppColors.darkGreenHeader,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: r.spacingSM),
                          Material(
                            color: AppColors.darkGreenHeader,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => _applyFilters(),
                              child: SizedBox(
                                width: r.isz(48),
                                height: r.isz(48),
                                child: Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: r.iconMD,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.spacingLG),
                      Wrap(
                        spacing: r.spacingSM,
                        runSpacing: r.spacingSM,
                        children: _categoryChips.map((label) {
                          final isSelected = _selectedCategoryFilter == label;
                          return FilterChip(
                            label: Text(
                              label,
                              style: r.bodySmall.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.darkGreenHeader,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                _selectedCategoryFilter = label;
                                _applyFilters();
                              }
                            },
                            selectedColor: AppColors.darkGreenHeader,
                            checkmarkColor: Colors.white,
                            side: BorderSide(
                              color: AppColors.darkGreenHeader.withOpacity(0.6),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: r.spacingXL),
                      
                      // Lista de algoritmos
                      if (_filteredAlgorithms.isEmpty)
                        Center(
                          child: Padding(
                            padding: r.pad(vertical: r.spacingXXL),
                            child: Text(
                              'Nenhum algoritmo encontrado',
                              style: r.bodyLarge.copyWith(
                                color: AppColors.grayText,
                              ),
                            ),
                          ),
                        )
                      else
                        ..._filteredAlgorithms.map((algorithm) => Padding(
                              padding: r.pad(bottom: r.spacingMD),
                              child: AlgorithmCard(
                              title: algorithm['title'],
                              subtitle: algorithm['subtitle'],
                              timeAgo: algorithm['timeAgo'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlgorithmDetailScreen(
                                      algorithmTitle: algorithm['title'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                      SizedBox(height: r.spacingXXL),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
