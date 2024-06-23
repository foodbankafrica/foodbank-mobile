import 'package:food_bank/core/errors/custom_exeption.dart';
import 'package:food_bank/core/networks/api_clients.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/data_source/business_endpoint.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/buisness_model.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/product_model.dart';

import '../models/transaction_model.dart';

abstract class BusinessRemoteSource {
  Future<BusinessResponse> getBusinesses({
    required String filteredBy,
    required String addressId,
  });
  Future<BusinessResponse> getGuestBusinesses({
    required String address,
    required String latitude,
    required String longitude,
  });
  Future<TransactionResponse> getTransactions(int page);
  Future<BusinessResponse> search(String searchTerm);
  Future<ProductResponse> getProducts({
    required String vendorId,
    required String branchId,
    required String category,
  });
  Future<ProductResponse> guestProducts({
    required String vendorId,
  });
}

class BusinessRemoteSourceImpl implements BusinessRemoteSource {
  final ApiClient _apiClient;

  BusinessRemoteSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<BusinessResponse> getBusinesses({
    required String filteredBy,
    required String addressId,
  }) async {
    final res = await _apiClient.get(
        url: BusinessEndpoint.businesses(
      filteredBy: filteredBy,
      addressId: addressId,
    ));
    if (res.isSuccessful) {
      return BusinessResponse.fromJson(res.data);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<ProductResponse> getProducts({
    required String vendorId,
    required String branchId,
    required String category,
  }) async {
    final res = await _apiClient.get(
        url: BusinessEndpoint.products(vendorId, category, branchId));
    if (res.isSuccessful) {
      return ProductResponse.fromJson(res.data);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<BusinessResponse> search(String searchTerm) async {
    final res = await _apiClient.get(url: BusinessEndpoint.search(searchTerm));
    if (res.isSuccessful) {
      return BusinessResponse.fromJson(res.data);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<TransactionResponse> getTransactions(int page) async {
    final res = await _apiClient.get(url: BusinessEndpoint.transactions(page));
    if (res.isSuccessful) {
      return TransactionResponse.fromJson(res.data!);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<BusinessResponse> getGuestBusinesses({
    required String address,
    required String latitude,
    required String longitude,
  }) async {
    final res = await _apiClient.post(
      url: BusinessEndpoint.guestBusinesses,
      body: {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      },
    );
    if (res.isSuccessful) {
      return BusinessResponse.fromJson(res.data!);
    }
    throw CustomException(message: res.message!);
  }

  @override
  Future<ProductResponse> guestProducts({required String vendorId}) async {
    final res =
        await _apiClient.get(url: BusinessEndpoint.guestProducts(vendorId));
    if (res.isSuccessful) {
      return ProductResponse.fromJson(res.data);
    }
    throw CustomException(message: res.message!);
  }
}
