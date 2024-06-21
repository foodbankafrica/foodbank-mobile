import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/errors/custom_exeption.dart';
import 'package:food_bank/core/networks/api_clients.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/data_source/address/address_endpoint.dart';

import '../../models/address_model.dart';
import '../../models/search_address.dart';

abstract class AddressRemote {
  Future<String> addAddress({
    required String address,
    required double longitude,
    required double latitude,
  });
  Future<AddressResponse> getAddresses();
  Future<String> markAddressDefault({
    required String addressId,
  });
  Future<String> updateAddress({
    required String addressId,
    required String address,
  });
  Future<String> deleteAddress({
    required String addressId,
  });
  Future<SearchAddressResponse> searchAddress({
    required String searchAddress,
  });
}

class AddressRemoteImpl implements AddressRemote {
  final ApiClient _apiClient;

  AddressRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  @override
  Future<String> addAddress({
    required String address,
    required double longitude,
    required double latitude,
  }) async {
    final response = await _apiClient.post(
      url: AddressEndpoint.addAddress,
      body: {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      },
    );
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<String> deleteAddress({required String addressId}) async {
    final response = await _apiClient.delete(
      url: AddressEndpoint.deleteAddress(addressId),
    );
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<AddressResponse> getAddresses() async {
    try {
      final response = await _apiClient.get(
        url: AddressEndpoint.addresses,
      );
      '$response'.log();
      if (response.isSuccessful) {
        return AddressResponse.fromJson(response.data);
      }
      throw CustomException(message: response.message!);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<String> markAddressDefault({required String addressId}) async {
    final response = await _apiClient.put(
      url: AddressEndpoint.markDefault(addressId),
      body: {},
    );
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<String> updateAddress(
      {required String addressId, required String address}) async {
    final response = await _apiClient
        .put(url: AddressEndpoint.deleteAddress(addressId), body: {
      "address": address,
    });
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<SearchAddressResponse> searchAddress(
      {required String searchAddress}) async {
    final response = await _apiClient.get(
      url: AddressEndpoint.searchAddress(searchAddress),
    );
    print(response.isSuccessful);
    print(response.data);
    if (response.isSuccessful) {
      return SearchAddressResponse.fromJson({"results": response.data});
    }
    throw CustomException(message: "An Unknown Error Occur");
  }
}
