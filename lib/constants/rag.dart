/// Base URL do servidor do RAG (FastAPI).
/// Pode ser sobrescrito com:
/// `flutter run --dart-define=RAG_BASE_URL=http://127.0.0.1:8000`
const String ragBaseUrl = String.fromEnvironment(
  'RAG_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000',
);

