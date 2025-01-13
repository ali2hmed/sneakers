import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  int? _userId;
  String? _userName;
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';

  int? get userId => _userId;
  String? get userName => _userName;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt(_userIdKey);
    _userName = prefs.getString(_userNameKey);
    notifyListeners();
  }

  Future<void> setUser(int id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userNameKey, name);
    _userId = id;
    _userName = name;
    notifyListeners();
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    _userId = null;
    _userName = null;
    notifyListeners();
  }

  bool get isLoggedIn => _userId != null;
}
