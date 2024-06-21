import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/errors/failure.dart';
import 'package:food_bank/core/networks/do_internet_check.dart';
import 'package:food_bank/core/utils/handle_error.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/data_source/address/address_remote_source.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/models/address_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/networks/internet_info.dart';
import '../models/search_address.dart';

abstract class AddressService {
  TaskEither<Failure, String> addAddress({
    required String address,
    required double longitude,
    required double latitude,
  });
  TaskEither<Failure, AddressResponse> getAddresses();
  TaskEither<Failure, String> markAddressDefault({
    required String addressId,
  });
  TaskEither<Failure, String> updateAddress({
    required String addressId,
    required String address,
  });
  TaskEither<Failure, String> deleteAddress({
    required String addressId,
  });
  TaskEither<Failure, SearchAddressResponse> searchAddress({
    required String searchAddress,
  });
}

class AddressServiceImpl extends AddressService
    with HandleError, DoInternetCheck {
  final NetworkInfo _networkInfo;
  final AddressRemote _addressRemote;

  AddressServiceImpl({
    required NetworkInfo networkInfo,
    required AddressRemote addressRemote,
  })  : _addressRemote = addressRemote,
        _networkInfo = networkInfo;
  @override
  TaskEither<Failure, String> addAddress({
    required String address,
    required double longitude,
    required double latitude,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _addressRemote.addAddress(
            address: address,
            latitude: latitude,
            longitude: longitude,
          );
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace";
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> deleteAddress({
    required String addressId,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _addressRemote.deleteAddress(
            addressId: addressId,
          );
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace";
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, AddressResponse> getAddresses() {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _addressRemote.getAddresses();
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace";
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> markAddressDefault({required String addressId}) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _addressRemote.markAddressDefault(
            addressId: addressId,
          );
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace";
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> updateAddress(
      {required String addressId, required String address}) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _addressRemote.updateAddress(
            addressId: addressId,
            address: address,
          );
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace";
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, SearchAddressResponse> searchAddress(
      {required String searchAddress}) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res =
              await _addressRemote.searchAddress(searchAddress: searchAddress);
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace".log();
        return handleError(error);
      },
    );
  }
}
