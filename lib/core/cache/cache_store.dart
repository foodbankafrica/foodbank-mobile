import 'package:shared_preferences/shared_preferences.dart';

class CacheStore {
  Future<String> load({
    required String key,
  }) async {
    final SharedPreferences container = await SharedPreferences.getInstance();
    final res = container.getString(key);
    return res ?? '';
  }

  void store({
    required String key,
    required dynamic data,
  }) async {
    final SharedPreferences container = await SharedPreferences.getInstance();
    container.setString(key, data);
  }

  void storeList({
    required String key,
    required dynamic data,
  }) async {
    final SharedPreferences container = await SharedPreferences.getInstance();
    await container.setStringList(key, data);
  }

  Future<List<String>> loadList({required String key}) async {
    SharedPreferences container = await SharedPreferences.getInstance();
    return container.getStringList(key) ?? [];
  }

  void remove({
    required String key,
  }) async {
    final SharedPreferences container = await SharedPreferences.getInstance();
    container.remove(key);
  }

  void clear() async {
    final SharedPreferences container = await SharedPreferences.getInstance();
    container.clear();
  }
}
