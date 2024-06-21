part of 'auth_bloc.dart';

abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String organizationName;
  final String phone;
  final String email;
  final String password;
  final String referralCode;
  final String userType;
  RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.userType,
    this.referralCode = "",
    this.organizationName = "",
  });
}

class LoginEvent extends AuthEvent {
  final String emailOrPhone;
  final String password;

  LoginEvent({
    required this.emailOrPhone,
    required this.password,
  });
}

class ForgetPasswordEvent extends AuthEvent {
  final String email;

  ForgetPasswordEvent({
    required this.email,
  });
}

class ResendForgetPasswordOtpEvent extends AuthEvent {
  final String email;

  ResendForgetPasswordOtpEvent({
    required this.email,
  });
}

class VerifyForgotPasswordEvent extends AuthEvent {
  final String email;
  final String otp;

  VerifyForgotPasswordEvent({
    required this.email,
    required this.otp,
  });
}

class ResetPasswordEvent extends AuthEvent {
  final String password;
  final String confirmPassword;

  ResetPasswordEvent({
    required this.password,
    required this.confirmPassword,
  });
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  VerifyOtpEvent({
    required this.otp,
  });
}

class ResendOtpEvent extends AuthEvent {}

class GetMeEvent extends AuthEvent {}

class SaveAvatarEvent extends AuthEvent {
  final String avatar;
  SaveAvatarEvent({
    required this.avatar,
  });
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String password;
  final String confirmPassword;

  ChangePasswordEvent({
    required this.currentPassword,
    required this.password,
    required this.confirmPassword,
  });
}

class UpdateAccountEvent extends AuthEvent {
  final String email, phone, firstName, lastName;

  UpdateAccountEvent({
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.phone,
  });
}
