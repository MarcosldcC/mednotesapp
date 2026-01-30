# Guia de Responsividade - MedNotes

## Sistema de Design Responsivo

Este documento descreve o sistema de responsividade implementado no app MedNotes e como aplicá-lo em todas as telas.

## Arquitetura

### Arquivo Central
- **`lib/design/responsive.dart`**: Sistema completo de responsividade com breakpoints, funções de escala e tokens.

### Integração
- **`lib/main.dart`**: Sistema integrado no `MaterialApp` com tipografia responsiva global.

## Breakpoints

```dart
xs: < 360px    // Telas muito pequenas
sm: 360-399px  // Telas pequenas
md: 400-479px  // Telas médias
lg: 480-599px  // Telas grandes
xl: >= 600px   // Tablets
```

## Uso Básico

### 1. Importar o sistema

```dart
import '../design/responsive.dart';
```

### 2. Obter instância de Responsive

```dart
final r = Responsive.of(context);
// OU usar extensão:
context.r
```

### 3. Usar funções de escala

```dart
// Spacing (padding, margin, gaps)
SizedBox(height: context.s(24))  // Escala baseada no breakpoint
SizedBox(height: context.s(24, min: 16, max: 32))  // Com limites

// Font size (com clamp obrigatório)
Text('Título', style: TextStyle(fontSize: context.fs(28)))

// Icon size
Icon(Icons.home, size: context.isz(24))

// Radius
BorderRadius.circular(context.r(16))

// Height (alturas de componentes)
Container(height: context.h(60, min: 50, max: 80))
```

### 4. Usar tokens pré-definidos

```dart
// Spacing tokens
SizedBox(height: r.spacingXS)   // 4px escalável
SizedBox(height: r.spacingSM)   // 8px escalável
SizedBox(height: r.spacingMD)   // 12px escalável
SizedBox(height: r.spacingLG)   // 16px escalável
SizedBox(height: r.spacingXL)   // 20px escalável
SizedBox(height: r.spacingXXL)  // 24px escalável

// Radius tokens
BorderRadius.circular(r.radiusSM)  // 8px escalável
BorderRadius.circular(r.radiusMD) // 12px escalável
BorderRadius.circular(r.radiusLG) // 16px escalável

// Icon size tokens
Icon(Icons.home, size: r.iconXS)  // 16px escalável
Icon(Icons.home, size: r.iconSM)  // 20px escalável
Icon(Icons.home, size: r.iconMD)  // 24px escalável

// Typography tokens
Text('Título', style: r.heading1)
Text('Subtítulo', style: r.heading2)
Text('Corpo', style: r.bodyMedium)
```

### 5. Padding e Margin

```dart
// Padding escalável
Padding(
  padding: context.pad(all: 16),
  child: ...
)

Padding(
  padding: context.pad(horizontal: 24, vertical: 16),
  child: ...
)

Padding(
  padding: context.pad(top: 20, bottom: 12, left: 16, right: 16),
  child: ...
)

// Margin escalável (mesma sintaxe)
Container(
  margin: context.margin(all: 16),
  child: ...
)
```

## Padrões de Substituição

### ❌ ANTES (valores fixos)
```dart
SizedBox(height: 24)
Container(height: 120)
EdgeInsets.all(16)
BorderRadius.circular(24)
Icon(Icons.home, size: 28)
Text('Título', style: TextStyle(fontSize: 18))
```

### ✅ DEPOIS (valores responsivos)
```dart
SizedBox(height: context.s(24))
Container(height: context.h(120, min: 80, max: 140))
context.pad(all: 16)
BorderRadius.circular(context.r(24))
Icon(Icons.home, size: context.isz(28))
Text('Título', style: context.r.heading3)
```

## Exemplos Práticos

### Exemplo 1: Card Responsivo

```dart
Widget buildCard(BuildContext context) {
  final r = Responsive.of(context);
  
  return Container(
    padding: r.pad(all: 16),
    margin: r.margin(horizontal: 24, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r.radiusLG),
    ),
    child: Column(
      children: [
        Text(
          'Título do Card',
          style: r.heading3.copyWith(
            color: AppColors.darkGreenHeader,
          ),
        ),
        SizedBox(height: r.spacingMD),
        Text(
          'Descrição do card',
          style: r.bodyMedium,
        ),
      ],
    ),
  );
}
```

