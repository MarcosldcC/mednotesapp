import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/glass_card.dart';
import '../screens/profile_menu_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/chat_floating_button.dart';

class NewsItem {
  final String headline;
  final String source;
  final String timeAgo;
  final String? url;
  final DateTime date;

  NewsItem({
    required this.headline,
    required this.source,
    required this.timeAgo,
    this.url,
    required this.date,
  });
}

class TrendingNewsScreen extends StatefulWidget {
  const TrendingNewsScreen({super.key});

  @override
  State<TrendingNewsScreen> createState() => _TrendingNewsScreenState();
}

class _TrendingNewsScreenState extends State<TrendingNewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSource = 'Todas';
  String _selectedTimeFilter = 'Todas';

  final List<NewsItem> _allNews = [
    NewsItem(
      headline: 'Brasil Registra alta no número de óbitos por picadas de escorpião',
      source: 'Health Brasil',
      timeAgo: 'Há quatro dias',
      url: null,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    NewsItem(
      headline: 'Nova vacina contra dengue é aprovada pela ANVISA',
      source: 'Ministério da Saúde',
      timeAgo: 'Há dois dias',
      url: null,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NewsItem(
      headline: 'Aumento de casos de gripe no inverno preocupa especialistas',
      source: 'Health Brasil',
      timeAgo: 'Há uma semana',
      url: null,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    NewsItem(
      headline: 'Campanha de vacinação contra sarampo começa em todo país',
      source: 'Ministério da Saúde',
      timeAgo: 'Há três dias',
      url: null,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NewsItem(
      headline: 'Pesquisa revela eficácia de novo tratamento para diabetes',
      source: 'Health Brasil',
      timeAgo: 'Há cinco dias',
      url: null,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  List<NewsItem> get _filteredNews {
    return _allNews.where((news) {
      // Filtro de busca
      final searchQuery = _searchController.text.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          news.headline.toLowerCase().contains(searchQuery) ||
          news.source.toLowerCase().contains(searchQuery);

      // Filtro por fonte
      final matchesSource = _selectedSource == 'Todas' ||
          news.source == _selectedSource;

      // Filtro por tempo
      final matchesTime = _matchesTimeFilter(news.date);

      return matchesSearch && matchesSource && matchesTime;
    }).toList();
  }

  bool _matchesTimeFilter(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    switch (_selectedTimeFilter) {
      case 'Hoje':
        return difference.inDays == 0;
      case 'Última semana':
        return difference.inDays <= 7;
      case 'Último mês':
        return difference.inDays <= 30;
      case 'Todas':
      default:
        return true;
    }
  }

  List<String> get _availableSources {
    final sources = _allNews.map((news) => news.source).toSet().toList();
    sources.sort();
    return ['Todas', ...sources];
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
                          'Noticias em Alta',
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
                                      hintText: 'Buscar noticias em alta...',
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
                    
                    // Lista de notícias filtradas
                    if (_filteredNews.isEmpty)
                      Center(
                        child: Padding(
                          padding: r.pad(all: 32),
                          child: Text(
                            'Nenhuma notícia encontrada',
                            style: r.bodyMedium.copyWith(
                              color: AppColors.grayText,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._filteredNews.map((news) => Padding(
                        padding: r.pad(bottom: 12),
                        child: _buildNewsCard(
                          headline: news.headline,
                          source: 'Fonte: ${news.source}',
                          timeAgo: news.timeAgo,
                          url: news.url,
                        ),
                      )),
                    SizedBox(height: r.spacingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 4),
      floatingActionButton: const ChatFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                      'Fonte',
                      style: r.bodyMedium.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    ..._availableSources.map((source) => RadioListTile<String>(
                      title: Text(
                        source,
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                      value: source,
                      groupValue: _selectedSource,
                      activeColor: AppColors.darkGreenHeader,
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedSource = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    )),
                    SizedBox(height: r.spacingLG),
                    Text(
                      'Período',
                      style: r.bodyMedium.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    ...['Todas', 'Hoje', 'Última semana', 'Último mês'].map((period) => RadioListTile<String>(
                      title: Text(
                        period,
                        style: r.bodyMedium.copyWith(
                          color: AppColors.darkGreenHeader,
                        ),
                      ),
                      value: period,
                      groupValue: _selectedTimeFilter,
                      activeColor: AppColors.darkGreenHeader,
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedTimeFilter = value!;
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
                      _selectedSource = 'Todas';
                      _selectedTimeFilter = 'Todas';
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

  Widget _buildNewsCard({
    required String headline,
    required String source,
    required String timeAgo,
    String? url,
  }) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        final isLargeText = MediaQuery.textScaleFactorOf(context) > 1.3;
        return GlassCard(
          padding: r.pad(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: r.bodyMedium.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: r.spacingSM),
              Text(
                source,
                style: r.bodySmall.copyWith(
                  color: AppColors.grayText,
                ),
              ),
              SizedBox(height: r.spacingXS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: r.isz(14, min: 12, max: 18),
                        color: AppColors.grayText,
                      ),
                      SizedBox(width: r.spacingXS),
                      Text(
                        timeAgo,
                        style: r.bodySmall.copyWith(
                          color: AppColors.grayText,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (url != null && url.isNotEmpty) {
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                    child: isLargeText
                        ? Icon(
                            Icons.visibility,
                            size: r.iconXS,
                            color: AppColors.darkGreenHeader,
                          )
                        : Row(
                            children: [
                              Text(
                                'Ver mais',
                                style: r.bodySmall.copyWith(
                                  color: AppColors.darkGreenHeader,
                                  decoration: url != null && url.isNotEmpty 
                                      ? TextDecoration.underline 
                                      : TextDecoration.none,
                                ),
                              ),
                              SizedBox(width: r.spacingXS),
                              Icon(
                                Icons.chevron_right,
                                size: r.iconXS,
                                color: AppColors.darkGreenHeader,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
