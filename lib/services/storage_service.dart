import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<String?> readString(String key) async => (await _prefs).getString(key);
  Future<int?> readInt(String key) async => (await _prefs).getInt(key);
  Future<bool?> readBool(String key) async => (await _prefs).getBool(key);
  Future<List<String>?> readStrings(String key) async => (await _prefs).getStringList(key);

  Future<void> writeString(String key, String value) async => (await _prefs).setString(key, value);
  Future<void> writeInt(String key, int value) async => (await _prefs).setInt(key, value);
  Future<void> writeBool(String key, bool value) async => (await _prefs).setBool(key, value);
  Future<void> writeStrings(String key, List<String> value) async => (await _prefs).setStringList(key, value);
}