### Exemplo 2: Botão Responsivo

```dart
Widget buildButton(BuildContext context) {
  final r = Responsive.of(context);
  
  return SizedBox(
    height: r.buttonHeight,
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.radiusMD),
        ),
      ),
      onPressed: () {},
      child: Text(
        'Confirmar',
        style: r.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
```

### Exemplo 3: Lista Responsiva

```dart
Widget buildList(BuildContext context) {
  final r = Responsive.of(context);
  
  return ListView.builder(
    padding: r.pad(horizontal: 24, vertical: 16),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: r.pad(bottom: r.spacingLG),
        child: ListTile(
          leading: Icon(
            Icons.check,
            size: r.iconMD,
          ),
          title: Text(
            items[index].title,
            style: r.bodyLarge,
          ),
          subtitle: Text(
            items[index].subtitle,
            style: r.bodySmall,
          ),
        ),
      );
    },
  );
}
```

## Regras Importantes

### 1. Sempre usar clamp em valores críticos
```dart
// ✅ BOM
context.h(120, min: 80, max: 140)

// ❌ EVITAR (sem limites)
context.h(120)
```

### 2. Preferir tokens quando disponível
```dart
// ✅ BOM
SizedBox(height: r.spacingLG)

// ❌ EVITAR (quando token existe)
SizedBox(height: r.s(16))
```

### 3. Usar tipografia responsiva
```dart
// ✅ BOM
Text('Título', style: r.heading1)

// ❌ EVITAR
Text('Título', style: TextStyle(fontSize: context.fs(28)))
```

### 4. Layout responsivo para overflow
```dart
// ✅ BOM - Com SingleChildScrollView quando necessário
SingleChildScrollView(
  child: Column(
    children: [...],
  ),
)

// ✅ BOM - Com ConstrainedBox para limites
ConstrainedBox(
  constraints: BoxConstraints(
    minHeight: r.h(100),
    maxHeight: r.h(300),
  ),
  child: ...
)
```

### 5. Evitar valores fixos "cegos"
```dart
// ❌ EVITAR
SizedBox(height: 120)
Container(width: 240)

// ✅ USAR
SizedBox(height: context.h(120, min: 80, max: 160))
Container(width: context.h(240, min: 200, max: 300))
```

## Checklist de Refatoração

Para cada tela/widget, verificar:

- [ ] Todos os `SizedBox` com valores fixos foram substituídos por `context.s()`
- [ ] Todos os `Container` com `height/width` fixos foram substituídos por `context.h()`
- [ ] Todos os `EdgeInsets` fixos foram substituídos por `context.pad()` ou `context.margin()`
- [ ] Todos os `BorderRadius` fixos foram substituídos por `context.r()`
- [ ] Todos os `Icon` com `size` fixo foram substituídos por `context.isz()`
- [ ] Todos os `TextStyle` com `fontSize` fixo foram substituídos por tokens (`r.heading1`, `r.bodyMedium`, etc.)
- [ ] Layout usa `SingleChildScrollView` quando necessário para evitar overflow
- [ ] Valores críticos têm `min` e `max` definidos
- [ ] Testado em múltiplos tamanhos de tela (320x568, 360x640, 390x844, 412x915, 600x960)

## Telas Refatoradas (Exemplos)

1. ✅ **ProgressScreen** - Refatoração completa como exemplo
2. ✅ **AppHeader** - Widget responsivo
3. ✅ **AppBottomNavigationBar** - Widget responsivo

## Próximos Passos

Aplicar o mesmo padrão em todas as outras telas:
- DashboardScreen
- LoginScreen
- RegisterScreen
- MarketplaceScreen
- E todas as demais telas do app

## Suporte

Em caso de dúvidas sobre o sistema responsivo, consulte:
- `lib/design/responsive.dart` - Código fonte completo
- `lib/screens/progress_screen.dart` - Exemplo completo de refatoração
