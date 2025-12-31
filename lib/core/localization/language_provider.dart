import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _langKey = 'selected_language';
  Locale? _locale;

  Locale? get locale => _locale;

  LanguageProvider() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_langKey);
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  void setLanguage(String langCode) async {
    _locale = Locale(langCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  void useSystemLanguage() async {
    _locale = null; // Setting to null will make MaterialApp use system locale
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_langKey);
  }

  String get languageName {
    if (_locale == null) return 'System Default';
    return _locale!.languageCode == 'ar' ? 'العربية' : 'English';
  }
}
