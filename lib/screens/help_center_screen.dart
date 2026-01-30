import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../design/responsive.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedFilter = 'Todos';

  final List<_FaqItem> _allFaqs = const [
    _FaqItem(
      question: 'Como atualizar meus dados?',
      answer: 'Acesse Perfil > Editar Conta e salve suas alterações.',
      category: 'Conta',
    ),
    _FaqItem(
      question: 'Como alterar meu plano?',
      answer: 'Vá em Perfil > Gerenciar Assinatura para mudar o plano.',
      category: 'Plano',
    ),
    _FaqItem(
      question: 'Como falar com suporte?',
      answer: 'Envie sua dúvida pelo campo abaixo.',
      category: 'Suporte',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  List<_FaqItem> get _filteredFaqs {
    final query = _searchController.text.trim().toLowerCase();
    return _allFaqs.where((item) {
      final matchesQuery = query.isEmpty ||
          item.question.toLowerCase().contains(query) ||
          item.answer.toLowerCase().contains(query);
      final matchesFilter =
          _selectedFilter == 'Todos' || item.category == _selectedFilter;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppColors.creamCard,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: r.pad(horizontal: 24, vertical: r.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            'Central de Ajuda',
                            style: r.heading2.copyWith(
                              color: AppColors.darkGreenHeader,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spacingMD),
                    Text(
                      'Encontre respostas rápidas ou envie sua dúvida.',
                      style: r.bodyMedium.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                    SizedBox(height: r.spacingLG),
                    Text(
                      'Buscar perguntas',
                      style: r.label.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: r.pad(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(r.radiusMD),
                              border: Border.all(
                                color: AppColors.darkGreenHeader,
                                width: r.s(1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppColors.grayText,
                                  size: r.iconMD,
                                ),
                                SizedBox(width: r.spacingMD),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (_) => setState(() {}),
                                    decoration: InputDecoration(
                                      hintText: 'Pesquisar dúvidas...',
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
                    SizedBox(height: r.spacingLG),
                    Text(
                      'Perguntas frequentes',
                      style: r.label.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    ..._filteredFaqs.map((item) => Padding(
                          padding: EdgeInsets.only(bottom: r.spacingSM),
                          child: _buildFaqItem(
                            r,
                            question: item.question,
                            answer: item.answer,
                          ),
                        )),
                    SizedBox(height: r.spacingLG),
                    Text(
                      'Enviar dúvida por e-mail',
                      style: r.label.copyWith(
                        color: AppColors.darkGreenHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: r.spacingSM),
                    Container(
                      padding: r.pad(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.radiusMD),
                        border: Border.all(
                          color: AppColors.darkGreenHeader,
                          width: r.s(1),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Escreva sua dúvida...',
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
                    SizedBox(height: r.spacingLG),
                    SizedBox(
                      width: double.infinity,
                      height: r.h(56, min: 50, max: 64),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_messageController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Escreva sua dúvida antes de enviar.'),
                              ),
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mensagem enviada com sucesso!'),
                            ),
                          );
                          _messageController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreenHeader,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.radiusMD),
                          ),
                        ),
                        child: Text(
                          'Enviar',
                          style: r.button.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }
  Widget _buildFaqItem(
    Responsive r, {
    required String question,
    required String answer,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Container(
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.radiusMD),
        border: Border.all(
          color: AppColors.darkGreenHeader,
          width: r.s(1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: r.bodyMedium.copyWith(
              color: AppColors.darkGreenHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: r.spacingXS),
          Text(
            answer,
            style: r.bodySmall.copyWith(
              color: AppColors.grayText,
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final r = Responsive.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(r.radiusLG),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: r.pad(horizontal: 24, vertical: r.spacingLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrar por',
                style: r.heading3.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: r.spacingMD),
              ...['Todos', 'Conta', 'Plano', 'Suporte'].map(
                (option) => RadioListTile<String>(
                  title: Text(
                    option,
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                    ),
                  ),
                  value: option,
                  groupValue: _selectedFilter,
                  activeColor: AppColors.darkGreenHeader,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedFilter = value;
                      });
                      Navigator.pop(context);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  final String category;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
