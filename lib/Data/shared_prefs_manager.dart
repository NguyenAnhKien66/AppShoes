import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a double value
  static Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  // Retrieve a double value
  static double getDouble(String key, double defaultValue) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  // Save a string value
  static Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Retrieve a string value
  static String getString(String key, String defaultValue) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // Save a list of strings
  static Future<void> saveStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  // Retrieve a list of strings
  static List<String> getStringList(String key, List<String> defaultValue) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  // thêm từ khóa vào list
  static Future<void> addSearchKeyword(String keyword) async {
    List<String> keywords = _prefs.getStringList('search_keywords') ?? [];
    if (!keywords.contains(keyword)) {
      keywords.add(keyword);
      await saveStringList('search_keywords', keywords);
    }
  }

  // Xóa từ khóa trong list
  static Future<void> removeSearchKeyword(String keyword) async {
    List<String> keywords = _prefs.getStringList('search_keywords') ?? [];
    keywords.remove(keyword);
    await saveStringList('search_keywords', keywords);
  }

  // lấy từ khóa từ list
  static List<String> getSearchKeywords() {
    return _prefs.getStringList('search_keywords') ?? [];
  }
}
