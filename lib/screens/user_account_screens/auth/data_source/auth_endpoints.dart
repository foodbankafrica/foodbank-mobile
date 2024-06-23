import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthEndpoint {
  static String baseURL = '${dotenv.env['API_BASE_URL']}/m';

  static String register = '$baseURL/v1/auth/register';
  static String login = '$baseURL/v1/auth/login';
  static String forgotPassword = '$baseURL/v1/auth/forgot-password';
  static String verifyForgotPassword =
      '$baseURL/v1/auth/forgot-password/verify-otp';
  static String resetPassword =
      '$baseURL/v1/auth/forgot-password/reset-password';
  static String me = '$baseURL/v1/user';
  static String verifyOtp = '$baseURL/v1/auth/otp';
  static String resendOtp = '$baseURL/v1/auth/resend-otp';
  static String saveAvatar = '$baseURL/v1/avatar';
  static String changePassword = '$baseURL/v1/user/password';
  static String updateUser = '$baseURL/v1/user';
  static String updateFCMToken = '$baseURL/v1/user/fcm-token';
}
