import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bag_facade.dart';
import '../../models/bag_model.dart';
import '../../models/order_model.dart';

part 'bag_event.dart';
part 'bag_state.dart';

class BagBloc extends Bloc<CartEvent, BagState> {
  final BagFacade _bagFacade;
  BagBloc({
    required BagFacade bagFacade,
  })  : _bagFacade = bagFacade,
        super(CartInitial()) {
    on<AddingCartEvent>(_addingCart);
    on<GetCartsEvent>(_getCarts);
    on<RemoveCartEvent>(_removeFromCart);
    on<IncreaseQTYEvent>(_increaseQTY);
    on<DecreaseQTYEvent>(_decreaseQTY);
    on<RemoveAllCartEvent>(_removeAllCart);
    on<GetOrdersEvent>(_getOrders);
    on<GetOrderEvent>(_getOrder);
    on<ConfirmOrderFilledEvent>(_confirmOrderFilled);
  }

  Future<void> _addingCart(AddingCartEvent event, emit) async {
    emit(AddingToCart());
    final failureOrSuccess = await _bagFacade.addToCart(event.bags);
    failureOrSuccess.fold(
      (error) => emit(AddingToCartFail(error.message)),
      (_) => emit(AddingToCartSuccessful()),
    );
  }

  Future<void> _removeFromCart(RemoveCartEvent event, emit) async {
    emit(RemovingToCart());
    final failureOrSuccess = await _bagFacade.removeFromCart(event.id);
    failureOrSuccess.fold(
      (error) => emit(RemovingToCartFail(error.message)),
      (_) => emit(RemovingToCartSuccessful()),
    );
  }

  Future<void> _removeAllCart(RemoveAllCartEvent event, emit) async {
    emit(RemovingToCart());
    final failureOrSuccess = await _bagFacade.removeAllCart();
    failureOrSuccess.fold(
      (error) => emit(RemovingToCartFail(error.message)),
      (_) => emit(RemovingToCartSuccessful()),
    );
  }

  Future<void> _increaseQTY(IncreaseQTYEvent event, emit) async {
    emit(IncrementingQTY());
    final failureOrSuccess = await _bagFacade.increaseQty(event.id, event.item);
    failureOrSuccess.fold(
      (error) => emit(IncrementingQTYFail(error.message)),
      (_) => emit(IncrementingQTYSuccessful()),
    );
  }

  Future<void> _decreaseQTY(DecreaseQTYEvent event, emit) async {
    emit(DecrementingQTY());
    final failureOrSuccess = await _bagFacade.decreaseQty(event.id, event.item);
    failureOrSuccess.fold(
      (error) => emit(DecrementingQTYFail(error.message)),
      (_) => emit(DecrementingQTYSuccessful()),
    );
  }

  Future<void> _getCarts(GetCartsEvent event, emit) async {
    emit(GettingCart());
    final failureOrSuccess = await _bagFacade.getCarts();
    failureOrSuccess.fold(
      (error) => emit(GettingCartFail(error.message)),
      (carts) {
        emit(GettingCartSuccessful(carts));
      },
    );
  }

  Future<void> _getOrders(GetOrdersEvent event, emit) async {
    emit(GettingOrders());
    final failureOrSuccess =
        await _bagFacade.getOrders(pageNumber: event.pageNumber);
    failureOrSuccess.fold(
      (error) => emit(GettingOrdersFail(error.message)),
      (orders) {
        emit(GettingOrdersSuccessful(orders));
      },
    );
  }

  Future<void> _getOrder(GetOrderEvent event, emit) async {
    emit(GettingOrder());
    final failureOrSuccess = await _bagFacade.getOrder(event.id);
    failureOrSuccess.fold(
      (error) => emit(GettingOrderFail(error.message)),
      (orders) {
        emit(GettingOrderSuccessful(orders));
      },
    );
  }

  Future<void> _confirmOrderFilled(ConfirmOrderFilledEvent event, emit) async {
    emit(ConfirmingOrder());
    final failureOrSuccess = await _bagFacade.confirmOrderFulFilled(
      orderId: event.orderId,
    );
    failureOrSuccess.fold(
      (error) => emit(ConfirmingOrderFail(error.message)),
      (message) {
        emit(ConfirmingOrderSuccessful(message));
      },
    );
  }
}
