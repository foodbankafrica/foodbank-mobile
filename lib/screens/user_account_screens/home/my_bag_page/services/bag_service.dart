import 'package:food_bank/core/networks/do_internet_check.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/data_source/bag_remote_source.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;

import '../../../../../core/errors/failure.dart';
import '../../../../../core/networks/internet_info.dart';
import '../../../../../core/utils/handle_error.dart';
import '../data_source/data_local_source.dart';
import '../models/bag_model.dart';

import '../models/order_model.dart';

abstract class BagService {
  TaskEither<Failure, void> addToCart(List<Bag> data);
  TaskEither<Failure, void> removeFromCart(int index);
  TaskEither<Failure, void> removeAllCart();
  TaskEither<Failure, void> increaseQty(int index, Bag item);
  TaskEither<Failure, void> decreaseQty(int index, Bag item);
  TaskEither<Failure, List<Bag>> getCarts();
  TaskEither<Failure, OrderResponse> getOrders({required int pageNumber});
  TaskEither<Failure, Order> getOrder({required String orderId});
  TaskEither<Failure, String> confirmOrderFulFilled({
    required String orderId,
  });
}

class BagServiceImpl extends BagService with HandleError, DoInternetCheck {
  final NetworkInfo _networkInfo;
  final BagLocalSource _bagLocalSource;
  final BagRemoteSource _bagRemoteSource;

  BagServiceImpl({
    required BagLocalSource bagLocalSource,
    required NetworkInfo networkInfo,
    required BagRemoteSource bagRemoteSource,
  })  : _bagLocalSource = bagLocalSource,
        _networkInfo = networkInfo,
        _bagRemoteSource = bagRemoteSource;

  @override
  TaskEither<Failure, void> addToCart(List<Bag> data) {
    return TaskEither.tryCatch(
      () async {
        checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            // await _bagRemoteSource.addToCart(
            //     productId: productId, quantity: quantity);
            await _bagLocalSource.addToBag(data);
          },
        );
      },
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace";
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, void> decreaseQty(int index, Bag item) {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            await _bagLocalSource.decreaseQty(index, item);
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, List<Bag>> getCarts() {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            // final res = await _bagRemoteSource.getCarts();
            final res = await _bagLocalSource.getBags();
            return res;
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, void> increaseQty(int index, Bag item) {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            await _bagLocalSource.increaseQty(index, item);
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, void> removeFromCart(int id) {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            await _bagLocalSource.removeFromCart(id);
            // await _bagRemoteSource.removeCart(productId: id);
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, Order> getOrder({required String orderId}) {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            return await _bagRemoteSource.getOrder(orderId: orderId);
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, OrderResponse> getOrders({required int pageNumber}) {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            return await _bagRemoteSource.getOrders(pageNumber: pageNumber);
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> confirmOrderFulFilled({required String orderId}) {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            return await _bagRemoteSource.confirmOrderFulFilled(
              orderId: orderId,
            );
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, void> removeAllCart() {
    return TaskEither.tryCatch(
      () {
        return checkInternetThenMakeRequest(
          _networkInfo,
          request: () async {
            await _bagLocalSource.clear();
          },
        );
      },
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }
}
