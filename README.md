# MedNotes - Aplicativo Flutter

Aplicativo móvel desenvolvido em Flutter/Dart para iOS e Android, implementando protocolos clínicos baseados em evidências.

## 📱 Telas Implementadas

1. **Splash Screen** - Tela de inicialização com ícone de cérebro
2. **Tela de Boas-vindas** - Apresentação do aplicativo com imagem da médica e call-to-action
3. **Tela de Registro** - Formulário completo de cadastro de usuário
4. **Tela de Verificação** - Verificação de conta com código de 5 dígitos
5. **Tela de Login** - Autenticação com e-mail e senha (com imagem da médica)

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (para iOS)
- Emulador ou dispositivo físico

### Instalação

1. Clone o repositório ou navegue até o diretório do projeto:
```bash
cd mednotes
```

2. **Adicione a imagem da médica** (veja instruções abaixo)

3. Instale as dependências:
```bash
flutter pub get
```

4. Execute o aplicativo:
```bash
flutter run
```

### Executar em dispositivos específicos

- **Android:**
```bash
flutter run -d android
```

- **iOS:**
```bash
flutter run -d ios
```

## 🖼️ Adicionar Imagem da Médica

Para que a imagem da médica apareça nas telas de Boas-vindas e Login:

1. Exporte a imagem do Figma (formato PNG ou JPG)
2. Renomeie para `medica.png` (ou `medica.jpg`)
3. Coloque na pasta `assets/images/`
4. Execute `flutter pub get` e `flutter run`

**Veja instruções detalhadas em:** `assets/images/COMO_ADICIONAR_IMAGEM.md`

## 📁 Estrutura do Projeto

```
lib/
├── constants/
│   ├── colors.dart          # Paleta de cores do aplicativo
│   └── text_styles.dart     # Estilos de texto padronizados
├── screens/
│   ├── splash_screen.dart   # Tela de inicialização
│   ├── welcome_screen.dart  # Tela de boas-vindas
│   ├── register_screen.dart # Tela de registro
│   ├── verify_account_screen.dart # Tela de verificação
│   └── login_screen.dart    # Tela de login
├── widgets/
│   └── custom_clipper.dart  # Clippers personalizados para formas
└── main.dart                # Ponto de entrada do aplicativo
```

## 🎨 Design System

### Cores Principais

- **Verde Escuro:** `#1D5047`, `#1A463F`, `#1F574E`
- **Verde Botão:** `#2A5A4A`
- **Verde Médio:** `#4A7C73`
- **Verde Claro:** `#4CAF50`
- **Bege/Creme:** `#F9F7EF`, `#FBF7F0`, `#FDFBF2`, `#F7F4EB`

### Tipografia

- **Fonte:** Sistema padrão (Poppins pode ser adicionada)
- **Tamanhos:** 14px, 16px, 24px, 28px

## 📝 Notas de Implementação

- Todas as telas foram implementadas fielmente aos designs do Figma
- O aplicativo utiliza Material Design 3
- Navegação implementada entre todas as telas
- Validação de formulários incluída
- Suporte para modo claro (dark mode pode ser adicionado futuramente)
- **Imagem da médica**: Adicione a imagem `medica.png` na pasta `assets/images/` para exibição completa

## 🔧 Próximos Passos

Para completar o aplicativo, você pode:

1. ✅ Adicionar imagem da médica nos assets
2. Implementar a lógica de autenticação real
3. Adicionar integração com backend/API
4. Implementar persistência de dados
5. Adicionar testes unitários e de integração

## 📄 Licença

Este projeto é privado e desenvolvido para uso específico.
