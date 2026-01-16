import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Uri _uri(String path) => Uri.parse('$apiBaseUrl$path');

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      final res = await _http
          .post(
            _uri(path),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: jsonEncode(body ?? const <String, dynamic>{}),
          )
          .timeout(timeout);

      return _decodeOrThrow(res);
    } on TimeoutException {
      throw ApiException('Tempo de conexão esgotado. Tente novamente.');
    } on http.ClientException {
      throw ApiException('Falha de conexão. Verifique a API e sua rede.');
    } on FormatException {
      throw ApiException('Resposta inválida da API.');
    }
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      final res = await _http
          .get(
            _uri(path),
            headers: {
              ...?headers,
            },
          )
          .timeout(timeout);

      return _decodeOrThrow(res);
    } on TimeoutException {
      throw ApiException('Tempo de conexão esgotado. Tente novamente.');
    } on http.ClientException {
      throw ApiException('Falha de conexão. Verifique a API e sua rede.');
    } on FormatException {
      throw ApiException('Resposta inválida da API.');
    }
  }

  Map<String, dynamic> _decodeOrThrow(http.Response res) {
    final status = res.statusCode;
    final dynamic decoded = res.body.isEmpty ? null : jsonDecode(res.body);

    if (status >= 200 && status < 300) {
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{'data': decoded};
    }

    String message = 'Erro na API';
    if (decoded is Map<String, dynamic>) {
      final err = decoded['error'];
      final msg = decoded['message'];
      if (err is String && err.trim().isNotEmpty) message = err;
      if (msg is String && msg.trim().isNotEmpty) message = msg;
    }

    throw ApiException(message, statusCode: status);
  }
}

