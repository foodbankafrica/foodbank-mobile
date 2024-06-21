import 'package:food_bank/screens/user_account_screens/home/user_page/models/address_model.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/services/address_service.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/errors/failure.dart';
import '../models/search_address.dart';

class AddressFacade {
  final AddressService _addressService;
  AddressFacade({required AddressService addressService})
      : _addressService = addressService;

  Future<Either<Failure, String>> addAddress({
    required String address,
    required double longitude,
    required double latitude,
  }) {
    return _addressService
        .addAddress(
          address: address,
          latitude: latitude,
          longitude: longitude,
        )
        .run();
  }

  Future<Either<Failure, String>> deleteAddress({
    required String addressId,
  }) {
    return _addressService
        .deleteAddress(
          addressId: addressId,
        )
        .run();
  }

  Future<Either<Failure, String>> updateAddress({
    required String addressId,
    required String address,
  }) {
    return _addressService
        .updateAddress(
          addressId: addressId,
          address: address,
        )
        .run();
  }

  Future<Either<Failure, String>> markAddressDefault({
    required String addressId,
  }) {
    return _addressService
        .markAddressDefault(
          addressId: addressId,
        )
        .run();
  }

  Future<Either<Failure, AddressResponse>> getAddresses() {
    return _addressService.getAddresses().run();
  }

  Future<Either<Failure, SearchAddressResponse>> searchAddress(
      {required String searchAddress}) {
    return _addressService.searchAddress(searchAddress: searchAddress).run();
  }
}
