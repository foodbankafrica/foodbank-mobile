part of 'bag_bloc.dart';

abstract class BagState {}

class CartInitial extends BagState {}

class AddingToCart extends BagState {}

class AddingToCartSuccessful extends BagState {}

class AddingToCartFail extends BagState {
  final String error;
  AddingToCartFail(this.error);
}

class RemovingToCart extends BagState {}

class RemovingToCartSuccessful extends BagState {}

class RemovingToCartFail extends BagState {
  final String error;
  RemovingToCartFail(this.error);
}

class GettingCart extends BagState {}

class GettingCartSuccessful extends BagState {
  final List<Bag> carts;
  GettingCartSuccessful(this.carts);
}

class GettingCartFail extends BagState {
  final String error;
  GettingCartFail(this.error);
}

class IncrementingQTY extends BagState {}

class IncrementingQTYSuccessful extends BagState {}

class IncrementingQTYFail extends BagState {
  final String error;
  IncrementingQTYFail(this.error);
}

class DecrementingQTY extends BagState {}

class DecrementingQTYSuccessful extends BagState {}

class DecrementingQTYFail extends BagState {
  final String error;
  DecrementingQTYFail(this.error);
}

class GettingOrders extends BagState {}

class GettingOrdersSuccessful extends BagState {
  final OrderResponse orders;
  GettingOrdersSuccessful(this.orders);
}

class GettingOrdersFail extends BagState {
  final String error;
  GettingOrdersFail(this.error);
}

class GettingOrder extends BagState {}

class GettingOrderSuccessful extends BagState {
  final Order order;
  GettingOrderSuccessful(this.order);
}

class GettingOrderFail extends BagState {
  final String error;
  GettingOrderFail(this.error);
}

class ConfirmingOrder extends BagState {}

class ConfirmingOrderSuccessful extends BagState {
  final String message;
  ConfirmingOrderSuccessful(this.message);
}

class ConfirmingOrderFail extends BagState {
  final String error;
  ConfirmingOrderFail(this.error);
}
