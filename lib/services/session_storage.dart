import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kTokenType = 'token_type';
  static const _kExpiresIn = 'expires_in';

  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessToken, accessToken);
    if (refreshToken != null) await prefs.setString(_kRefreshToken, refreshToken);
    if (tokenType != null) await prefs.setString(_kTokenType, tokenType);
    if (expiresIn != null) await prefs.setInt(_kExpiresIn, expiresIn);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
    await prefs.remove(_kTokenType);
    await prefs.remove(_kExpiresIn);
  }
}

