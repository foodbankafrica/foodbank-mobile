import 'package:food_bank/core/errors/custom_exeption.dart';
import 'package:food_bank/core/networks/api_clients.dart';

import 'kyc_endpoint.dart';

abstract class KycRemote {
  Future<String> kyc({
    required String bvn,
    required String dob,
    required String address,
    required String gender,
    required String phone,
  });
}

class KycRemoteImpl implements KycRemote {
  final ApiClient _apiClient;

  KycRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  @override
  Future<String> kyc({
    required String bvn,
    required String dob,
    required String address,
    required String gender,
    required String phone,
  }) async {
    final response = await _apiClient.post(
      url: KycEndpoint.kyc,
      body: {
        "bvn": bvn,
        "dob": dob,
        "address": address,
        "gender": gender,
        "phone": phone,
      },
    );
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.message!);
  }
}
