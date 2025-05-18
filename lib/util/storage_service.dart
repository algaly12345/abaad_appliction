import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
   SharedPreferences _prefs;

  // تهيئة SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // حفظ بيانات
  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw Exception("Unsupported data type for SharedPreferences");
    }
  }

  // قراءة بيانات
  dynamic getData(String key) {
    return _prefs.get(key);
  }

  // حذف بيانات
  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  // مسح كل البيانات
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
