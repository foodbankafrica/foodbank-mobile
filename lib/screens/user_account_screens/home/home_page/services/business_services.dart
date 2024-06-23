import 'package:food_bank/core/errors/failure.dart';
import 'package:food_bank/core/networks/do_internet_check.dart';
import 'package:food_bank/core/networks/internet_info.dart';
import 'package:food_bank/core/utils/handle_error.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/data_source/business_remote_data_source.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/buisness_model.dart';
import 'package:fpdart/fpdart.dart';

import '../models/product_model.dart';
import '../models/transaction_model.dart';

abstract class BusinessService {
  TaskEither<Failure, BusinessResponse> getBusinesses({
    required String filteredBy,
    required String addressId,
  });
  TaskEither<Failure, BusinessResponse> getGuestBusinesses({
    required String address,
    required String latitude,
    required String longitude,
  });
  TaskEither<Failure, TransactionResponse> getTransactions(int page);
  TaskEither<Failure, BusinessResponse> search(String searchTerm);
  TaskEither<Failure, ProductResponse> getProducts({
    required String vendorId,
    required String branchId,
    required String category,
  });
  TaskEither<Failure, ProductResponse> guestProducts({
    required String vendorId,
  });
}

class BusinessServiceImpl extends BusinessService
    with HandleError, DoInternetCheck {
  final NetworkInfo _networkInfo;
  final BusinessRemoteSource _businessRemoteSource;

  BusinessServiceImpl({
    required BusinessRemoteSource businessRemoteSource,
    required NetworkInfo networkInfo,
  })  : _businessRemoteSource = businessRemoteSource,
        _networkInfo = networkInfo;

  @override
  TaskEither<Failure, BusinessResponse> getBusinesses({
    required String filteredBy,
    required String addressId,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _businessRemoteSource.getBusinesses(
          filteredBy: filteredBy,
          addressId: addressId,
        );
        return res;
      }),
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, ProductResponse> getProducts({
    required String vendorId,
    required String branchId,
    required String category,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _businessRemoteSource.getProducts(
          vendorId: vendorId,
          branchId: branchId,
          category: category,
        );
        return res;
      }),
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, BusinessResponse> search(String searchTerm) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _businessRemoteSource.search(searchTerm);
        return res;
      }),
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, TransactionResponse> getTransactions(int page) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _businessRemoteSource.getTransactions(page);
        return res;
      }),
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, BusinessResponse> getGuestBusinesses({
    required String address,
    required String latitude,
    required String longitude,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _businessRemoteSource.getGuestBusinesses(
            address: address, latitude: latitude, longitude: longitude);
        return res;
      }),
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, ProductResponse> guestProducts(
      {required String vendorId}) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res =
            await _businessRemoteSource.guestProducts(vendorId: vendorId);
        return res;
      }),
      (error, stackTrace) {
        print("error $error, stackTrace $stackTrace");
        return handleError(error);
      },
    );
  }
}
