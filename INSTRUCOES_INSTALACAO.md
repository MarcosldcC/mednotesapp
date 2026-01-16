# Instruções de Instalação do Flutter

## 📋 Pré-requisitos

Antes de executar o aplicativo MedNotes, você precisa instalar o Flutter SDK.

### Windows

1. **Baixe o Flutter SDK:**
   - Acesse: https://flutter.dev/docs/get-started/install/windows
   - Baixe o arquivo ZIP do Flutter SDK
   - Extraia para um local como `C:\src\flutter`

2. **Adicione ao PATH:**
   - Adicione `C:\src\flutter\bin` ao PATH do sistema
   - Reinicie o terminal/PowerShell

3. **Verifique a instalação:**
   ```powershell
   flutter doctor
   ```

4. **Instale dependências adicionais:**
   - Android Studio (para desenvolvimento Android)
   - VS Code ou Android Studio (como IDE)
   - Git

### macOS (para iOS)

1. **Instale via Homebrew:**
   ```bash
   brew install --cask flutter
   ```

2. **Ou baixe manualmente:**
   - Acesse: https://flutter.dev/docs/get-started/install/macos
   - Siga as instruções oficiais

3. **Instale Xcode** (necessário para iOS):
   ```bash
   xcode-select --install
   ```

### Linux

1. **Siga as instruções oficiais:**
   - Acesse: https://flutter.dev/docs/get-started/install/linux

## 🚀 Após Instalar o Flutter

1. **Navegue até o diretório do projeto:**
   ```bash
   cd mednotes
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Verifique dispositivos disponíveis:**
   ```bash
   flutter devices
   ```

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## 📱 Executar em Dispositivos Específicos

### Android

1. **Inicie um emulador Android** ou conecte um dispositivo físico
2. **Execute:**
   ```bash
   flutter run -d android
   ```

### iOS (apenas macOS)

1. **Inicie um simulador iOS** ou conecte um dispositivo físico
2. **Execute:**
   ```bash
   flutter run -d ios
   ```

## 🔧 Solução de Problemas

### Flutter não encontrado
- Verifique se o Flutter está no PATH
- Reinicie o terminal após adicionar ao PATH

### Erro de dependências
```bash
flutter clean
flutter pub get
```

### Problemas com Android
```bash
flutter doctor --android-licenses
```

### Problemas com iOS
```bash
cd ios
pod install
cd ..
```

## 📚 Recursos Adicionais

- Documentação Flutter: https://flutter.dev/docs
- Dart Language: https://dart.dev/guides
- Flutter Packages: https://pub.dev
