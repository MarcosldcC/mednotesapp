import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../design/responsive.dart';
import '../widgets/custom_clipper.dart';
import '../screens/payment_method_registration_screen.dart';
import '../screens/dashboard_screen.dart';

// ---------------------------------------------------------------------------
// Estado do ciclo de cobrança (Mensal / Anual)
// ---------------------------------------------------------------------------
enum BillingCycle { monthly, annual }

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  // Estado do toggle: apenas ciclo selecionado (ValueNotifier para rebuild local)
  final ValueNotifier<BillingCycle> _selectedCycle =
      ValueNotifier(BillingCycle.monthly);

  @override
  void dispose() {
    _selectedCycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
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
                    padding: r.pad(
                      horizontal: 24,
                      vertical: r.spacingLG,
                      bottom: MediaQuery.paddingOf(context).bottom + r.spacingLG,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: r.spacingLG),
                        // Handle visual
                        Center(
                          child: Container(
                            width: r.h(40, min: 32, max: 48),
                            height: r.s(4, min: 3, max: 5),
                            decoration: BoxDecoration(
                              color: AppColors.darkGreenHeader,
                              borderRadius:
                                  BorderRadius.circular(r.r(2)),
                            ),
                          ),
                        ),
                        SizedBox(height: r.spacingXXXXL),
                        // 1) Header: título mais forte, subtítulo opcional
                        Text(
                          'Escolha seu plano',
                          style: r.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingSM),
                        Text(
                          'Escolha o que faz sentido para você',
                          style: r.bodyMedium.copyWith(
                            color: AppColors.grayText,
                            fontSize: r.fs(14, min: 12, max: 16),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: r.spacingXXXXL),
                        // 2) Toggle Pill (Mensal | Anual)
                        BillingPillToggle(
                          selectedCycle: _selectedCycle,
                          onCycleChanged: (cycle) {
                            _selectedCycle.value = cycle;
                            HapticFeedback.selectionClick();
                          },
                        ),
                        SizedBox(height: r.spacingLG),
                        // 3) Card Premium (principal)
                        ValueListenableBuilder<BillingCycle>(
                          valueListenable: _selectedCycle,
                          builder: (context, cycle, _) {
                            return PremiumPlanCard(
                              cycle: cycle,
                              onChooseTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentMethodRegistrationScreen(),
                                  ),
                                );
                              },
                              buildPlanDetails: _buildPlanDetails,
                              buildFeature: _buildFeature,
                            );
                          },
                        ),
                        SizedBox(height: r.spacingLG),
                        // 4) Bloco Institucional (expansível com formulário)
                        InstitutionalCard(
                          onSubmitted: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Solicitação enviada. Entraremos em contato.'),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: r.spacingXXL),
                        // 5) Plano Free em destaque (bem visível)
                        ContinueFreeCard(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: r.spacingLG),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetails(String planId) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        if (planId == 'premium') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tudo do plano Free, além de:',
                style: r.bodyMedium.copyWith(color: Colors.white),
              ),
              SizedBox(height: r.spacingLG),
              _buildFeature('Personalização inteligente de perfil'),
              _buildFeature('Gamificação avançada'),
              _buildFeature('Chat com IA clínica'),
              _buildFeature(
                  'Análises personalizadas de condutas e estudos'),
              _buildFeature('Casos clínicos ilimitados'),
              _buildFeature('Modo Plantão ilimitado'),
              _buildFeature('Modo offline'),
              _buildFeature(
                  'Recomendações e trilhas adaptadas por IA'),
              _buildFeature('Acesso completo ao Marketplace'),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFeature(String text) {
    return Builder(
      builder: (context) {
        final r = Responsive.of(context);
        return Padding(
          padding: r.pad(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: r.isz(20, min: 18, max: 24),
                height: r.isz(20, min: 18, max: 24),
                decoration: BoxDecoration(
                  color: AppColors.darkGreenHeader,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: r.s(2),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: r.isz(12, min: 10, max: 16),
                ),
              ),
              SizedBox(width: r.spacingMD),
              Expanded(
                child: Text(
                  text,
                  style: r.bodyMedium.copyWith(color: Colors.white),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// BillingPillToggle: segmented control Mensal | Anual, pill deslizante
// Duração 200ms, Curves.easeOutCubic; feedback tátil no tap
// ---------------------------------------------------------------------------
class BillingPillToggle extends StatelessWidget {
  const BillingPillToggle({
    super.key,
    required this.selectedCycle,
    required this.onCycleChanged,
  });

  final ValueNotifier<BillingCycle> selectedCycle;
  final void Function(BillingCycle) onCycleChanged;

  static const _duration = Duration(milliseconds: 200);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return ValueListenableBuilder<BillingCycle>(
      valueListenable: selectedCycle,
      builder: (context, cycle, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            return Container(
              height: r.h(48, min: 44, max: 56),
              decoration: BoxDecoration(
                color: AppColors.darkGreenHeader.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              padding: EdgeInsets.all(r.s(4, min: 3, max: 6)),
              child: Stack(
                children: [
                  // Pill deslizante
                  AnimatedAlign(
                    duration: _duration,
                    curve: _curve,
                    alignment: cycle == BillingCycle.monthly
                        ? const Alignment(-0.5, 0)
                        : const Alignment(0.5, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Container(
                        margin: EdgeInsets.all(r.s(2, min: 1, max: 4)),
                        decoration: BoxDecoration(
                          color: AppColors.darkGreenHeader,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: r.s(4),
                              offset: Offset(0, r.s(1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Labels
                  Row(
                    children: [
                      Expanded(
                        child: _PillSegment(
                          label: 'Mensal',
                          isSelected: cycle == BillingCycle.monthly,
                          onTap: () =>
                              onCycleChanged(BillingCycle.monthly),
                        ),
                      ),
                      Expanded(
                        child: _PillSegment(
                          label: 'Anual',
                          isSelected: cycle == BillingCycle.annual,
                          onTap: () => onCycleChanged(BillingCycle.annual),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PillSegment extends StatelessWidget {
  const _PillSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedDefaultTextStyle(
          duration: BillingPillToggle._duration,
          curve: BillingPillToggle._curve,
          style: r.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.grayText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: BillingPillToggle._duration,
              opacity: isSelected ? 1.0 : 0.85,
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget que ocupa uma fração da largura do pai (para o pill)
class FractionallySizedBox extends StatelessWidget {
  const FractionallySizedBox({
    super.key,
    required this.widthFactor,
    required this.child,
  });

  final double widthFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth * widthFactor;
        return SizedBox(width: w, child: child);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// PremiumPlanCard: card único Premium, estado visual por ciclo
// AnimatedContainer (borda/sombra), pulse ao trocar ciclo, AnimatedSwitcher (preço/CTA)
// ---------------------------------------------------------------------------
class PremiumPlanCard extends StatefulWidget {
  const PremiumPlanCard({
    super.key,
    required this.cycle,
    required this.onChooseTap,
    required this.buildPlanDetails,
    required this.buildFeature,
  });

  final BillingCycle cycle;
  final VoidCallback onChooseTap;
  final Widget Function(String planId) buildPlanDetails;
  final Widget Function(String text) buildFeature;

  @override
  State<PremiumPlanCard> createState() => _PremiumPlanCardState();
}

class _PremiumPlanCardState extends State<PremiumPlanCard>
    with SingleTickerProviderStateMixin {
  static const _pulseDuration = Duration(milliseconds: 260);
  static const _baseDuration = Duration(milliseconds: 200);

  bool _benefitsExpanded = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: _pulseDuration,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.015).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant PremiumPlanCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cycle != widget.cycle) {
      _pulseController.forward(from: 0).then((_) {
        _pulseController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final isAnnual = widget.cycle == BillingCycle.annual;

    // Preço: mensal R$ 39,90; anual 39,90*12 com 20% de desconto = 383,04
    const priceMonthly = 'R\$ 39,90 / mês';
    const priceAnnual = 'R\$ 383,04 / ano';
    const annualDiscount = '20% de desconto';

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: _baseDuration,
        curve: Curves.easeOut,
        padding: r.pad(all: 20),
        decoration: BoxDecoration(
          color: AppColors.darkGreenHeader,
          borderRadius: BorderRadius.circular(r.radiusLG),
          border: Border.all(
            color: isAnnual
                ? AppColors.creamCard.withOpacity(0.4)
                : Colors.transparent,
            width: r.s(2, min: 1.5, max: 2.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isAnnual ? 0.2 : 0.12),
              blurRadius: r.s(isAnnual ? 12 : 8),
              spreadRadius: r.s(isAnnual ? 1 : 0),
              offset: Offset(0, r.s(2)),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título do plano
            Text(
              'Plano Premium',
              style: r.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.spacingMD),
            Image.asset(
              'assets/images/premium.png',
              width: r.isz(60, min: 50, max: 80),
              height: r.isz(60, min: 50, max: 80),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: r.isz(60, min: 50, max: 80),
              ),
            ),
            SizedBox(height: r.spacingMD),
            // Badge 20% no anual
            AnimatedSize(
              duration: _baseDuration,
              curve: Curves.easeOut,
              child: isAnnual
                  ? AnimatedOpacity(
                      duration: _baseDuration,
                      opacity: 1,
                      child: Padding(
                        padding: r.pad(bottom: r.spacingSM),
                        child: Text(
                          annualDiscount,
                          style: r.caption.copyWith(
                            color: AppColors.creamCard,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Preço: AnimatedSwitcher com Key por ciclo
            AnimatedSwitcher(
              duration: _baseDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final offsetAnim = Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(animation);
                final fadeAnim = animation;
                return FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: offsetAnim,
                    child: child,
                  ),
                );
              },
              child: Text(
                isAnnual ? priceAnnual : priceMonthly,
                key: ValueKey(widget.cycle),
                style: r.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: r.spacingMD),
            // Área clicável para expandir benefícios
            GestureDetector(
              onTap: () => setState(() => _benefitsExpanded = !_benefitsExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _benefitsExpanded ? 'Ocultar benefícios' : 'Ver benefícios',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.creamCard,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: r.spacingXS),
                  Icon(
                    _benefitsExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.creamCard,
                    size: r.iconMD,
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: r.pad(top: r.spacingLG),
                child: widget.buildPlanDetails('premium'),
              ),
              crossFadeState: _benefitsExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: _baseDuration,
            ),
            SizedBox(height: r.spacingXXL),
            // CTA: AnimatedSwitcher com Key por ciclo (mesmo texto, key para transição)
            AnimatedSwitcher(
              duration: _baseDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final offsetAnim = Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(animation);
                final fadeAnim = animation;
                return FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: offsetAnim,
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                key: ValueKey('cta_${widget.cycle}'),
                width: double.infinity,
                height: r.h(56, min: 48, max: 64),
                child: ElevatedButton(
                  onPressed: widget.onChooseTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.creamCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.radiusLG),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Escolher esse',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// InstitutionalCard: título, ao clicar expande com formulário (Nome, Contato, etc.)
// ---------------------------------------------------------------------------
class InstitutionalCard extends StatefulWidget {
  const InstitutionalCard({
    super.key,
    required this.onSubmitted,
  });

  final VoidCallback onSubmitted;

  @override
  State<InstitutionalCard> createState() => _InstitutionalCardState();
}

class _InstitutionalCardState extends State<InstitutionalCard> {
  bool _expanded = false;
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _contatoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _instituicaoCtrl = TextEditingController();
  final _regiaoCtrl = TextEditingController();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _contatoCtrl.dispose();
    _emailCtrl.dispose();
    _instituicaoCtrl.dispose();
    _regiaoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      padding: r.pad(all: 16),
      decoration: BoxDecoration(
        color: AppColors.darkGreenHeader.withOpacity(0.85),
        borderRadius: BorderRadius.circular(r.radiusLG),
        border: Border.all(
          color: AppColors.darkGreenHeader.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/institucional.png',
                  width: r.isz(48, min: 40, max: 64),
                  height: r.isz(48, min: 40, max: 64),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.business,
                    color: Colors.white,
                    size: r.isz(48, min: 40, max: 64),
                  ),
                ),
                SizedBox(width: r.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plano Institucional',
                        style: r.heading3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: r.spacingXS),
                      Text(
                        _expanded ? 'Toque para recolher' : 'Toque para preencher e enviar',
                        style: r.bodySmall.copyWith(
                          color: AppColors.creamCard.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                  size: r.iconLG,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: r.pad(top: r.spacingLG),
              child: _buildForm(r),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(Responsive r) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(r, controller: _nomeCtrl, label: 'Nome', hint: 'Seu nome'),
          SizedBox(height: r.spacingMD),
          _buildTextField(r, controller: _contatoCtrl, label: 'Contato', hint: 'Telefone ou WhatsApp'),
          SizedBox(height: r.spacingMD),
          _buildTextField(r, controller: _emailCtrl, label: 'E-mail', hint: 'seu@email.com', keyboardType: TextInputType.emailAddress),
          SizedBox(height: r.spacingMD),
          _buildTextField(r, controller: _instituicaoCtrl, label: 'Instituição', hint: 'Nome da instituição'),
          SizedBox(height: r.spacingMD),
          _buildTextField(r, controller: _regiaoCtrl, label: 'Região e localização', hint: 'Cidade, estado ou região'),
          SizedBox(height: r.spacingLG),
          SizedBox(
            height: r.h(48, min: 44, max: 56),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  widget.onSubmitted();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.creamCard,
                foregroundColor: AppColors.darkGreenHeader,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.radiusMD),
                ),
              ),
              child: Text(
                'Enviar',
                style: r.bodyMedium.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(Responsive r, {required TextEditingController controller, required String label, required String hint, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: r.bodyMedium.copyWith(color: AppColors.darkGreenHeader),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.radiusMD),
        ),
        labelStyle: TextStyle(color: AppColors.darkGreenHeader),
        hintStyle: TextStyle(color: AppColors.grayText),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha este campo' : null,
    );
  }
}

// ---------------------------------------------------------------------------
// ContinueFreeCard: Plano Free em destaque (não escondido)
// ---------------------------------------------------------------------------
class ContinueFreeCard extends StatelessWidget {
  const ContinueFreeCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.radiusLG),
        child: Container(
          width: double.infinity,
          padding: r.pad(all: 20),
          decoration: BoxDecoration(
            color: AppColors.creamCard,
            borderRadius: BorderRadius.circular(r.radiusLG),
            border: Border.all(
              color: AppColors.darkGreenHeader.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: r.s(8),
                offset: Offset(0, r.s(2)),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Plano Free',
                style: r.heading3.copyWith(
                  color: AppColors.darkGreenHeader,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: r.spacingSM),
              Text(
                'Comece grátis com recursos essenciais',
                style: r.bodyMedium.copyWith(color: AppColors.grayText),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: r.spacingLG),
              SizedBox(
                width: double.infinity,
                height: r.h(52, min: 48, max: 56),
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkGreenHeader,
                    side: const BorderSide(color: AppColors.darkGreenHeader, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.radiusMD),
                    ),
                  ),
                  child: Text(
                    'Continuar com o plano Free',
                    style: r.bodyMedium.copyWith(
                      color: AppColors.darkGreenHeader,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

