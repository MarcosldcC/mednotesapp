/// Base URL da API. Pode ser sobrescrito com:
/// `flutter run --dart-define=API_BASE_URL=http://seu-ip:3002`
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:3002',
);

