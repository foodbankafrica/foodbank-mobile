import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/errors/failure.dart';
import 'package:food_bank/core/networks/do_internet_check.dart';
import 'package:food_bank/core/networks/internet_info.dart';
import 'package:food_bank/core/utils/handle_error.dart';
import 'package:fpdart/fpdart.dart';

import '../data_source/auth_remote_source.dart';
import '../models/user_response.dart';

abstract class AuthService {
  TaskEither<Failure, UserResponse> register({
    required String firstName,
    required String lastName,
    required String organizationName,
    required String phone,
    required String userType,
    required String email,
    required String password,
    required String referralCode,
  });

  TaskEither<Failure, UserResponse> login({
    required String emailOrPhone,
    required String password,
  });

  TaskEither<Failure, String> forgetPassword({
    required String email,
  });
  TaskEither<Failure, String> verifyForgotPassword({
    required String email,
    required String otp,
  });
  TaskEither<Failure, String> resetPassword({
    required String password,
    required String confirmPassword,
  });

  TaskEither<Failure, UserResponse> me();

  TaskEither<Failure, UserResponse> verifyOtp({
    required String otp,
  });
  TaskEither<Failure, String> resendOtp();

  TaskEither<Failure, String> saveAvatar({
    required String avatar,
  });
  TaskEither<Failure, String> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });
  TaskEither<Failure, String> updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  });
  TaskEither<Failure, void> setFcmToken(String token);
}

class AuthServiceImpl extends AuthService with HandleError, DoInternetCheck {
  final NetworkInfo _networkInfo;
  final AuthRemoteSource _authRemoteSource;

  AuthServiceImpl({
    required NetworkInfo networkInfo,
    required AuthRemoteSource authRemoteSource,
  })  : _authRemoteSource = authRemoteSource,
        _networkInfo = networkInfo;

  @override
  TaskEither<Failure, UserResponse> register({
    required String firstName,
    required String lastName,
    required String organizationName,
    required String phone,
    required String userType,
    required String email,
    required String password,
    required String referralCode,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.register(
            firstName: firstName,
            lastName: lastName,
            organizationName: organizationName,
            phone: phone,
            userType: userType,
            email: email,
            password: password,
            referralCode: referralCode,
          );
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, UserResponse> login({
    required String emailOrPhone,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.login(
            emailOrPhone: emailOrPhone,
            password: password,
          );
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> saveAvatar({required String avatar}) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.saveAvatar(
            avatar: avatar,
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
  TaskEither<Failure, UserResponse> verifyOtp({required String otp}) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.verifyOtp(
            otp: otp,
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
  TaskEither<Failure, String> resendOtp() {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.resendOtp();
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
  TaskEither<Failure, UserResponse> me() {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.me();
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> forgetPassword({required String email}) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.forgetPassword(email: email);
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
  TaskEither<Failure, String> verifyForgotPassword({
    required String email,
    required String otp,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.verifyForgotPassword(
              email: email, otp: otp);
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
  TaskEither<Failure, String> resetPassword({
    required String password,
    required String confirmPassword,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.resetPassword(
            password: password,
            confirmPassword: confirmPassword,
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
  TaskEither<Failure, String> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.changePassword(
            currentPassword: currentPassword,
            password: password,
            passwordConfirmation: passwordConfirmation,
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
  TaskEither<Failure, String> updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _authRemoteSource.updateUser(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
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
  TaskEither<Failure, void> setFcmToken(String token) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          await _authRemoteSource.setFcmToken(token);
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace";
        return handleError(error);
      },
    );
  }
}
