import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/auth/presentation/screens/password_reset_success_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets.dart';
import '../../cache/user_cache.dart';
import '../bloc/auth_bloc.dart';
import 'signin_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String name = 'reset-password';
  static String route = '/reset-password';
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final UserCache userCache = UserCache.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your desired new password.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  CustomPasswordInput(
                    controller: passwordController,
                    labelText: 'New Password',
                    hintText: "Enter new password",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomPasswordInput(
                    controller: confirmPasswordController,
                    labelText: 'Confirm New Password',
                    hintText: "Confirm your new password",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      } else if (value != passwordController.text) {
                        return 'Password not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is ResettingPasswordFail) {
                        context.buildError(state.error);
                      } else if (state is ResettingPasswordSuccessful) {
                        context.toast(content: state.message);

                        context.go(ResetPasswordSuccessScreen.route);
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        isLoading: state is ResettingPassword,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthBloc>().add(
                                ResetPasswordEvent(
                                  confirmPassword: passwordController.text,
                                  password: confirmPasswordController.text,
                                ),
                              );
                        },
                        text: 'Reset Password',
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 0.5,
                          width: 20,
                          color: const Color(0xFF98A2B3),
                        ),
                      ),
                      Text(
                        ' Or ',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF98A2B3),
                            ),
                      ),
                      Expanded(
                        child: Container(
                          height: 0.5,
                          width: 20,
                          color: const Color(0xFF98A2B3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      Text(
                        'Remember your password ?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          context.go(SignInScreen.route);
                        },
                        child: Text(
                          'Login',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFEB5017),
                                  ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
