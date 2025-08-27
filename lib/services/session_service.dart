import 'package:get_storage/get_storage.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final _storage = GetStorage();

  // Keys for storage
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _loginTimestampKey = 'loginTimestamp';

  // Initialize storage
  Future<void> init() async {
    await GetStorage.init();
  }

  // Save login state
  Future<void> saveLoginState(String userId) async {
    await _storage.write(_isLoggedInKey, true);
    await _storage.write(_userIdKey, userId);
    await _storage.write(
        _loginTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Clear login state (when user logs out)
  Future<void> clearLoginState() async {
    await _storage.remove(_isLoggedInKey);
    await _storage.remove(_userIdKey);
    await _storage.remove(_loginTimestampKey);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _storage.read(_isLoggedInKey) ?? false;
  }

  // Get user ID
  String? getUserId() {
    return _storage.read(_userIdKey);
  }

  // Get login timestamp
  int? getLoginTimestamp() {
    return _storage.read(_loginTimestampKey);
  }
}
