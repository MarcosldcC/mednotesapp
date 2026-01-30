# Guia de Refatoração Rápida - Aplicar Responsividade

## Padrões de Substituição em Massa

Use estas substituições em TODAS as telas:

### 1. Adicionar Import (no topo do arquivo)
```dart
import '../design/responsive.dart';
```

### 2. Adicionar Responsive no build()
```dart
@override
Widget build(BuildContext context) {
  final r = Responsive.of(context);  // ADICIONAR ESTA LINHA
  // ... resto do código
}
```

### 3. Substituições Comuns

#### SizedBox
```dart
// ANTES
const SizedBox(height: 24)
SizedBox(height: 24)
SizedBox(width: 12)

// DEPOIS
SizedBox(height: r.spacingXXL)  // para 24
SizedBox(height: r.spacingXXL)  // para 24
SizedBox(width: r.spacingMD)    // para 12
```

#### EdgeInsets
```dart
// ANTES
const EdgeInsets.all(16)
EdgeInsets.symmetric(horizontal: 24)
EdgeInsets.fromLTRB(20, 20, 20, 12)
EdgeInsets.only(bottom: 20)

// DEPOIS
r.pad(all: 16)
r.pad(horizontal: 24)
r.pad(left: 20, right: 20, top: 20, bottom: 12)
r.pad(bottom: 20)
```

#### BorderRadius
```dart
// ANTES
BorderRadius.circular(16)
BorderRadius.circular(24)

// DEPOIS
BorderRadius.circular(r.radiusLG)   // para 16
BorderRadius.circular(r.radiusXXL)  // para 24
```

#### Icon Size
```dart
// ANTES
Icon(Icons.home, size: 24)
Icon(Icons.home, size: 32)

// DEPOIS
Icon(Icons.home, size: r.iconMD)  // para 24
Icon(Icons.home, size: r.iconXL)  // para 32
```

#### FontSize / TextStyle
```dart
// ANTES
Text('Título', style: AppTextStyles.heading1)
Text('Corpo', style: AppTextStyles.bodyMedium.copyWith(fontSize: 12))

// DEPOIS
Text('Título', style: r.heading1)
Text('Corpo', style: r.bodySmall)  // usar token apropriado
```

#### Container Height/Width
```dart
// ANTES
Container(height: 70, width: 1)
Container(height: 120)

// DEPOIS
Container(height: r.h(70, min: 60, max: 80), width: r.s(1))
Container(height: r.h(120, min: 100, max: 140))
```

## Mapeamento de Valores Comuns

### Spacing
- 4 → r.spacingXS
- 8 → r.spacingSM
- 12 → r.spacingMD
- 16 → r.spacingLG
- 20 → r.spacingXL
- 24 → r.spacingXXL
- 32 → r.spacingXXXXL

### Radius
- 8 → r.radiusSM
- 12 → r.radiusMD
- 16 → r.radiusLG
- 20 → r.radiusXL
- 24 → r.radiusXXL

### Icon Sizes
- 16 → r.iconXS
- 20 → r.iconSM
- 24 → r.iconMD
- 28 → r.iconLG
- 32 → r.iconXL

### Typography
- AppTextStyles.heading1 → r.heading1
- AppTextStyles.heading2 → r.heading2
- AppTextStyles.heading3 → r.heading3
- AppTextStyles.bodyLarge → r.bodyLarge
- AppTextStyles.bodyMedium → r.bodyMedium
- AppTextStyles.bodySmall → r.bodySmall

## Checklist por Tela

Para cada tela, fazer:

1. [ ] Adicionar `import '../design/responsive.dart';`
2. [ ] Adicionar `final r = Responsive.of(context);` no build()
3. [ ] Substituir todos `const SizedBox(height: X)` por `SizedBox(height: r.spacingXX)`
4. [ ] Substituir todos `EdgeInsets` por `r.pad()` ou `r.margin()`
5. [ ] Substituir todos `BorderRadius.circular(X)` por `BorderRadius.circular(r.radiusXX)`
6. [ ] Substituir todos `Icon(..., size: X)` por `Icon(..., size: r.iconXX)`
7. [ ] Substituir todos `AppTextStyles.XXX` por `r.XXX`
8. [ ] Substituir todos `Container(height: X)` por `Container(height: r.h(X, min: Y, max: Z))`
9. [ ] Testar em diferentes tamanhos de tela

## Ordem de Prioridade

1. ✅ DashboardScreen (em andamento)
2. ⏳ LoginScreen
3. ⏳ RegisterScreen
4. ⏳ WelcomeScreen
5. ⏳ MarketplaceScreen
6. ⏳ ProfileSelectionScreen
7. ⏳ Demais telas...
