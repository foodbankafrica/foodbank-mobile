import '../models/order_model.dart';

List<Order> _orders = [];

class OrderCache {
  OrderCache._();
  static OrderCache? _instance;

  static get instance => _instance ?? OrderCache._();

  List<Order> get orders => _orders;

  set orders(List<Order> orders) {
    _orders = orders;
  }

  bool get isOrdersEmpty => _orders.isEmpty;

  List<Order> filteredOrder(String status) {
    return _orders.where((element) {
      return element.status == status;
    }).toList();
  }
}
