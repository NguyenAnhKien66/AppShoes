import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static late SharedPreferences _prefs;

  // Khởi tạo SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Lưu giá trị double
  static Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  // Lấy giá trị double
  static double getDouble(String key, double defaultValue) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  // Lưu giá trị chuỗi
  static Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Lấy giá trị chuỗi
  static String getString(String key, String defaultValue) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // Lưu danh sách chuỗi
  static Future<void> saveStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  // Lấy danh sách chuỗi
  static List<String> getStringList(String key, List<String> defaultValue) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  // Lưu danh sách từ khóa tìm kiếm theo userId
  static Future<void> saveSearchKeywords(String userId, List<String> keywords) async {
    await saveStringList('search_keywords_$userId', keywords);
  }

  // Lấy danh sách từ khóa tìm kiếm theo userId
  static List<String> getSearchKeywords(String userId) {
    return getStringList('search_keywords_$userId', []);
  }

  // Thêm từ khóa vào danh sách theo userId
  static Future<void> addSearchKeyword(String userId, String keyword) async {
    List<String> keywords = getSearchKeywords(userId);
    if (!keywords.contains(keyword)) {
      keywords.add(keyword);
      await saveSearchKeywords(userId, keywords);
    }
  }

  // Xóa từ khóa khỏi danh sách theo userId
  static Future<void> removeSearchKeyword(String userId, String keyword) async {
    List<String> keywords = getSearchKeywords(userId);
    keywords.remove(keyword);
    await saveSearchKeywords(userId, keywords);
  }

  // Lưu user ID
  static Future<void> saveUserId(String userId) async {
    await saveString('user_id', userId);
  }

  // Lấy user ID
  static String getUserId() {
    return getString('user_id', '');
  }
  

  static Future<void> saveGmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  static String getGmail() {
    return getString('email', '');
  }

  static Future<void> saveUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

 static String getUsername() {
    return getString('username', '');
  }

  // Lưu mật khẩu
  static Future<void> savePassword(String password) async {
    await _prefs.setString('password', password);
  }

  // Lấy mật khẩu
  static String getPassword() {
    return getString('password', '');
  }

  // Lưu phone
  static Future<void> savePhone(String Phone) async {
    await _prefs.setString('Phone', Phone);
  }

  // Lấy phone
  static String getPhone() {
    return getString('Phone', '');
  }
  // Lưu hình ảnh
  static Future<void> saveImageUrl(String imageUrl) async {
    await _prefs.setString('imageUrl', imageUrl);
  }

  // Lấy hình ảnh
  static String getImageUrl() {
    return getString('imageUrl', '');
  }
  // Lưu giới tính
  static Future<void> saveGender(String Gender) async {
    await _prefs.setString('Gender', Gender);
  }

  // Lấy giới tính
  static String getGender() {
    return getString('Gender', '');
  }
   // Lưu ngày sinh
  static Future<void> saveBirthday(String Birthday) async {
    await _prefs.setString('Birthday', Birthday);
  }

  // Lấy ngày sinh
  static String getBirthday() {
    return getString('Birthday', '');
  }

   // Lưu ngày sinh
  static Future<void> saveAddress(String Address) async {
    await _prefs.setString('Address', Address);
  }

  // Lấy ngày sinh
  static String getAddress() {
    return getString('Address', '');
  }
  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  
  }
  
}
