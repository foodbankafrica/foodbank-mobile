part of './address_bloc.dart';

abstract class AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final String address;

  final double longitude;
  final double latitude;
  AddAddressEvent({
    required this.address,
    required this.longitude,
    required this.latitude,
  });
}

class GetAddressEvent extends AddressEvent {}

class MarkAddressDefaultEvent extends AddressEvent {
  final String addressId;
  MarkAddressDefaultEvent({
    required this.addressId,
  });
}

class UpdateAddressEvent extends AddressEvent {
  final String addressId;
  final String address;
  UpdateAddressEvent({
    required this.addressId,
    required this.address,
  });
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;
  DeleteAddressEvent({
    required this.addressId,
  });
}

class SearchAddressEvent extends AddressEvent {
  final String address;
  SearchAddressEvent({
    required this.address,
  });
}
