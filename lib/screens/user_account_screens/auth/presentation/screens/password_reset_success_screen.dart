import 'package:flutter/material.dart';
import 'package:food_bank/screens/user_account_screens/auth/presentation/screens/signin_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/success_screen.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  static String name = 'password-reset-success';
  static String route = '/password-reset-success';
  const ResetPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: "Reset Password Successful",
      subtitle:
          "Your password has been successfully reset. You can now use your new password to log in to your account",
      buttonText: "Login",
      onClick: () {
        context.go(SignInScreen.route);
      },
    );
  }
}
