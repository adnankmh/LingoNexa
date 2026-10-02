import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<String?> readString(String key) async => (await _prefs).getString(key);
  Future<int?> readInt(String key) async => (await _prefs).getInt(key);
  Future<bool?> readBool(String key) async => (await _prefs).getBool(key);
  Future<double?> readDouble(String key) async => (await _prefs).getDouble(key);
  Future<List<String>?> readStrings(String key) async =>
      (await _prefs).getStringList(key);

  Future<void> writeString(String key, String value) async {
    final saved = await (await _prefs).setString(key, value);
    if (!saved) throw StateError('Failed to persist $key');
  }

  Future<void> writeInt(String key, int value) async {
    final saved = await (await _prefs).setInt(key, value);
    if (!saved) throw StateError('Failed to persist $key');
  }

  Future<void> writeBool(String key, bool value) async {
    final saved = await (await _prefs).setBool(key, value);
    if (!saved) throw StateError('Failed to persist $key');
  }

  Future<void> writeDouble(String key, double value) async {
    final saved = await (await _prefs).setDouble(key, value);
    if (!saved) throw StateError('Failed to persist $key');
  }

  Future<void> writeStrings(String key, List<String> value) async {
    final saved = await (await _prefs).setStringList(key, value);
    if (!saved) throw StateError('Failed to persist $key');
  }

  Future<void> remove(String key) async {
    final prefs = await _prefs;
    if (!prefs.containsKey(key)) return;
    final removed = await prefs.remove(key);
    if (!removed) throw StateError('Failed to remove $key');
  }
}
