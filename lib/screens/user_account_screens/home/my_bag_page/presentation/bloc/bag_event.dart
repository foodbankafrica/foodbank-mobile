part of 'bag_bloc.dart';

abstract class CartEvent {}

class AddingCartEvent extends CartEvent {
  final List<Bag> bags;

  AddingCartEvent(this.bags);
}

class GetCartsEvent extends CartEvent {}

class RemoveCartEvent extends CartEvent {
  final int id;
  RemoveCartEvent(this.id);
}

class IncreaseQTYEvent extends CartEvent {
  final int id;
  final Bag item;
  IncreaseQTYEvent(this.id, this.item);
}

class DecreaseQTYEvent extends CartEvent {
  final int id;
  final Bag item;
  DecreaseQTYEvent(this.id, this.item);
}

class RemoveAllCartEvent extends CartEvent {}

class GetOrderEvent extends CartEvent {
  final String id;

  GetOrderEvent(this.id);
}

class GetOrdersEvent extends CartEvent {
  final int pageNumber;
  GetOrdersEvent(this.pageNumber);
}

class ConfirmOrderFilledEvent extends CartEvent {
  final String orderId;

  ConfirmOrderFilledEvent(
    this.orderId,
  );
}
