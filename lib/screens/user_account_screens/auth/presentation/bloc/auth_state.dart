part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Registering extends AuthState {}

class RegistrationSuccessful extends AuthState {
  final UserResponse user;
  RegistrationSuccessful(this.user);
}

class RegistrationFail extends AuthState {
  final String error;
  RegistrationFail(this.error);
}

class Signing extends AuthState {}

class SigningSuccessful extends AuthState {
  final UserResponse user;
  SigningSuccessful(this.user);
}

class SigningFail extends AuthState {
  final String error;
  SigningFail(this.error);
}

class ForgettingPassword extends AuthState {}

class ForgettingPasswordSuccessful extends AuthState {
  final String message;
  ForgettingPasswordSuccessful(this.message);
}

class ForgettingPasswordFail extends AuthState {
  final String error;
  ForgettingPasswordFail(this.error);
}

class VerifyingForgetPassword extends AuthState {}

class VerifyingForgetPasswordSuccessful extends AuthState {
  final String message;
  VerifyingForgetPasswordSuccessful(this.message);
}

class VerifyingForgetPasswordFail extends AuthState {
  final String error;
  VerifyingForgetPasswordFail(this.error);
}

class ResendForgetPasswordOtp extends AuthState {}

class ResendForgetPasswordOtpSuccessful extends AuthState {
  final String message;
  ResendForgetPasswordOtpSuccessful(this.message);
}

class ResendForgetPasswordOtpFail extends AuthState {
  final String error;
  ResendForgetPasswordOtpFail(this.error);
}

class ResettingPassword extends AuthState {}

class ResettingPasswordSuccessful extends AuthState {
  final String message;
  ResettingPasswordSuccessful(this.message);
}

class ResettingPasswordFail extends AuthState {
  final String error;
  ResettingPasswordFail(this.error);
}

class VerifyingOtp extends AuthState {}

class VerifyingOtpSuccessful extends AuthState {
  final UserResponse user;
  VerifyingOtpSuccessful(this.user);
}

class VerifyingOtpFail extends AuthState {
  final String error;
  VerifyingOtpFail(this.error);
}

class GettingMe extends AuthState {}

class GettingMeSuccessful extends AuthState {
  final UserResponse user;
  GettingMeSuccessful(this.user);
}

class GettingMeFail extends AuthState {
  final String error;
  GettingMeFail(this.error);
}

class ResendingOtp extends AuthState {}

class ResendingOtpSuccessful extends AuthState {
  final String message;
  ResendingOtpSuccessful(this.message);
}

class ResendingOtpFail extends AuthState {
  final String error;
  ResendingOtpFail(this.error);
}

class SavingAvatar extends AuthState {}

class SavingAvatarSuccessful extends AuthState {
  final String message;
  SavingAvatarSuccessful(this.message);
}

class SavingAvatarFail extends AuthState {
  final String error;
  SavingAvatarFail(this.error);
}

class ChangingPassword extends AuthState {}

class ChangingPasswordSuccessful extends AuthState {
  final String message;
  ChangingPasswordSuccessful(this.message);
}

class ChangingPasswordFail extends AuthState {
  final String error;
  ChangingPasswordFail(this.error);
}

class UpdatingAccount extends AuthState {}

class UpdatingAccountSuccessful extends AuthState {
  final String message;
  UpdatingAccountSuccessful(this.message);
}

class UpdatingAccountFail extends AuthState {
  final String error;
  UpdatingAccountFail(this.error);
}
