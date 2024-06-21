import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../models/user_response.dart';
import '../services/auth_services.dart';

class AuthFacade {
  final AuthService _authService;
  AuthFacade({required AuthService authService}) : _authService = authService;

  Future<Either<Failure, UserResponse>> register({
    required String firstName,
    required String lastName,
    required String organizationName,
    required String userType,
    required String phone,
    required String email,
    required String password,
    required String referralCode,
  }) {
    return _authService
        .register(
          firstName: firstName,
          lastName: lastName,
          organizationName: organizationName,
          phone: phone,
          userType: userType,
          email: email,
          password: password,
          referralCode: referralCode,
        )
        .run();
  }

  Future<Either<Failure, UserResponse>> login({
    required String emailOrPhone,
    required String password,
  }) {
    return _authService
        .login(
          emailOrPhone: emailOrPhone,
          password: password,
        )
        .run();
  }

  Future<Either<Failure, String>> forgetPassword({
    required String email,
  }) {
    return _authService.forgetPassword(email: email).run();
  }

  Future<Either<Failure, String>> verifyForgotPassword({
    required String email,
    required String otp,
  }) {
    return _authService
        .verifyForgotPassword(
          email: email,
          otp: otp,
        )
        .run();
  }

  Future<Either<Failure, String>> resetPassword({
    required String password,
    required String confirmPassword,
  }) {
    return _authService
        .resetPassword(
          password: password,
          confirmPassword: confirmPassword,
        )
        .run();
  }

  Future<Either<Failure, String>> saveAvatar({
    required String avatar,
  }) {
    return _authService.saveAvatar(avatar: avatar).run();
  }

  Future<Either<Failure, UserResponse>> verifyOtp({
    required String otp,
  }) {
    return _authService.verifyOtp(otp: otp).run();
  }

  Future<Either<Failure, String>> resendOtp() {
    return _authService.resendOtp().run();
  }

  Future<Either<Failure, UserResponse>> me() {
    return _authService.me().run();
  }

  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return _authService
        .changePassword(
          currentPassword: currentPassword,
          password: password,
          passwordConfirmation: passwordConfirmation,
        )
        .run();
  }

  Future<Either<Failure, String>> updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    return _authService
        .updateUser(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone)
        .run();
  }

  Future<Either<Failure, void>> setFcmToken(String token) {
    return _authService.setFcmToken(token).run();
  }
}
