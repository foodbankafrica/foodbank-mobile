part of './address_bloc.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddingAddress extends AddressState {}

class AddingAddressSuccessful extends AddressState {
  final String message;
  AddingAddressSuccessful(this.message);
}

class AddingAddressFail extends AddressState {
  final String error;
  AddingAddressFail(this.error);
}

class UpdatingAddress extends AddressState {}

class UpdatingAddressSuccessful extends AddressState {
  final String message;
  UpdatingAddressSuccessful(this.message);
}

class UpdatingAddressFail extends AddressState {
  final String error;
  UpdatingAddressFail(this.error);
}

class MarkingDefaultAddress extends AddressState {}

class MarkingDefaultAddressSuccessful extends AddressState {
  final String message;
  MarkingDefaultAddressSuccessful(this.message);
}

class MarkingDefaultAddressFail extends AddressState {
  final String error;
  MarkingDefaultAddressFail(this.error);
}

class DeletingAddress extends AddressState {}

class DeletingAddressSuccessful extends AddressState {
  final String message;
  DeletingAddressSuccessful(this.message);
}

class DeletingAddressFail extends AddressState {
  final String error;
  DeletingAddressFail(this.error);
}

class GettingAddresses extends AddressState {}

class GettingAddressesSuccessful extends AddressState {
  final AddressResponse addressesResponse;
  GettingAddressesSuccessful(this.addressesResponse);
}

class GettingAddressesFail extends AddressState {
  final String error;
  GettingAddressesFail(this.error);
}

class SearchingAddress extends AddressState {}

class SearchingAddressSuccessful extends AddressState {
  final SearchAddressResponse addressesResponse;
  SearchingAddressSuccessful(this.addressesResponse);
}

class SearchingAddressFail extends AddressState {
  final String error;
  SearchingAddressFail(this.error);
}
