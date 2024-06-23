import 'package:fpdart/fpdart.dart' show Either;

import '../../../../../core/errors/failure.dart';
import '../models/bag_model.dart';
import '../models/order_model.dart';
import '../services/bag_service.dart';

class BagFacade {
  final BagService _bagService;

  BagFacade({
    required BagService bagService,
  }) : _bagService = bagService;

  Future<Either<Failure, void>> addToCart(List<Bag> bags) async {
    return _bagService.addToCart(bags).run();
  }

  Future<Either<Failure, List<Bag>>> getCarts() async {
    return _bagService.getCarts().run();
  }

  Future<Either<Failure, void>> increaseQty(int id, Bag item) async {
    return _bagService.increaseQty(id, item).run();
  }

  Future<Either<Failure, void>> decreaseQty(int id, Bag item) async {
    return _bagService.decreaseQty(id, item).run();
  }

  Future<Either<Failure, void>> removeFromCart(int id) async {
    return _bagService.removeFromCart(id).run();
  }

  Future<Either<Failure, void>> removeAllCart() async {
    return _bagService.removeAllCart().run();
  }

  Future<Either<Failure, Order>> getOrder(String orderId) async {
    return _bagService.getOrder(orderId: orderId).run();
  }

  Future<Either<Failure, OrderResponse>> getOrders(
      {required int pageNumber}) async {
    return _bagService.getOrders(pageNumber: pageNumber).run();
  }

  Future<Either<Failure, String>> confirmOrderFulFilled({
    required String orderId,
  }) async {
    return _bagService.confirmOrderFulFilled(orderId: orderId).run();
  }
}
