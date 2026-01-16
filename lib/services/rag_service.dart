import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/rag.dart';
import 'api_exception.dart';

class RagService {
  RagService({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Future<String> ask(String question) async {
    final uri = Uri.parse('$ragBaseUrl/rag/ask');
    final res = await _http.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'question': question}),
    );

    dynamic decoded;
    try {
      decoded = res.body.isEmpty ? null : jsonDecode(res.body);
    } catch (_) {
      decoded = null;
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        final a = decoded['answer'];
        if (a is String) return a;
      }
      throw ApiException('Resposta inválida do servidor RAG.', statusCode: res.statusCode);
    }

    String message = 'Erro no servidor RAG';
    if (decoded is Map<String, dynamic>) {
      final detail = decoded['detail'];
      if (detail is String && detail.trim().isNotEmpty) message = detail;
    }
    throw ApiException(message, statusCode: res.statusCode);
  }
}

