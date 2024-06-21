import 'dart:async';
import 'dart:convert';
import 'package:food_bank/core/cache/cache_key.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/bag_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BagDatabaseHelper {
  BagDatabaseHelper._();
  static final BagDatabaseHelper _instance = BagDatabaseHelper._();
  factory BagDatabaseHelper() => _instance;

  Future<void> saveBags(List<Bag> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(CacheKey.carts, jsonString);
  }

  Future<List<Bag>> loadBags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(CacheKey.carts);
    if (jsonString != null) {
      print(jsonString);
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Bag.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateItem(int index, Bag updatedItem) async {
    List<Bag> currentItems = await loadBags();
    currentItems[index] = updatedItem;
    await saveBags(currentItems);
  }

  Future<void> removeItem(int index) async {
    List<Bag> currentItems = await loadBags();
    currentItems.removeAt(index);
    await saveBags(currentItems);
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(CacheKey.carts);
  }
}
