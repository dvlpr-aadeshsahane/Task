import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Tokens {
  static String? _refreshToken;
  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static Future<String?> get refreshToken async {
    if (_refreshToken != null) return _refreshToken;
    await Tokens.init();
    return _refreshToken;
  }

  static Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    _refreshToken = refreshToken;
    _accessToken = accessToken;

    const storage = FlutterSecureStorage();
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'accessToken', value: accessToken);
  }

  static Future<void> init() async {
    const storage = FlutterSecureStorage();
    _refreshToken = await storage.read(key: 'refreshToken');
    _accessToken = await storage.read(key: 'accessToken');
  }

  static Future<void> clear() async {
    _refreshToken = null;
    _accessToken = null;

    const storage = FlutterSecureStorage();
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'accessToken');
  }
}
