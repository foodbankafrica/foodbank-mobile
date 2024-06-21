import 'package:food_bank/core/errors/custom_exeption.dart';
import 'package:food_bank/core/networks/api_clients.dart';

import '../../../../core/cache/cache_key.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/user_response.dart';
import 'auth_endpoints.dart';

abstract class AuthRemoteSource {
  Future<UserResponse> register({
    required String firstName,
    required String lastName,
    required String organizationName,
    required String phone,
    required String userType,
    required String email,
    required String password,
    required String referralCode,
  });

  Future<UserResponse> login({
    required String emailOrPhone,
    required String password,
  });
  Future<String> forgetPassword({
    required String email,
  });
  Future<String> verifyForgotPassword({
    required String email,
    required String otp,
  });
  Future<String> resetPassword({
    required String password,
    required String confirmPassword,
  });

  Future<UserResponse> verifyOtp({
    required String otp,
  });

  Future<String> resendOtp();
  Future<UserResponse> me();

  Future<String> saveAvatar({
    required String avatar,
  });
  Future<String> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });
  Future<String> updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  });
  Future<String> setFcmToken(String token);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiClient _apiClient;
  final CacheStore _cacheStore;
  AuthRemoteSourceImpl(
      {required ApiClient apiClient, required CacheStore cacheStore})
      : _apiClient = apiClient,
        _cacheStore = cacheStore;

  @override
  Future<UserResponse> register({
    required String firstName,
    required String lastName,
    required String organizationName,
    required String phone,
    required String userType,
    required String email,
    required String password,
    required String referralCode,
  }) async {
    final response = await _apiClient.post(
      url: AuthEndpoint.register,
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "organization_name": organizationName,
        "phone": phone,
        "user_type": userType,
        "email": email,
        "password": password,
        "referral_code": referralCode,
      },
    );
    if (response.isSuccessful) {
      final userResponse = UserResponse.fromJson(response.data);
      _cacheStore.store(key: CacheKey.token, data: userResponse.access?.token);
      return userResponse;
    }
    throw CustomException(message: response.error!);
  }

  @override
  Future<UserResponse> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await _apiClient.post(
      url: AuthEndpoint.login,
      body: {
        "email": emailOrPhone,
        "password": password,
      },
    );
    if (response.isSuccessful) {
      final userResponse = UserResponse.fromJson(response.data);
      _cacheStore.store(key: CacheKey.token, data: userResponse.token);
      return userResponse;
    }
    throw CustomException(message: response.error!);
  }

  @override
  Future<String> saveAvatar({required String avatar}) async {
    final response = await _apiClient.patch(
      url: AuthEndpoint.saveAvatar,
      body: {
        "avatar": avatar,
      },
    );
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<UserResponse> verifyOtp({required String otp}) async {
    final response = await _apiClient.post(
      url: AuthEndpoint.verifyOtp,
      body: {
        "otp": otp,
      },
    );
    if (response.isSuccessful) {
      final userResponse = UserResponse.fromJson(response.data);
      _cacheStore.store(
        key: CacheKey.token,
        data: userResponse.access!.token,
      );
      return userResponse;
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<String> resendOtp() async {
    final response = await _apiClient.get(
      url: AuthEndpoint.resendOtp,
    );
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<UserResponse> me() async {
    final response = await _apiClient.get(
      url: AuthEndpoint.me,
    );
    if (response.isSuccessful) {
      return UserResponse.fromJson(response.data);
    }
    throw CustomException(message: response.message!);
  }

  @override
  Future<String> forgetPassword({required String email}) async {
    final response = await _apiClient.post(
      url: AuthEndpoint.forgotPassword,
      body: {
        "email": email,
      },
    );
    if (response.isSuccessful) {
      return response.message!;
    }
    throw CustomException(message: response.error!);
  }

  @override
  Future<String> verifyForgotPassword({
    required String email,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      url: AuthEndpoint.verifyForgotPassword,
      body: {
        "email": email,
        "otp": otp,
      },
    );
    if (response.isSuccessful) {
      final userResponse = UserResponse.fromJson(response.data);
      _cacheStore.store(key: CacheKey.token, data: userResponse.token);
      return response.message!;
    }
    throw CustomException(message: response.error!);
  }

  @override
  Future<String> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      url: AuthEndpoint.resetPassword,
      body: {
        "password": password,
        "password_confirmation": confirmPassword,
      },
    );
    if (response.isSuccessful) {
      _cacheStore.remove(key: CacheKey.token);
      return response.message!;
    }
    throw CustomException(message: response.error!);
  }

  @override
  Future<String> changePassword(
      {required String currentPassword,
      required String password,
      required String passwordConfirmation}) async {
    final response =
        await _apiClient.patch(url: AuthEndpoint.changePassword, body: {
      "current_password": currentPassword,
      "password": password,
      "password_confirmation": passwordConfirmation,
    });
    if (response.isSuccessful) {
      return response.data["message"] ?? response.message ?? '';
    }
    throw CustomException(message: response.error!);
  }

  @override
  Future<String> updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    final response = await _apiClient.put(
      url: AuthEndpoint.updateUser,
      body: {
        "first_name": firstName,
        "last_name": lastName,
        // "email": email,
        "phone": phone,
      },
    );
    if (response.isSuccessful) {
      return response.message ?? response.data["message"] ?? '';
    }
    throw CustomException(message: response.error!);
  }

  @override
  Future<String> setFcmToken(String token) async {
    final response = await _apiClient.patch(
      url: AuthEndpoint.updateFCMToken,
      body: {
        "fcm_token": token,
      },
    );
    if (response.isSuccessful) {
      return response.message ?? response.data["message"] ?? '';
    }
    throw CustomException(message: response.error!);
  }
}
