import 'api_client.dart';
import 'api_exception.dart';
import 'session_storage.dart';

class AuthUser {
  final String id;
  final String email;

  AuthUser({required this.id, required this.email});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }
}

class AuthSession {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String refreshToken;

  AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: (json['access_token'] ?? '').toString(),
      tokenType: (json['token_type'] ?? '').toString(),
      expiresIn: (json['expires_in'] ?? 0) is int
          ? (json['expires_in'] as int)
          : int.tryParse((json['expires_in'] ?? '0').toString()) ?? 0,
      refreshToken: (json['refresh_token'] ?? '').toString(),
    );
  }
}

class AuthResponse {
  final AuthSession session;
  final AuthUser user;

  AuthResponse({required this.session, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final sessionJson = json['session'];
    final userJson = json['user'];
    if (sessionJson is! Map<String, dynamic> || userJson is! Map<String, dynamic>) {
      throw ApiException('Resposta inválida da API.');
    }
    return AuthResponse(
      session: AuthSession.fromJson(sessionJson),
      user: AuthUser.fromJson(userJson),
    );
  }
}

class SignupResponse {
  final AuthUser user;
  final String message;

  SignupResponse({required this.user, required this.message});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return SignupResponse(
      user: userJson is Map<String, dynamic> ? AuthUser.fromJson(userJson) : AuthUser(id: '', email: ''),
      message: (json['message'] ?? '').toString(),
    );
  }
}

class AuthService {
  AuthService({
    ApiClient? api,
    SessionStorage? storage,
  })  : _api = api ?? ApiClient(),
        _storage = storage ?? SessionStorage();

  final ApiClient _api;
  final SessionStorage _storage;

  Future<SignupResponse> signup({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
  }) async {
    final json = await _api.postJson(
      '/auth/signup',
      body: {
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'senha': senha,
      },
    );
    return SignupResponse.fromJson(json);
  }

  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) async {
    final json = await _api.postJson(
      '/auth/login',
      body: {
        'email': email,
        'senha': senha,
      },
    );
    final res = AuthResponse.fromJson(json);
    await _storage.saveSession(
      accessToken: res.session.accessToken,
      refreshToken: res.session.refreshToken,
      tokenType: res.session.tokenType,
      expiresIn: res.session.expiresIn,
    );
    return res;
  }

  Future<AuthResponse> verify({
    required String email,
    required String codigo,
  }) async {
    final json = await _api.postJson(
      '/auth/verify',
      body: {
        'email': email,
        'codigo': codigo,
      },
    );
    final res = AuthResponse.fromJson(json);
    await _storage.saveSession(
      accessToken: res.session.accessToken,
      refreshToken: res.session.refreshToken,
      tokenType: res.session.tokenType,
      expiresIn: res.session.expiresIn,
    );
    return res;
  }

  Future<String> resendCode({required String email}) async {
    final json = await _api.postJson(
      '/auth/resend',
      body: {
        'email': email,
      },
    );
    final msg = json['message'];
    return msg is String && msg.trim().isNotEmpty ? msg : 'Código reenviado.';
  }
}

