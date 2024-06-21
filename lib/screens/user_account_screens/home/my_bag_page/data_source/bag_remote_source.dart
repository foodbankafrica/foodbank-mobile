import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/errors/custom_exeption.dart';
import 'package:food_bank/core/networks/api_clients.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/data_source/bag_endpoint.dart';

import '../models/cart.dart';
import '../models/order_model.dart';

abstract class BagRemoteSource {
  Future<String> addToCart({
    required int productId,
    required int quantity,
  });
  Future<CartResponse> getCarts();
  Future<String> removeCart({
    required int productId,
  });
  Future<String> removeAllCart();
  Future<OrderResponse> getOrders({required int pageNumber});
  Future<Order> getOrder({required String orderId});

  Future<String> confirmOrderFulFilled({
    required String orderId,
  });
}

class BagRemoteSourceImpl extends BagRemoteSource {
  final ApiClient _apiClient;

  BagRemoteSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Order> getOrder({required String orderId}) async {
    final res = await _apiClient.get(url: BagEndpoint.order(orderId));
    if (res.isSuccessful) {
      return Order.fromJson(res.data["order"]);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<OrderResponse> getOrders({required int pageNumber}) async {
    final res = await _apiClient.get(url: BagEndpoint.orderList(pageNumber));
    if (res.isSuccessful) {
      return OrderResponse.fromJson(res.data);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<String> confirmOrderFulFilled({
    required String orderId,
  }) async {
    final res = await _apiClient
        .patch(url: BagEndpoint.confirmOrderFulFilled(orderId), body: {});
    if (res.isSuccessful) {
      return res.message!;
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<String> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final res = await _apiClient.post(
      url: BagEndpoint.addBag,
      body: {
        "product_id": productId,
        "quantity": quantity,
      },
    );
    if (res.isSuccessful) {
      return res.message!;
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<CartResponse> getCarts() async {
    final res = await _apiClient.get(
      url: BagEndpoint.getBags,
    );
    if (res.isSuccessful) {
      return CartResponse.fromJson(res.data);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<String> removeAllCart() async {
    BagEndpoint.removeAllBag.log();
    final res = await _apiClient.delete(
      url: BagEndpoint.removeAllBag,
    );
    if (res.isSuccessful) {
      return res.message!;
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<String> removeCart({required int productId}) async {
    final res = await _apiClient.delete(
      url: BagEndpoint.removeBag(productId),
    );
    if (res.isSuccessful) {
      return res.message!;
    }
    throw CustomException(message: res.message!);
  }
}
