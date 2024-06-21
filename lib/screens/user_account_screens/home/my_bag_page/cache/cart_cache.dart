import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/bag_model.dart';

List<Bag>? _carts;

class CartCache {
  CartCache._();
  static CartCache? _instance;

  static get instance => _instance ?? CartCache._();

  List<Bag> get carts => _carts ?? [];

  set carts(List<Bag> carts) {
    _carts = carts;
  }

  bool get isCartsEmpty => (_carts ?? []).isEmpty;

  int indexOf(String id) {
    return (_carts ?? []).indexWhere((cart) => cart.id.toString() == id);
  }

  Bag? getCart(String id) {
    return (_carts ?? []).firstWhere(
      (cart) => cart.id.toString() == id,
      orElse: () => Bag(),
    );
  }

  bool alreadyAddToCart(String id) {
    bool contained = false;
    for (Bag cart in carts) {
      if (cart.id.toString() == id) contained = true;
    }
    return contained;
  }

  (num, num, num) fees() {
    num subTotal = 0;
    num deliveryFee = 2000;
    for (Bag cart in (_carts ?? [])) {
      subTotal += (num.parse(cart.price!) * cart.quantity!);
    }

    return (subTotal, deliveryFee, subTotal + deliveryFee);
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> arr = [];
    for (var cart in (_carts ?? [])) {
      arr.add({
        "id": cart.id!,
        "quantity": cart.quantity,
      });
    }
    return arr;
  }
}
