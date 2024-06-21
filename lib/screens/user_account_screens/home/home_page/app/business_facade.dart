import 'package:food_bank/core/errors/failure.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/buisness_model.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/product_model.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/services/business_services.dart';
import 'package:fpdart/fpdart.dart';

import '../models/transaction_model.dart';

class BusinessFacade {
  final BusinessService _businessService;

  BusinessFacade({required BusinessService businessService})
      : _businessService = businessService;

  Future<Either<Failure, BusinessResponse>> getBusinesses({
    required String filteredBy,
    String? addressId,
  }) {
    return _businessService
        .getBusinesses(
          filteredBy: filteredBy,
          addressId: addressId,
        )
        .run();
  }

  Future<Either<Failure, BusinessResponse>> getGuestBusinesses({
    required String address,
    required String latitude,
    required String longitude,
  }) {
    return _businessService
        .getGuestBusinesses(
            address: address, latitude: latitude, longitude: longitude)
        .run();
  }

  Future<Either<Failure, BusinessResponse>> search(String searchTerm) {
    return _businessService.search(searchTerm).run();
  }

  Future<Either<Failure, ProductResponse>> getProducts({
    required String vendorId,
    required String category,
  }) {
    return _businessService
        .getProducts(
          vendorId: vendorId,
          category: category,
        )
        .run();
  }

  Future<Either<Failure, ProductResponse>> guestProducts({
    required String vendorId,
  }) {
    return _businessService
        .guestProducts(
          vendorId: vendorId,
        )
        .run();
  }

  Future<Either<Failure, TransactionResponse>> getTransactions(int page) {
    return _businessService.getTransactions(page).run();
  }
}
