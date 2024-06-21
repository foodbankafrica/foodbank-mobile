import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/bag_model.dart';

import '../../../../../core/errors/custom_exeption.dart';
import 'bag_db_helper.dart';

abstract class BagLocalSource {
  Future<void> addToBag(List<Bag> data);
  Future<void> removeFromCart(int index);
  Future<void> increaseQty(int index, Bag updatedItem);
  Future<void> decreaseQty(int index, Bag updatedItem);
  Future<void> clear();
  Future<List<Bag>> getBags();
}

class BagLocalSourceImpl implements BagLocalSource {
  final BagDatabaseHelper _bagDatabaseHelper;

  BagLocalSourceImpl({
    required BagDatabaseHelper bagDatabaseHelper,
  }) : _bagDatabaseHelper = bagDatabaseHelper;

  @override
  Future<void> addToBag(List<Bag> data) async {
    try {
      await _bagDatabaseHelper.saveBags(data);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> decreaseQty(int index, Bag updatedItem) async {
    try {
      await _bagDatabaseHelper.updateItem(index, updatedItem);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> increaseQty(int index, Bag updatedItem) async {
    try {
      await _bagDatabaseHelper.updateItem(index, updatedItem);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> removeFromCart(int index) async {
    try {
      await _bagDatabaseHelper.removeItem(index);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _bagDatabaseHelper.clear();
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<List<Bag>> getBags() async {
    try {
      final carts = await _bagDatabaseHelper.loadBags();

      return carts;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
