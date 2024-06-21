class AuthEndpoint {
  static const String baseURL = "https://api-dev.foodbank.africa/m";

  static const String register = '$baseURL/v1/auth/register';
  static const String login = '$baseURL/v1/auth/login';
  static const String forgotPassword = '$baseURL/v1/auth/forgot-password';
  static const String verifyForgotPassword =
      '$baseURL/v1/auth/forgot-password/verify-otp';
  static const String resetPassword =
      '$baseURL/v1/auth/forgot-password/reset-password';
  static const String me = '$baseURL/v1/user';
  static const String verifyOtp = '$baseURL/v1/auth/otp';
  static const String resendOtp = '$baseURL/v1/auth/resend-otp';
  static const String saveAvatar = '$baseURL/v1/avatar';
  static const String changePassword = '$baseURL/v1/user/password';
  static const String updateUser = '$baseURL/v1/user';
  static const String updateFCMToken = '$baseURL/v1/user/fcm-token';
}
